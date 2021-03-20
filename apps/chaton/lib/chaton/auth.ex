defmodule Chaton.Auth do
  alias Chaton.Auth.Admin

  @moduledoc """
  Authentication system
  """

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %Admin{}}

  """
  def change_user_registration(%Admin{} = user, attrs \\ %{}) do
    Admin.registration_changeset(user, attrs, hash_password: false)
  end
end
