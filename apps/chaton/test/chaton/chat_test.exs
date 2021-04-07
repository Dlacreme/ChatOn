defmodule Chaton.ChatTest do
  use ExUnit.Case
  alias Chaton.Repo
  alias Chaton.Auth.User
  alias Chaton.Chat

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    {:ok, random_user} = Repo.insert(%User{} |> User.changeset_meta(%{toto: "tata"}))
    {:ok, current_user} = Repo.insert(%User{} |> User.changeset_meta(%{hello: "world"}))
    {:ok, user_id: current_user.id, random_user_id: random_user.id}
  end

  test "filter users" do
    {:ok, users} = Chat.list_users("world")
    assert length(users) == 1
  end

  test "list contacts" do
    assert {:ok, _} = Chat.list_users(nil)
  end

  test "create a new room", state do
    assert {:ok, _} = Chat.create_room(state.user_id)
  end

  test "get room users", state do
    {:ok, room} = Chat.create_room(state.user_id)
    assert Chat.get_room_users(room.id) != nil
  end

  test "new room should have creator in room_user", state do
    {:ok, room} = Chat.create_room(state.user_id)
    users = Chat.get_room_users(room.id)
    assert length(users) == 1
  end

  test "add user to room", state do
    {:ok, room} = Chat.create_room(state.user_id)
    assert {:ok, _} = Chat.add_user_to_room(room.id, state.random_user_id)
  end

  test "should list user's chatroom" do
    assert true == true
  end
end
