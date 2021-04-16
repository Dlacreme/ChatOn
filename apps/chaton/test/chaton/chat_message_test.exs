defmodule Chaton.ChatMessageTest do
  use ExUnit.Case
  alias Chaton.Repo
  alias Chaton.Auth.User
  alias Chaton.Chat

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    {:ok, toto_user} = Repo.insert(%User{} |> User.changeset_meta(%{toto: "tata"}))
    {:ok, hello_user} = Repo.insert(%User{} |> User.changeset_meta(%{hello: "world"}))
    {:ok, room} = Chat.create_room(hello_user.id)
    {:ok, room: room, toto_user: toto_user, hello_user: hello_user}
  end

  test "should post a message to chat room" do
    assert true == true
  end

  test "should send a direct message to a user", state do
    assert 0 < length(Chaton.Chat.send_message!(state.toto_user, state.hello_user, "Hello World"))
  end
end
