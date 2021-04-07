defmodule Chaton.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id), null: false
      add :to_id, references(:users, type: :binary_id), null: false
      add :content, :text

      timestamps()
    end

  end
end
