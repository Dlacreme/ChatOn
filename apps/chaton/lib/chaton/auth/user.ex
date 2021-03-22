defmodule Chaton.Auth.User do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :role_id, :string, default: "guest"
    field :meta, :map, null: true
    field :disabled_at, :utc_datetime
    timestamps()
  end
end
