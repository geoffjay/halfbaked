defmodule HalfbakedWeb.IdeaController do
  use HalfbakedWeb, :controller

  alias Halfbaked.Ideas
  alias Halfbaked.Ideas.Idea
  alias Halfbaked.Repo

  plug :require_authenticated_user when action in [:index, :new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    ideas = Ideas.list_user_ideas(user)
    render(conn, :index, ideas: ideas)
  end

  def new(conn, _params) do
    changeset = Idea.changeset(%Idea{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"idea" => idea_params}) do
    user = conn.assigns.current_user
    tags = Map.get(idea_params, "tags", "") |> parse_tags()

    case Ideas.create_idea(user, idea_params) do
      {:ok, idea} ->
        _ = Ideas.set_tags("Idea", idea.id, tags)
        conn
        |> put_flash(:info, "Idea created.")
        |> redirect(to: ~p"/ideas/#{idea.id}")
      {:error, :private_idea_limit_reached} ->
        conn
        |> put_flash(:error, "Free plan limit reached for private ideas.")
        |> redirect(to: ~p"/ideas")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    idea = Ideas.get_idea!(id)
    user = conn.assigns[:current_user]
    if Ideas.can_view?(user, idea) do
      tags = Ideas.list_tags_for("Idea", idea.id)
      comments = Ideas.list_comments("Idea", idea.id)
      star_count = Ideas.count_stars("Idea", idea.id)
      starred = if user, do: Ideas.starred?(user, "Idea", idea.id), else: false
      shares = if user && Ideas.can_edit?(user, idea), do: Ideas.list_shares_for_idea(idea), else: []
      render(conn, :show, idea: idea, tags: tags, comments: comments, star_count: star_count, starred: starred, shares: shares)
    else
      conn |> put_flash(:error, "You do not have access to this idea.") |> redirect(to: ~p"/")
    end
  end

  def edit(conn, %{"id" => id}) do
    idea = Repo.get!(Idea, id)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, idea) do
      changeset = Idea.changeset(idea, %{})
      tags_csv = Ideas.list_tags_for("Idea", idea.id) |> Enum.map(& &1.name) |> Enum.join(", ")
      render(conn, :edit, idea: idea, changeset: changeset, tags_csv: tags_csv)
    else
      conn |> put_flash(:error, "You cannot edit this idea.") |> redirect(to: ~p"/ideas/#{id}")
    end
  end

  def update(conn, %{"id" => id, "idea" => idea_params}) do
    idea = Repo.get!(Idea, id)
    user = conn.assigns.current_user
    tags = Map.get(idea_params, "tags", "") |> parse_tags()

    if Ideas.can_edit?(user, idea) do
      case Ideas.update_idea(idea, idea_params) do
        {:ok, idea} ->
          _ = Ideas.set_tags("Idea", idea.id, tags)
          conn |> put_flash(:info, "Updated.") |> redirect(to: ~p"/ideas/#{idea.id}")
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :edit, idea: idea, changeset: changeset)
      end
    else
      conn |> put_flash(:error, "You cannot edit this idea.") |> redirect(to: ~p"/ideas/#{id}")
    end
  end

  def delete(conn, %{"id" => id}) do
    idea = Repo.get!(Idea, id)
    user = conn.assigns.current_user
    if Ideas.can_edit?(user, idea) do
      {:ok, _} = Ideas.delete_idea(idea)
      conn |> put_flash(:info, "Deleted.") |> redirect(to: ~p"/ideas")
    else
      conn |> put_flash(:error, "You cannot delete this idea.") |> redirect(to: ~p"/ideas/#{id}")
    end
  end

  defp parse_tags("") , do: []
  defp parse_tags(nil), do: []
  defp parse_tags(csv) when is_binary(csv) do
    csv
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
