defmodule Chaton.Auth do
  alias Chaton.Auth.Admin
  import Ecto.Query

  @moduledoc """
  Authentication system
  """

  def add_admin(email, password) do
    %Admin{}
    |> Admin.registration_changeset(%{email: email, password: password})
    |> Chaton.Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_admin_registration(%Admin{} = admin, attrs \\ %{}) do
    Admin.registration_changeset(admin, attrs, hash_password: false)
  end

  @doc """
  Gets an admin by email and password.

  ## Examples

      iex> get_admin_by_email_and_password("foo@example.com", "correct_password")
      %Admin{}

      iex> get_admin_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_admin_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    admin = Chaton.Repo.get_by(Admin, email: email)
    if Admin.valid_password?(admin, password), do: admin
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_admin_by_session_token(token) do
    {:ok, query} = Chaton.Auth.AdminToken.verify_session_token_query(token)
    Chaton.Repo.one(query)
  end

  @doc """
  Generates a session token.
  """
  def generate_admin_session_token(user) do
    {token, admin_token} = Chaton.Auth.AdminToken.build_session_token(user)
    Chaton.Repo.insert!(admin_token)
    token
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_session_token(token) do
    Chaton.Repo.delete_all(Chaton.Auth.AdminToken.token_and_context_query(token, "session"))
    :ok
  end

  @doc """
  Deletes all token already expired
  """
  def clean_expired_token(token_module) do
    date = NaiveDateTime.utc_now()
    Chaton.Repo.delete_all(from t in token_module, where: ^date >= t.expired_at)
  end
end
