defmodule ChatonWeb.Router do
  use ChatonWeb, :router

  import Phoenix.LiveDashboard.Router

  ## Admin Web App
  import ChatonWeb.AuthController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ChatonWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(:fetch_current_admin)
  end

  scope "/app", ChatonWeb do
    pipe_through([:browser, :redirect_if_admin_is_authenticated])

    get("/login", AuthController, :new)
    post("/login", AuthController, :create)
  end

  scope "/app", ChatonWeb do
    pipe_through([:browser, :require_authenticated_admin])

    delete("/logout", AuthController, :delete)

    live "/", HomeLive, :index
    live_dashboard "/dashboard", metrics: ChatonWeb.Telemetry
  end

  ## Admin API
  import ChatonWeb.ApiController

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatonWeb do
    pipe_through([:api])
    get("/", ApiController, :index)
  end

  scope "/", ChatonWeb do
    pipe_through([:api, :require_api_key])

    get("/auth", ApiController, :auth_guest)
    get("/auth/:user_id", ApiController, :auth_user)
    get("/user/:user_id", ApiController, :get_user)
    get("/user/", ApiController, :search_user)
    post("/user", ApiController, :create_user)
    post("/user/:user_id", ApiController, :edit_user)
  end

  ## Public Socket Handler
  pipeline :channel do
  end

  scope "/channel", ChatonWeb do
    pipe_through([:channel])
  end
end
