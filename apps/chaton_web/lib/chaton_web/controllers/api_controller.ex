defmodule ChatonWeb.ApiController do
  use ChatonWeb, :controller
  import Plug.Conn
  import Phoenix.Controller

  @api_key_header_name "api-key"
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
    |> insert_and_return_token(Chaton.Auth.UserToken.build_channel_token())
    # |> render("auth.json", %{token: Chaton.Auth.UserToken.build_channel_token()})
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
        |> insert_and_return_token(Chaton.Auth.UserToken.build_channel_token(user))
    end
  end

  @doc """
  Create a new user
  """
  def create_user(conn, opts) do
    user = Chaton.Repo.insert!(Chaton.Auth.User.changeset_meta(%{}, %{toto: "tata"}))
    conn
    |> render("user.json", %{user: user})
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

  defp insert_and_return_token(conn, {token, user_token}) do
    Chaton.Repo.insert!(user_token)
    conn
    |> put_view(ChatonWeb.ApiView)
    |> render("auth.json", %{token: Base.url_encode64(token)})
  end
end
