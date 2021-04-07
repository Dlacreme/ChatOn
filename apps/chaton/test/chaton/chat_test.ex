defmodule Chaton.ChatTest do
  use ExUnit.Case
  alias Chaton.Repo
  alias Chaton.Chat

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "should list contacts" do
    assert true = false
  end

  test "should filter contacts" do
    assert true = false
  end

  test "should create a new room" do
    assert true = false
  end

  test "should post a message to chat room" do
    assert true = false
  end

  test "should send a direct message to a user" do
    assert true = false
  end
end
