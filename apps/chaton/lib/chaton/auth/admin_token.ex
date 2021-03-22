defmodule Chaton.Auth.AdminToken do
  use Ecto.Schema
  import Ecto.Query

  @hash_algorithm :sha256
  @rand_size 32

  # It is very important to keep the reset password token expiry short,
  # since someone with access to the email may take over the account.
  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7
  @change_email_validity_in_days 7
  @session_validity_in_days 60

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "admin_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    belongs_to :admin, Chaton.Auth.Admin

    timestamps(updated_at: false)
  end

  @doc """
  Generates a token that will be stored in a signed place,
  such as session or cookie. As they are signed, those
  tokens do not need to be hashed.
  """
  def build_session_token(admin) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %__MODULE__{token: token, context: "session", admin_id: admin.id}}
  end

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the admin found by the token.
  """
  def verify_session_token_query(token) do
    query =
      from token in token_and_context_query(token, "session"),
        join: admin in assoc(token, :admin),
        where: token.inserted_at > ago(@session_validity_in_days, "day"),
        select: admin

    {:ok, query}
  end

  @doc """
  Returns the given token with the given context.
  """
  def token_and_context_query(token, context) do
    from __MODULE__, where: [token: ^token, context: ^context]
  end
end
