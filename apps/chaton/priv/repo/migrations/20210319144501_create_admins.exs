defmodule Chaton.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:admins, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :citext, null: false
      add :hashed_password, :string, null: false

      timestamps()
    end

    create table(:admin_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :admin_id, references(:admins, type: :binary_id, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      add :expired_at, :naive_datetime, null: true
      timestamps(updated_at: false)
    end

    create index(:admin_tokens, [:user_id])
    create unique_index(:admin_tokens, [:context, :token])

  end
end
