defmodule Chaton.Repo do
  use Ecto.Repo,
    otp_app: :chaton,
    adapter: Ecto.Adapters.Postgres
end
