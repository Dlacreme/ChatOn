defmodule Chaton.Chat do
  @moduledoc """
  This module handles the chat rooms as well as the direct messages
  """
  import Ecto.Query

  alias Chaton.Repo
  alias Chaton.Auth.User
  alias Chaton.Chat.Room
  alias Chaton.Chat.RoomUser

  @doc """
  Returns all potential contacts. @query allows to filters using metadata
  """
  def list_users(q) when q == nil or q == "" do
    {:ok, Repo.all(from(u in User))}
  end

  def list_users(query) do
    User.filter_by_metadata(query)
  end

  ## Room

  @doc """
  Create a new room
  """
  def create_room(created_by_id, label \\ "") do
    case(
      %Room{}
      |> Room.changeset(%{created_by_id: created_by_id, label: label})
      |> Repo.insert()
    ) do
      {:ok, room} ->
        add_user_to_room(room.id, created_by_id)
        {:ok, room}

      {:error, err} ->
        {:error, err}
    end
  end

  @doc """
  Add a user to a room
  """
  def add_user_to_room(room_id, user_id) do
    %RoomUser{}
    |> RoomUser.changeset(%{room_id: room_id, user_id: user_id})
    |> Repo.insert()
  end

  @doc """
  Get all users for a room
  """
  def get_room_users(room_id), do: Repo.all(from ru in RoomUser, where: ru.room_id == ^room_id)

  @doc """
  Get all rooms for a user
  """
  def get_user_rooms(user_id),
    do: Repo.all(from u in User, join: r in assoc(u, :rooms), where: u.id == ^user_id, select: r)

  ## Message

  @spec send_message(%User{}, %Room{} | %User{}, String.t()) ::
          {:ok, %Chaton.Notification{}} | {:error, String.t()}
  def send_message(_from, _to, content) when content == "" do
    {:error, "Invalid message"}
  end

  def send_message(user = %User{}, room = %Room{}, content) do
    {:ok, %Chaton.Notification{from: user, to: room, content: content}}
  end

  def send_message(user = %User{}, to_user = %User{}, content) do
    {:ok, %Chaton.Notification{from: user, to: to_user, content: content}}
  end
end
