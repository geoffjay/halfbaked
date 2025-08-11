defmodule HalfbakedWeb.PageController do
  use HalfbakedWeb, :controller

  def home(conn, _params) do
    # Simple redirect to dashboard
    redirect(conn, to: ~p"/ideas")
  end
end
