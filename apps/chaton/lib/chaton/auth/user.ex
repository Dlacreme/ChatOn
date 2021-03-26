defmodule Chaton.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :meta, :map, null: true
    field :disabled_at, :utc_datetime
    timestamps()
  end

  def changeset_meta(user, meta) do
    user
    |> cast(%{meta: meta}, [:meta])
  end

end
