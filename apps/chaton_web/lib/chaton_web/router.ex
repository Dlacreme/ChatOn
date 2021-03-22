defmodule ChatonWeb.Router do
  use ChatonWeb, :router

  import Phoenix.LiveDashboard.Router

  ## Public Socket Handler

  ## Admin API
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ChatonWeb do
    pipe_through([:api, :require_authenticated_user])
  end

  ## Admin Web App
  import ChatonWeb.AuthController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ChatonWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ChatonWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    get("/login", AuthController, :new)
    post("/login", AuthController, :create)
  end

  scope "/", ChatonWeb do
    pipe_through([:browser, :require_authenticated_user])

    live "/", PageLive, :index
    live_dashboard "/dashboard", metrics: ChatonWeb.Telemetry
  end
end
