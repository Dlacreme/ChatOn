defmodule Chaton.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :meta, :map, null: false, default: %{}
    field :disabled_at, :utc_datetime
    timestamps()
  end

  @doc """
  Changeset for user meta
  """
  def changeset_meta(user, meta) do
    user
    |> cast(%{meta: meta}, [:meta])
  end

  @doc """
  Search for users using its metadata
  """
  def search_by_metadata(query) do
    case Chaton.Repo.query("SELECT * FROM users WHERE meta @> '#{query}'") do
      {:ok, res} ->
        {:ok, Enum.map(res.rows, &Chaton.Repo.load(__MODULE__, {res.columns, &1}))}

      {:error, _} ->
        {:error, "Invalid query"}
    end
  end
end

defimpl Jason.Encoder, for: Chaton.Auth.User do
  def encode(value, opts) do
    Jason.Encode.map(Map.take(value, [:id, :meta]), opts)
  end
end
