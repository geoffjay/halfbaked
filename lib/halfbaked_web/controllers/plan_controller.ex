defmodule HalfbakedWeb.PlanController do
  use HalfbakedWeb, :controller

  alias Halfbaked.Ideas
  alias Halfbaked.Ideas.{Idea, Plan}
  alias Halfbaked.Repo

  plug :require_authenticated_user

  def create(conn, %{"idea_id" => idea_id, "plan" => plan_params}) do
    idea = Repo.get!(Idea, idea_id)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, idea) do
      case Ideas.create_plan(idea, plan_params) do
        {:ok, _plan} -> redirect(conn, to: ~p"/ideas/#{idea.id}")
        {:error, %Ecto.Changeset{} = _changeset} -> redirect(conn, to: ~p"/ideas/#{idea.id}")
      end
    else
      conn |> put_flash(:error, "No access.") |> redirect(to: ~p"/ideas/#{idea.id}")
    end
  end

  def delete(conn, %{"idea_id" => idea_id, "id" => id}) do
    idea = Repo.get!(Idea, idea_id)
    plan = Repo.get!(Plan, id)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, idea) do
      {:ok, _} = Ideas.delete_plan(plan)
      redirect(conn, to: ~p"/ideas/#{idea.id}")
    else
      conn |> put_flash(:error, "No access.") |> redirect(to: ~p"/ideas/#{idea.id}")
    end
  end
end
