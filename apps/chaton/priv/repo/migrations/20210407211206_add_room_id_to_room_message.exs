defmodule Chaton.Repo.Migrations.AddRoomIdToRoomMessage do
  use Ecto.Migration

  def change do
    alter table("room_messages") do
      add :room_id, references(:rooms, type: :binary_id), null: false
    end
  end
end
