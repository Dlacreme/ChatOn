defmodule Chaton.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :disabled_at, :naive_datetime

      timestamps()
    end

  end
end
