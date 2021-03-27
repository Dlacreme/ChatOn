defmodule Chaton.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :meta, :map, null: false, default: %{}
    field :disabled_at, :utc_datetime
    timestamps()
  end

  def changeset_meta(user, meta) do
    user
    |> cast(%{meta: meta}, [:meta])
  end
end

defimpl Jason.Encoder, for: Chaton.Auth.User do
  def encode(value, opts) do
    Jason.Encode.map(Map.take(value, [:id, :meta]), opts)
  end
end
