defmodule ChatonWeb.ApiController do
  use ChatonWeb, :controller
  import Plug.Conn
  import Phoenix.Controller

  @api_key_header_name "x-api-key"
  @api_key System.get_env("API_KEY", "dev")

  ## Handlers

  @doc """
  """
  def index(conn, _opts) do
    conn
    |> render("index.json", %{})
  end

  @doc """
  Create an authentication token for a guest user
  """
  def auth_guest(conn, _opts) do
    conn
    |> encode_token(Chaton.Auth.UserToken.generate_token())
  end

  @doc """
  Create an authentication token for a user
  """
  def auth_user(conn, %{"user_id" => user_id}) do
    case Chaton.Repo.get_by(Chaton.Auth.User, id: user_id) do
      nil ->
        conn
        |> put_status(:undefined)
        |> render("error.json", %{message: "Not found"})

      user ->
        conn
        |> encode_token(Chaton.Auth.UserToken.generate_token(user))
    end
  end

  @doc """
  Get a user by ID
  """
  def get_user(conn, %{"user_id" => user_id}) do
    case Chaton.Repo.get_by(Chaton.Auth.User, id: user_id) do
      nil ->
        conn
        |> put_status(:undefined)
        |> render("error.json", %{message: "Not found"})

      user ->
        conn
        |> render("user.json", %{user: user})
    end
  end

  @doc """
  Search for a user using its metadata
  """
  def search_user(conn, %{"query" => q}) do
    case Chaton.Auth.User.search_by_metadata(q) do
      {:ok, users} ->
        conn
        |> render("users.json", %{users: users})

      {:error, _} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", %{message: "Invalid query. Format should be {\"id\": \"yourid\"}"})
    end
  end

  @doc """
  Create a new user
  """
  def create_user(conn, _opts) do
    user_changeset = Chaton.Auth.User.changeset_meta(%Chaton.Auth.User{}, conn.body_params)

    conn
    |> render("user.json", %{user: Chaton.Repo.insert!(user_changeset)})
  end

  @doc """
  Edit an existing user using its ID
  """
  def edit_user(conn, %{"user_id" => user_id}) do
    conn |> update_user(Chaton.Repo.get_by(Chaton.Auth.User, id: user_id))
  end

  defp update_user(conn, %Chaton.Auth.User{} = user) do
    conn
    |> render("user.json", %{
      user:
        user
        |> Chaton.Auth.User.changeset_meta(conn.body_params)
        |> Chaton.Repo.update!()
    })
  end

  defp update_user(conn, _) do
    conn
    |> put_status(:undefined)
    |> render("error.json", "User not found")
  end

  ## Pipes

  @doc """
  Make sure request has a valid API key
  """
  def require_api_key(conn, _opts) do
    case Enum.find(conn.req_headers, fn h -> elem(h, 0) == @api_key_header_name end) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> put_view(ChatonWeb.ApiView)
        |> render("error.json", %{message: "Incorrect headers."})
        |> halt()

      header ->
        check_api_key(conn, elem(header, 1))
    end
  end

  defp check_api_key(conn, api_key) when api_key == @api_key do
    conn
  end

  defp check_api_key(conn, _api_key) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ChatonWeb.ApiView)
    |> render("error.json", %{message: "Invalid headers."})
    |> halt()
  end

  defp encode_token(conn, {token, _user_token}) do
    conn
    |> put_view(ChatonWeb.ApiView)
    |> render("auth.json", %{token: Base.url_encode64(token)})
  end
end
