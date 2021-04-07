defmodule Chaton.Repo.Migrations.CreateRoomMessages do
  use Ecto.Migration

  def change do
    create table(:room_messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id), null: false
      add :content, :text

      timestamps(updated_at: false)
    end

  end
end
