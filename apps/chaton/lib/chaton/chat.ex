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

  @spec send_message(%User{}, %User{} | %Room{}, String.t()) :: :ok
  def send_message(user = %User{}, to, content) do
    {:ok, notifs} = message_to_notifications(user, to, content)
    Enum.map(notifs, fn n -> send_notification(n) end)
    :ok
  end

  @spec message_to_notifications(%User{}, %Room{} | %User{}, String.t()) ::
          {:ok, []}
  def message_to_notifications(user = %User{}, room = %Room{}, content) do
    {:ok,
     room
     |> Repo.preload(:room_users)
     |> Enum.map(fn u ->
       %Chaton.Notification{from: user, to: u, context: room, content: content}
     end)}
  end

  def message_to_notifications(user = %User{}, to_user = %User{}, content) do
    {:ok, [%Chaton.Notification{from: user, to: to_user, content: content}]}
  end

  def send_notification(notif = %Chaton.Notification{}) do
    case get_user_socket?(notif.to) do
      nil ->
        save_notification(notif)

      socket ->
        push_notification(socket, notif)
    end
  end

  @spec get_user_socket?(%User{}) :: term() | nil
  defp get_user_socket?(_user) do
    nil
  end

  defp save_notification(_notif) do
  end

  defp push_notification(_socket, _notif) do
  end
end
