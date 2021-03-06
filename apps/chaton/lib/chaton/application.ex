defmodule Chaton.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Chaton.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Chaton.PubSub},
      # Start the CRON
      Chaton.Cron,
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Chaton.Supervisor)
  end
end
