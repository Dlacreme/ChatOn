defmodule ChatonWeb.ChannelSocket do
  use Phoenix.Socket

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Chaton.Auth.UserToken.get(token) do
      nil -> {:error, socket}
      _user_token -> {:ok, assign(socket, token: token)}
    end
  end

  @impl true
  def id(_socket), do: nil
end
