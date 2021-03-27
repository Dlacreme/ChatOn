defmodule ChatonWeb.ChannelSocket do
  use Phoenix.Socket

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Chaton.Auth.UserToken.get(token) do
      nil -> {:error, socket}
      user_token -> {:ok, authenticate(socket, user_token)}
    end
  end

  defp authenticate(socket, user_token) when user_token.user_id == nil do
    assign(socket, type: :guest)
  end

  defp authenticate(socket, user_token) do
    assign(socket, type: :user, user_id: user_token.user_id)
  end

  @impl true
  def id(_socket), do: nil
end
