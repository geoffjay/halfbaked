defmodule HalfbakedWeb.AiController do
  use HalfbakedWeb, :controller

  alias Halfbaked.Ideas
  alias Halfbaked.Ideas.{Plan, Document}
  alias Halfbaked.Repo

  plug :require_authenticated_user

  def recommend_tasks(conn, %{"id" => plan_id}) do
    plan = Repo.get!(Plan, plan_id) |> Repo.preload(:idea)
    user = conn.assigns.current_user
    with {:ok, tasks} <- Ideas.ai_task_recommendations(user, plan.idea, plan) do
      json(conn, %{tasks: tasks})
    end
  rescue
    _ -> conn |> put_status(:payment_required) |> json(%{error: "Pro plan required"})
  end

  def summarize_document(conn, %{"id" => doc_id}) do
    doc = Repo.get!(Document, doc_id)
    user = conn.assigns.current_user
    with {:ok, summary} <- Ideas.ai_document_summary(user, doc) do
      json(conn, %{summary: summary})
    end
  rescue
    _ -> conn |> put_status(:payment_required) |> json(%{error: "Pro plan required"})
  end

  def complete_text(conn, %{"id" => doc_id, "prompt" => prompt}) do
    _doc = Repo.get!(Document, doc_id)
    user = conn.assigns.current_user
    with {:ok, completion} <- Ideas.ai_document_completion(user, prompt) do
      json(conn, %{completion: completion})
    end
  rescue
    _ -> conn |> put_status(:payment_required) |> json(%{error: "Pro plan required"})
  end
end
