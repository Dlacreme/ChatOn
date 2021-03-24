defmodule ChatonWeb.ApiController do
  use ChatonWeb, :controller
  import Plug.Conn
  import Phoenix.Controller

  @api_key_header_name "api-key"
  @api_key System.get_env("API_KEY")

  ## Handlers

  @doc """
  """
  def index(conn, _opts) do
    conn
    |> render("index.json")
  end

  @doc """
  Create an authentication tocket for a guest user
  """
  def auth_guest(conn, _opts) do
    conn
    |> render("auth.json", %{token: "1234"})
  end

  @doc """
  Create an authentication tocket for a user
  """
  def auth_user(conn, _opts) do
    conn
    |> render("auth.json", %{token: "1234"})
  end

  @doc """
  Create a new user
  """
  def create_user(conn, _opts) do
    conn
    |> render("user.json", %{user: %{}})
  end

  ## Pipes

  @doc """
  Make sure the requets has a valid API key
  """
  def require_api_key(conn, _opts) do
    case Enum.find(conn.req_headers, fn h -> elem(h, 0) == @api_key_header_name end) do
      header -> check_api_key(conn, elem(header, 1))
      _ -> conn
            |> put_status(:unauthorized)
            |> render("error.json", %{message: "Missing API KEY"})
    end
  end

  defp check_api_key(conn, api_key) when api_key == @api_key do
    conn
  end

  defp check_api_key(conn, _api_key) do
    conn
      |> put_status(:unauthorized)
      |> render("error.json", %{message: "Invalid API KEY"})
  end

end
