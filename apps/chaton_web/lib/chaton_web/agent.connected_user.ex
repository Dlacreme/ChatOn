defmodule ChatonWeb.Agent.ConnectedUser do
  use Agent

  def start_link(init_state \\ []) do
    Agent.start_link(fn -> init_state end, name: __MODULE__)
  end

  def is_connected?(token) do
    Agent.get(__MODULE__, fn x -> Enum.find(x, fn t -> t == token end) end)
  end

  def connected(token) do
    case is_connected?(token) do
      nil -> Agent.update(__MODULE__, &[token | &1])
      _ -> :ok
    end
  end

  def disconnected(token) do
    Agent.update(__MODULE__, fn x -> List.delete(x, token) end)
  end
end
