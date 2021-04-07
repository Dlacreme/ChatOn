defmodule Chaton.Chat.RoomMessage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "room_messages" do
    field :content, :string
    belongs_to :room, Chaton.Chat.Room
    belongs_to :user, Chaton.Auth.User

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(room_message, attrs) do
    room_message
    |> cast(attrs, [:user_id, :content])
    |> validate_required([:user_id, :content])
  end
end
