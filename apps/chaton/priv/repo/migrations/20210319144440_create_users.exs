defmodule Chaton.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do

    create table(:user_roles, primary_key: false) do
      add :id, :string, primary_key: true
      add :label, :string, null: false
    end

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role_id, references(:user_roles, type: :string), null: false
      add :meta, :map, null: true
      add :disabled_at, :naive_datetime, null: true
      timestamps()
    end

    create index(:users, [:id])

    create table(:user_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
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
