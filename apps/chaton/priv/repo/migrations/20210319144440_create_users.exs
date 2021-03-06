defmodule Chaton.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :meta, :map, null: false, default: %{}
      add :disabled_at, :naive_datetime, null: true
      timestamps()
    end

    create index(:users, [:id])

    create table(:user_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: true
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      add :expired_at, :naive_datetime, null: true
      timestamps(updated_at: false)
    end

    create index(:user_tokens, [:user_id])
    create unique_index(:user_tokens, [:context, :token])

  end
end
