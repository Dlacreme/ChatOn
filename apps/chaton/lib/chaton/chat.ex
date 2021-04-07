defmodule Chaton.Chat do
  @moduledoc """
  This module handles the chat rooms as well as the direct messages
  """
  import Ecto.Query

  @doc """
  Returns all potential contacts. @query allows to filters using metadata
  """
  def list_users(q) when q == nil or q == "" do
    {:ok, Chaton.Repo.all(from(u in Chaton.Auth.User))}
  end

  def list_users(query) do
    Chaton.Auth.User.filter_by_metadata(query)
  end
end
