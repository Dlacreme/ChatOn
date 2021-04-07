defmodule Chaton.Repo.Migrations.AddCreatedByToRoom do
  use Ecto.Migration

  def change do
    alter table("rooms") do
      add :created_by_id, references(:users, type: :binary_id), null: false
      add :label, :string, default: "", null: false
    end
  end
end
