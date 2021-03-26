defmodule Chaton.Auth.UserToken do
  use Ecto.Schema
  import Ecto.Query

  @rand_size 32
  @session_validity_in_days 60
  @channel_validity_in_days 1

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    field :expired_at, :naive_datetime
    belongs_to :user, Chaton.Auth.User

    timestamps(updated_at: false)
  end

  @doc """
  Generates a token that will be stored in a signed place,
  such as session or cookie. As they are signed, those
  tokens do not need to be hashed.
  """
  def build_session_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %__MODULE__{token: token, context: "session", user_id: user.id,
      expired_at: get_expired_at(@session_validity_in_days)}}
  end

  @doc """
  Generated a channel token for a user
  """
  def build_channel_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %__MODULE__{token: token, context: "channel", user_id: user.id,
      expired_at: get_expired_at(@channel_validity_in_days)}}
  end


  @doc """
  Generated a channel token for a guest
  """
  def build_channel_token() do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %__MODULE__{token: token, context: "channel",
      expired_at: get_expired_at(@channel_validity_in_days)}}
  end

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the user found by the token.
  """
  def verify_session_token_query(token) do
    today = NaiveDateTime.utc_now()
    query =
      from token in token_and_context_query(token, "session"),
        join: user in assoc(token, :user),
        where: ^today <= token.expired_at,
        select: user

    {:ok, query}
  end

  @doc """
  Returns the given token with the given context.
  """
  def token_and_context_query(token, context) do
    from __MODULE__, where: [token: ^token, context: ^context]
  end

  defp get_expired_at(validity_day) do
    NaiveDateTime.utc_now
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.add(60 * 60 * 24 * validity_day)
  end

end
