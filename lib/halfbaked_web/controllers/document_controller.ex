defmodule HalfbakedWeb.DocumentController do
  use HalfbakedWeb, :controller

  alias Halfbaked.Ideas
  alias Halfbaked.Ideas.{Document, Idea}
  alias Halfbaked.Repo

  plug :require_authenticated_user when action in [:new, :create, :edit, :update, :delete]

  def new(conn, %{"idea_id" => idea_id}) do
    idea = Repo.get!(Idea, idea_id)
    changeset = Document.changeset(%Document{}, %{})
    render(conn, :new, idea: idea, changeset: changeset)
  end

  def create(conn, %{"idea_id" => idea_id, "document" => doc_params}) do
    idea = Repo.get!(Idea, idea_id)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, idea) do
      case Ideas.create_document(idea, doc_params) do
        {:ok, doc} -> redirect(conn, to: ~p"/ideas/#{idea.id}/documents/#{doc.id}")
        {:error, %Ecto.Changeset{} = changeset} -> render(conn, :new, idea: idea, changeset: changeset)
      end
    else
      conn |> put_flash(:error, "No access.") |> redirect(to: ~p"/ideas/#{idea.id}")
    end
  end

  def show(conn, %{"idea_id" => idea_id, "id" => id}) do
    idea = Ideas.get_idea!(idea_id)
    doc = Repo.get!(Document, id)
    user = conn.assigns[:current_user]
    if Ideas.can_view?(user, idea) do
      comments = Ideas.list_comments("Document", doc.id)
      render(conn, :show, idea: idea, document: doc, comments: comments)
    else
      conn |> put_flash(:error, "No access.") |> redirect(to: ~p"/")
    end
  end

  def edit(conn, %{"idea_id" => idea_id, "id" => id}) do
    idea = Repo.get!(Idea, idea_id)
    doc = Repo.get!(Document, id)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, idea) do
      changeset = Document.changeset(doc, %{})
      render(conn, :edit, idea: idea, document: doc, changeset: changeset)
    else
      conn |> put_flash(:error, "No access.") |> redirect(to: ~p"/ideas/#{idea.id}/documents/#{doc.id}")
    end
  end

  def update(conn, %{"idea_id" => idea_id, "id" => id, "document" => doc_params}) do
    idea = Repo.get!(Idea, idea_id)
    doc = Repo.get!(Document, id)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, idea) do
      case Ideas.update_document(doc, doc_params) do
        {:ok, doc} -> redirect(conn, to: ~p"/ideas/#{idea.id}/documents/#{doc.id}")
        {:error, %Ecto.Changeset{} = changeset} -> render(conn, :edit, idea: idea, document: doc, changeset: changeset)
      end
    else
      conn |> put_flash(:error, "No access.") |> redirect(to: ~p"/ideas/#{idea.id}/documents/#{doc.id}")
    end
  end

  def delete(conn, %{"idea_id" => idea_id, "id" => id}) do
    idea = Repo.get!(Idea, idea_id)
    doc = Repo.get!(Document, id)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, idea) do
      {:ok, _} = Ideas.delete_document(doc)
      redirect(conn, to: ~p"/ideas/#{idea.id}")
    else
      conn |> put_flash(:error, "No access.") |> redirect(to: ~p"/ideas/#{idea.id}/documents/#{doc.id}")
    end
  end
end
