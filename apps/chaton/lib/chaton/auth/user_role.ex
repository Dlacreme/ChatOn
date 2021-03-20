defmodule Chaton.Auth.UserRole do
  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string
  schema "user_roles" do
    field :label, :string
  end
end
