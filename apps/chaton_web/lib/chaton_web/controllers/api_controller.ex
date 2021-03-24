defmodule ChatonWeb.ApiController do
  use ChatonWeb, :controller
  import Plug.Conn
  import Phoenix.Controller

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
    IO.puts("\n\nCONN > #{inspect(conn)}")
    conn
  end
end
