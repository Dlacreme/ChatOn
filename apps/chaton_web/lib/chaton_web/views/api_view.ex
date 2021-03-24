defmodule ChatonWeb.ApiView do
  use ChatonWeb, :view

  def render("index.json", %{}) do
    %{alive: true}
  end

  def render("auth.json", %{token: token}) do
    %{token: token}
  end

  def render("user.json", %{user: user}) do
    %{user: user}
  end

end
