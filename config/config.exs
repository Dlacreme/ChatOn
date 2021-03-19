# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :chaton,
  ecto_repos: [Chaton.Repo]

config :chaton_web,
  ecto_repos: [Chaton.Repo],
  generators: [context_app: :chaton, binary_id: true]

# Configures the endpoint
config :chaton_web, ChatonWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "J+I4JeHUuMUBvtXihkBx0KPRYBCCkJ4eaLEJrhdWWUfx5TFb6t8rQn5HtDFXDLcw",
  render_errors: [view: ChatonWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Chaton.PubSub,
  live_view: [signing_salt: "zoOzLkya"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
