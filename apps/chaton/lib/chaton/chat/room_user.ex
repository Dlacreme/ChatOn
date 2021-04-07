defmodule Chaton.Chat.RoomUser do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "room_users" do
    field :room_id, Ecto.UUID
    field :user_id, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(room_user, attrs) do
    room_user
    |> cast(attrs, [:room_id, :user_id])
    |> validate_required([:room_id, :user_id])
  end
end
