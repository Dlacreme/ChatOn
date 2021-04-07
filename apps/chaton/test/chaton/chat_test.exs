defmodule Chaton.ChatTest do
  use ExUnit.Case
  alias Chaton.Repo
  alias Chaton.Auth.User
  alias Chaton.Chat

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    {:ok, _} = Repo.insert(%User{} |> User.changeset_meta(%{toto: "tata"}))
    {:ok, _} = Repo.insert(%User{} |> User.changeset_meta(%{hello: "world"}))
    :ok
  end

  test "should filter users" do
    {:ok, users} = Chat.list_users("world")
    assert length(users) == 1
  end

  test "should list contacts" do
    assert {:ok, _} = Chat.list_users(nil)
  end

  test "should list user's chatroom" do
    assert true == false
  end

  test "should create a new room" do
    assert true == false
  end

  test "should post a message to chat room" do
    assert true == false
  end

  test "should send a direct message to a user" do
    assert true == false
  end
end
