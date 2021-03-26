defmodule Chaton.Cron do
  @moduledoc """
  CRON is a simple GenServer with relaying on a delayed send/2

  You can add any new CRON tasks in handle_info:work/2
  """

  use GenServer

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(opts) do
    schedule_task()
    {:ok, opts}
  end

  def handle_info(:work, opts) do
    Chaton.Auth.clean_expired_token(Chaton.Auth.UserToken)
    Chaton.Auth.clean_expired_token(Chaton.Auth.AdminToken)
    schedule_task()
    {:noreply, opts}
  end

  defp schedule_task(time \\ (24 * 60 * 60 * 1000)) do # 24h by default
    Process.send_after(self(), :work, time)
  end

end
