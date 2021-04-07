defmodule Chaton.Repo.Migrations.CreateRoomUsers do
  use Ecto.Migration

  def change do
    create table(:room_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :room_id, references(:rooms, type: :binary_id), null: false
      add :user_id, references(:users, type: :binary_id), null: false

      timestamps()
    end

  end
end
