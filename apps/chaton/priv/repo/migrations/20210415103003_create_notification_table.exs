defmodule Chaton.Repo.Migrations.CreateNotificationTable do
  use Ecto.Migration

  def change do
    create table(:notifications, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id), null: false
      add :notification, :map, null: false, default: %{}
      timestamps(updated_at: false)
    end

    create index(:notifications, [:user_id])
  end
end
