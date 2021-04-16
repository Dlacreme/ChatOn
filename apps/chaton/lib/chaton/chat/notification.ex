defmodule Chaton.Chat.Notification do
  @moduledoc """
  Chat.Notification is a Database Wrapper for Chaton.Notification
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notifications" do
    field(:message_id, :binary_id, null: false)
    field(:notification, :map, null: false, default: %{})
    belongs_to :user, Chaton.Auth.User
    timestamps(updated_at: false)
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:user_id, :message_id, :notification])
    |> validate_required([:user_id, :message_id, :notification])
  end
end
