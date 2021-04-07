defmodule Chaton.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :content, :string

    belongs_to :user, Chaton.Auth.User

    belongs_to :to_user, Chaton.Auth.User,
      references: :id,
      type: :binary_id,
      foreign_key: :to_id

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user_id, :to, :content])
    |> validate_required([:user_id, :to, :content])
  end
end
