defmodule Chaton.Auth.AdminToken do
  use Ecto.Schema
  import Ecto.Query

  @moduledoc """
  Handle token for admin? Bare duplicate of UserToken.
  TODO: centralize UserToken & AdminToken code. Using behaviour maybe?
  """

  @rand_size 32
  @session_validity_in_days 60

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "admin_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    field :expired_at, :naive_datetime
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

    {token,
     %__MODULE__{
       token: token,
       context: "session",
       admin_id: admin.id,
       expired_at: get_expired_at(@session_validity_in_days)
     }}
  end

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the admin found by the token.
  """
  def verify_session_token_query(token) do
    today = NaiveDateTime.utc_now()

    query =
      from token in token_and_context_query(token, "session"),
        join: admin in assoc(token, :admin),
        where: ^today <= token.expired_at,
        select: admin

    {:ok, query}
  end

  @doc """
  Returns the given token with the given context.
  """
  def token_and_context_query(token, context) do
    IO.puts("TOKEN >> #{inspect(token)}")
    from __MODULE__, where: [token: ^token, context: ^context]
  end

  defp get_expired_at(validity_day) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.add(60 * 60 * 24 * validity_day)
  end
end
