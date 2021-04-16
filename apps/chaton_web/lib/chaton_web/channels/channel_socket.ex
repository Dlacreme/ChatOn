defmodule ChatonWeb.ChannelSocket do
  use Phoenix.Socket

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Chaton.Auth.UserToken.get(token) do
      nil -> invalid_token(socket)
      user_token -> {:ok, authenticate(socket, user_token)}
    end
  end

  @impl true
  def connect(_info, socket, _connect_info) do
    socket |> invalid_token()
  end

  @impl true
  def id(_socket), do: nil

  @impl true
  def handle_in("message", %{}, socket) do
    {:noreply, socket}
  end

  defp authenticate(socket, user_token) when user_token.user_id == nil do
    assign(socket, type: :guest)
  end

  defp authenticate(socket, user_token) do
    ChatonWeb.Agent.ConnectedUser.connected(user_token)
    assign(socket, type: :user, user_id: user_token.user_id)
  end

  defp invalid_token(_socket) do
    :error
  end
end
