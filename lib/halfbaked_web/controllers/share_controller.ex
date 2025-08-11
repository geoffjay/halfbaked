defmodule HalfbakedWeb.ShareController do
  use HalfbakedWeb, :controller

  alias Halfbaked.{Ideas, Accounts}

  plug :require_authenticated_user

  def index(conn, _params) do
    ideas = Ideas.list_shared_with_user(conn.assigns.current_user)
    render(conn, :index, ideas: ideas)
  end

  def create(conn, %{"id" => idea_id, "share" => %{"email" => email, "permission_level" => level}}) do
    idea = Ideas.get_idea!(idea_id)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, idea) do
      case Accounts.get_user_by_email(email) do
        nil -> conn |> put_flash(:error, "User not found.") |> redirect(to: ~p"/ideas/#{idea.id}")
        share_with ->
          case Ideas.share_idea_with_user(idea, share_with, level) do
            {:ok, _} -> conn |> put_flash(:info, "Shared.") |> redirect(to: ~p"/ideas/#{idea.id}")
            {:error, _} -> conn |> put_flash(:error, "Failed.") |> redirect(to: ~p"/ideas/#{idea.id}")
          end
      end
    else
      conn |> put_flash(:error, "No access.") |> redirect(to: ~p"/ideas/#{idea.id}")
    end
  end
end
