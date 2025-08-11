defmodule HalfbakedWeb.CommentController do
  use HalfbakedWeb, :controller

  alias Halfbaked.Ideas
  alias Halfbaked.Ideas.{Document, Comment}
  alias Halfbaked.Repo

  plug :require_authenticated_user

  def create(conn, %{"comment" => params}) do
    user = conn.assigns.current_user
    case Ideas.create_comment(user, params) do
      {:ok, %Comment{commentable_type: "Idea", commentable_id: idea_id}} ->
        redirect(conn, to: ~p"/ideas/#{idea_id}")
      {:ok, %Comment{commentable_type: "Document", commentable_id: document_id}} ->
        doc = Repo.get!(Document, document_id)
        redirect(conn, to: ~p"/ideas/#{doc.idea_id}/documents/#{document_id}")
      {:error, _changeset} ->
        conn |> put_flash(:error, "Comment failed.") |> redirect(to: ~p"/")
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id)
    user = conn.assigns.current_user
    if comment.user_id == user.id do
      {:ok, _} = Ideas.delete_comment(comment)
      case {comment.commentable_type, comment.commentable_id} do
        {"Idea", idea_id} -> redirect(conn, to: ~p"/ideas/#{idea_id}")
        {"Document", document_id} ->
          doc = Repo.get!(Document, document_id)
          redirect(conn, to: ~p"/ideas/#{doc.idea_id}/documents/#{document_id}")
      end
    else
      conn |> put_flash(:error, "Cannot delete this comment.") |> redirect(to: ~p"/")
    end
  end

  def update(conn, %{"id" => id, "comment" => params}) do
    comment = Repo.get!(Comment, id)
    user = conn.assigns.current_user
    if comment.user_id == user.id do
      case Ideas.update_comment(comment, params) do
        {:ok, comment} ->
          case {comment.commentable_type, comment.commentable_id} do
            {"Idea", idea_id} -> redirect(conn, to: ~p"/ideas/#{idea_id}")
            {"Document", document_id} ->
              doc = Repo.get!(Document, document_id)
              redirect(conn, to: ~p"/ideas/#{doc.idea_id}/documents/#{document_id}")
          end
        {:error, _} -> conn |> put_flash(:error, "Update failed.") |> redirect(to: ~p"/")
      end
    else
      conn |> put_flash(:error, "Cannot edit this comment.") |> redirect(to: ~p"/")
    end
  end
end
