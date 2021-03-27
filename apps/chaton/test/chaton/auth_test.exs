defmodule Chaton.AuthTest do
  use ExUnit.Case
  import Ecto.Changeset
  alias Chaton.Auth
  alias Chaton.Repo

  @test_admin_email "unit@test.com"
  @test_admin_pass "toto4242"

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "should create a new admin" do
    assert {:ok, _} = Auth.add_admin(@test_admin_email, @test_admin_pass)
  end

  test "should get admin by email and password" do
    Auth.add_admin(@test_admin_email, @test_admin_pass)
    assert nil != Auth.get_admin_by_email_and_password(@test_admin_email, @test_admin_pass)
  end

  test "should create a token" do
    {_, user_token} = Auth.UserToken.build_channel_token()
    assert {:ok, _} = Repo.insert(user_token)
  end

  test "should remove expired token" do
    {_, user_token} = Auth.UserToken.build_channel_token()

    ut =
      Repo.insert!(
        user_token
        |> cast(%{expired_at: NaiveDateTime.add(user_token.expired_at, -100_000, :second)}, [
          :expired_at
        ])
      )

    Auth.clean_expired_token(Auth.UserToken)
    assert is_nil(Repo.get_by(Auth.UserToken, id: ut.id))
  end
end
