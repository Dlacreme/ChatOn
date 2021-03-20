defmodule ChatonWeb.AuthController do
  use ChatonWeb, :controller
  import Plug.Conn
  import Phoenix.Controller
  alias Chaton.Auth

  ## Pages

  def login(conn, _params) do
    changeset = Auth.change_user_registration(%Auth.Admin{})
    render(conn, "login.html", changeset: changeset)
  end

  ## Pipes
  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: "/")
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> redirect(external: "https://github.com/dlacreme/chaton")
      |> halt()
    end
  end
end
