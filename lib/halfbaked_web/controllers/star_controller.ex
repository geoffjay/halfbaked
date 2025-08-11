defmodule HalfbakedWeb.StarController do
  use HalfbakedWeb, :controller

  alias Halfbaked.Ideas

  plug :require_authenticated_user

  def index(conn, _params) do
    stars = Ideas.list_user_starred(conn.assigns.current_user)
    render(conn, :index, stars: stars)
  end

  def create(conn, %{"starable_type" => type, "starable_id" => id}) do
    {:ok, _} = Ideas.star(conn.assigns.current_user, type, id)
    redirect_back(conn, type, id)
  end

  def delete(conn, %{"starable_type" => type, "starable_id" => id}) do
    :ok = Ideas.unstar(conn.assigns.current_user, type, id)
    redirect_back(conn, type, id)
  end

  defp redirect_back(conn, "Idea", id), do: redirect(conn, to: ~p"/ideas/#{id}")
  defp redirect_back(conn, "Document", _id) do
    # We don't have idea id directly; let the document page handle it
    redirect(conn, to: ~p"/")
  end
  defp redirect_back(conn, _type, _id), do: redirect(conn, to: ~p"/")
end
