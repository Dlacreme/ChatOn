defmodule Chaton.Chat do
  @moduledoc """
  This module handles the chat rooms as well as the direct messages
  """
  import Ecto.Query

  alias Chaton.Repo
  alias Chaton.Auth.User
  alias Chaton.Chat.Room
  alias Chaton.Chat.RoomUser
  alias Chaton.Chat.Message
  alias Chaton.Chat.RoomMessage
  alias Chaton.Chat.Notification

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

  @spec send_message!(%User{}, %User{}, String.t()) ::
          list(%Chaton.Notification{})
  def send_message!(user = %User{}, to = %User{}, content) do
    message =
      %Message{}
      |> Message.changeset(%{user_id: user.id, to_id: to.id, content: content})
      |> Repo.insert!()

    notifs = generate_notifications(user, to, content)
    notifs |> Enum.each(fn x -> save_notification(x, message.id) end)
    notifs
    ## ChatonWeb should handle the sockets
    # |> Enum.each(fn x ->
    #   with _ <- save_notification(x, message.id),
    #      _ <- send_notification(x)
    #   do :ok end
    # end)
  end

  # def send_message(user = %User{}, to = %Room{}, content) do
  # end

  @spec generate_notifications(%User{}, %User{} | %Room{}, String.t()) ::
          list(%Chaton.Notification{})
  defp generate_notifications(user = %User{}, to = %User{}, content) do
    [
      %Chaton.Notification{
        from: user,
        to: to,
        content: content
      }
    ]
  end

  @spec save_notification(%Chaton.Notification{}, term()) :: %Notification{}
  defp save_notification(notif = %Chaton.Notification{}, message_id) do
    %Notification{}
    |> Notification.changeset(%{
      user_id: notif.to.id,
      message_id: message_id,
      notification: notif
    })
    |> Repo.insert!()
  end

  ## ChatonWeb should send the notifications over sockets?
  # @spec send_notification(%Chaton.Notification{}) :: :ok
  # defp send_notification(notif = %Chaton.Notification{}) do
  #   :ok
  # end
end
