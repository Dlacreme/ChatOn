defmodule Chaton.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rooms" do
    field :created_by_id, :binary_id
    field :disabled_at, :naive_datetime

    has_many :room_users, Chaton.Chat.RoomUser
    has_many :users, through: [:room_users, :user]

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [])
    |> validate_required([])
  end
end
