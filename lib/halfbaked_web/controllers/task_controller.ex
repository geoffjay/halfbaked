defmodule HalfbakedWeb.TaskController do
  use HalfbakedWeb, :controller

  alias Halfbaked.Ideas
  alias Halfbaked.Ideas.{Plan, Task}
  alias Halfbaked.Repo

  plug :require_authenticated_user

  def create(conn, %{"plan_id" => plan_id, "task" => task_params}) do
    plan = Repo.get!(Plan, plan_id) |> Repo.preload(:idea)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, plan.idea) do
      case Ideas.create_task(plan, task_params) do
        {:ok, _task} -> redirect(conn, to: ~p"/ideas/#{plan.idea_id}")
        {:error, %Ecto.Changeset{} = _changeset} -> redirect(conn, to: ~p"/ideas/#{plan.idea_id}")
      end
    else
      conn |> put_flash(:error, "No access.") |> redirect(to: ~p"/ideas/#{plan.idea_id}")
    end
  end

  def delete(conn, %{"plan_id" => plan_id, "id" => id}) do
    plan = Repo.get!(Plan, plan_id) |> Repo.preload(:idea)
    task = Repo.get!(Task, id)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, plan.idea) do
      {:ok, _} = Ideas.delete_task(task)
      redirect(conn, to: ~p"/ideas/#{plan.idea_id}")
    else
      conn |> put_flash(:error, "No access.") |> redirect(to: ~p"/ideas/#{plan.idea_id}")
    end
  end

  def update(conn, %{"plan_id" => plan_id, "id" => id, "task" => task_params}) do
    plan = Repo.get!(Plan, plan_id) |> Repo.preload(:idea)
    task = Repo.get!(Task, id)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, plan.idea) do
      case Ideas.update_task(task, task_params) do
        {:ok, _} -> redirect(conn, to: ~p"/ideas/#{plan.idea_id}")
        {:error, _} -> redirect(conn, to: ~p"/ideas/#{plan.idea_id}")
      end
    else
      conn |> put_flash(:error, "No access.") |> redirect(to: ~p"/ideas/#{plan.idea_id}")
    end
  end
end
