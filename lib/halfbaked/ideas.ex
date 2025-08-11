defmodule Halfbaked.Ideas do
  @moduledoc """
  Context for ideas, plans, tasks, documents, tags, comments, stars, shares, and search.
  """

  import Ecto.Query, warn: false
  alias Halfbaked.Repo

  alias Halfbaked.Accounts
  alias Halfbaked.Accounts.User

  alias Halfbaked.Ideas.{
    Idea,
    Plan,
    Task,
    Document,
    Tag,
    Tagging,
    Comment,
    Star,
    Share
  }

  @free_private_idea_limit 3

  # Idea CRUD
  def list_public_ideas() do
    from(i in Idea, where: i.visibility == "public", preload: [:plans, :documents])
    |> Repo.all()
  end

  def list_user_ideas(%User{id: user_id}) do
    from(i in Idea, where: i.user_id == ^user_id, preload: [:plans, :documents])
    |> Repo.all()
  end

  def list_shared_with_user(%User{id: user_id}) do
    idea_ids_query = from s in Share,
      where: s.shareable_type == "Idea" and s.user_id == ^user_id,
      select: s.shareable_id

    from(i in Idea, where: i.id in subquery(idea_ids_query))
    |> Repo.all()
  end

  def get_idea!(id) do
    Repo.get!(Idea, id)
    |> Repo.preload([documents: [], plans: [:tasks]])
  end

  def create_idea(%User{id: user_id} = user, attrs) do
    with :ok <- enforce_private_idea_limit(user, attrs) do
      %Idea{}
      |> Idea.changeset(Map.put(attrs, :user_id, user_id))
      |> Repo.insert()
    end
  end

  def update_idea(%Idea{} = idea, attrs) do
    idea
    |> Idea.changeset(attrs)
    |> Repo.update()
  end

  def delete_idea(%Idea{} = idea), do: Repo.delete(idea)

  defp enforce_private_idea_limit(%User{id: user_id} = _user, attrs) do
    visibility = Map.get(attrs, :visibility) || Map.get(attrs, "visibility") || "public"
    if visibility == "private" do
      plan = get_user_subscription_plan(user_id)
      if plan == "free" do
        count = from(i in Idea, where: i.user_id == ^user_id and i.visibility == "private", select: count(i.id)) |> Repo.one()
        if count >= @free_private_idea_limit, do: {:error, :private_idea_limit_reached}, else: :ok
      else
        :ok
      end
    else
      :ok
    end
  end

  defp get_user_subscription_plan(user_id) do
    user = Repo.get!(Accounts.User, user_id) |> Repo.preload(:profile)
    case user.profile do
      nil -> "free"
      %{subscription_plan: plan} when is_binary(plan) -> plan
      _ -> "free"
    end
  end

  # Plans
  def create_plan(%Idea{id: idea_id}, attrs) do
    %Plan{}
    |> Plan.changeset(Map.put(attrs, :idea_id, idea_id))
    |> Repo.insert()
  end

  def update_plan(%Plan{} = plan, attrs), do: plan |> Plan.changeset(attrs) |> Repo.update()
  def delete_plan(%Plan{} = plan), do: Repo.delete(plan)

  # Tasks
  def create_task(%Plan{id: plan_id}, attrs) do
    %Task{}
    |> Task.changeset(Map.put(attrs, :plan_id, plan_id))
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs), do: task |> Task.changeset(attrs) |> Repo.update()
  def delete_task(%Task{} = task), do: Repo.delete(task)

  # Documents
  def create_document(%Idea{id: idea_id}, attrs) do
    %Document{}
    |> Document.changeset(Map.put(attrs, :idea_id, idea_id))
    |> Repo.insert()
  end

  def update_document(%Document{} = document, attrs), do: document |> Document.changeset(attrs) |> Repo.update()
  def delete_document(%Document{} = document), do: Repo.delete(document)

  # Tagging
  def set_tags(taggable_type, taggable_id, tag_names) when is_list(tag_names) do
    tag_ids = Enum.map(tag_names, &get_or_create_tag!/1) |> Enum.map(& &1.id)

    Repo.transaction(fn ->
      from(t in Tagging, where: t.taggable_type == ^taggable_type and t.taggable_id == ^taggable_id)
      |> Repo.delete_all()

      for tag_id <- tag_ids do
        %Tagging{}
        |> Tagging.changeset(%{tag_id: tag_id, taggable_type: taggable_type, taggable_id: taggable_id})
        |> Repo.insert!()
      end
    end)
  end

  def list_tags_for(taggable_type, taggable_id) do
    tag_ids_query = from t in Tagging,
      where: t.taggable_type == ^taggable_type and t.taggable_id == ^taggable_id,
      select: t.tag_id
    from(tag in Tag, where: tag.id in subquery(tag_ids_query)) |> Repo.all()
  end

  defp get_or_create_tag!(name) do
    case Repo.get_by(Tag, name: name) do
      nil ->
        %Tag{} |> Tag.changeset(%{name: name}) |> Repo.insert!()
      tag -> tag
    end
  end

  # Comments
  def list_comments(commentable_type, commentable_id) do
    from(c in Comment,
      where: c.commentable_type == ^commentable_type and c.commentable_id == ^commentable_id,
      order_by: [asc: c.inserted_at]
    ) |> Repo.all()
  end

  def create_comment(%User{id: user_id}, attrs) do
    %Comment{}
    |> Comment.changeset(Map.put(attrs, :user_id, user_id))
    |> Repo.insert()
  end

  def update_comment(%Comment{} = comment, attrs), do: comment |> Comment.changeset(attrs) |> Repo.update()
  def delete_comment(%Comment{} = comment), do: Repo.delete(comment)

  # Stars
  def star(%User{id: user_id}, starable_type, starable_id) do
    %Star{} |> Star.changeset(%{user_id: user_id, starable_type: starable_type, starable_id: starable_id}) |> Repo.insert(on_conflict: :nothing)
  end

  def unstar(%User{id: user_id}, starable_type, starable_id) do
    from(s in Star, where: s.user_id == ^user_id and s.starable_type == ^starable_type and s.starable_id == ^starable_id)
    |> Repo.delete_all()
    :ok
  end

  def starred?(%User{id: user_id}, starable_type, starable_id) do
    from(s in Star,
      where: s.user_id == ^user_id and s.starable_type == ^starable_type and s.starable_id == ^starable_id,
      select: count(s.id)
    ) |> Repo.one() |> Kernel.>(0)
  end

  def count_stars(starable_type, starable_id) do
    from(s in Star,
      where: s.starable_type == ^starable_type and s.starable_id == ^starable_id,
      select: count(s.id)
    ) |> Repo.one()
  end

  def list_user_starred(%User{id: user_id}) do
    Repo.all(from s in Star, where: s.user_id == ^user_id)
  end

  # Shares
  def share_idea_with_user(%Idea{id: idea_id}, %User{id: share_with_id}, permission_level) when permission_level in ["view", "edit"] do
    %Share{} |> Share.changeset(%{user_id: share_with_id, shareable_type: "Idea", shareable_id: idea_id, permission_level: permission_level})
    |> Repo.insert(on_conflict: [set: [permission_level: permission_level]], conflict_target: :shares_uniq)
  end

  def list_shares_for_idea(%Idea{id: idea_id}) do
    Repo.all(from s in Share, where: s.shareable_type == "Idea" and s.shareable_id == ^idea_id, preload: [:user])
  end

  def can_view?(nil, %Idea{visibility: "public"}), do: true
  def can_view?(nil, %Idea{visibility: "private"}), do: false
  def can_view?(%User{id: user_id}, %Idea{user_id: user_id}), do: true
  def can_view?(%User{id: user_id}, %Idea{id: idea_id, visibility: visibility}) do
    if visibility == "public" do
      true
    else
      Repo.exists?(from s in Share, where: s.shareable_type == "Idea" and s.shareable_id == ^idea_id and s.user_id == ^user_id)
    end
  end

  def can_edit?(%User{id: user_id}, %Idea{user_id: user_id}), do: true
  def can_edit?(%User{id: user_id}, %Idea{id: idea_id}) do
    Repo.exists?(from s in Share, where: s.shareable_type == "Idea" and s.shareable_id == ^idea_id and s.user_id == ^user_id and s.permission_level == "edit")
  end

  # Search across ideas, plans, tasks, documents by title/description + tags
  def search(query_string, current_user \\ nil) when is_binary(query_string) do
    like = "%" <> query_string <> "%"

    base_ideas = from(i in Idea, where: ilike(i.title, ^like) or ilike(i.description, ^like)) |> Repo.all()
    base_plans = from(p in Plan, where: ilike(p.title, ^like) or ilike(p.description, ^like)) |> Repo.all()
    base_tasks = from(t in Task, where: ilike(t.title, ^like) or ilike(t.description, ^like)) |> Repo.all()
    base_documents = from(d in Document, where: ilike(d.title, ^like) or ilike(d.content, ^like)) |> Repo.all()

    tagged_ids = from(t in Tag, where: ilike(t.name, ^like), select: t.id) |> Repo.all()
    taggings = if Enum.empty?(tagged_ids), do: [], else: Repo.all(from tg in Tagging, where: tg.tag_id in ^tagged_ids)

    {idea_ids, plan_ids, task_ids, document_ids} =
      Enum.reduce(taggings, {MapSet.new(), MapSet.new(), MapSet.new(), MapSet.new()}, fn tg, {ii, pi, ti, di} ->
        case tg.taggable_type do
          "Idea" -> {MapSet.put(ii, tg.taggable_id), pi, ti, di}
          "Plan" -> {ii, MapSet.put(pi, tg.taggable_id), ti, di}
          "Task" -> {ii, pi, MapSet.put(ti, tg.taggable_id), di}
          "Document" -> {ii, pi, ti, MapSet.put(di, tg.taggable_id)}
          _ -> {ii, pi, ti, di}
        end
      end)

    tagged_ideas = if MapSet.size(idea_ids) > 0, do: Repo.all(from i in Idea, where: i.id in ^MapSet.to_list(idea_ids)), else: []
    tagged_plans = if MapSet.size(plan_ids) > 0, do: Repo.all(from p in Plan, where: p.id in ^MapSet.to_list(plan_ids)), else: []
    tagged_tasks = if MapSet.size(task_ids) > 0, do: Repo.all(from t in Task, where: t.id in ^MapSet.to_list(task_ids)), else: []
    tagged_documents = if MapSet.size(document_ids) > 0, do: Repo.all(from d in Document, where: d.id in ^MapSet.to_list(document_ids)), else: []

    ideas_all = uniq_by_id(base_ideas ++ tagged_ideas)
    plans_all = uniq_by_id(base_plans ++ tagged_plans)
    tasks_all = uniq_by_id(base_tasks ++ tagged_tasks)
    documents_all = uniq_by_id(base_documents ++ tagged_documents)

    visible_idea_ids = visible_idea_ids_for(current_user)

    ideas = Enum.filter(ideas_all, fn i -> MapSet.member?(visible_idea_ids, i.id) end)
    plans = Enum.filter(plans_all, fn p -> MapSet.member?(visible_idea_ids, p.idea_id) end)

    # For tasks, we must map plan_id -> idea_id
    task_plan_ids = tasks_all |> Enum.map(& &1.plan_id) |> Enum.uniq()
    plans_map =
      if task_plan_ids == [] do
        %{}
      else
        Repo.all(from pl in Plan, where: pl.id in ^task_plan_ids)
        |> Map.new(&{&1.id, &1})
      end
    tasks =
      Enum.filter(tasks_all, fn t ->
        case Map.get(plans_map, t.plan_id) do
          nil -> false
          %Plan{idea_id: idea_id} -> MapSet.member?(visible_idea_ids, idea_id)
        end
      end)

    documents = Enum.filter(documents_all, fn d -> MapSet.member?(visible_idea_ids, d.idea_id) end)

    %{ideas: ideas, plans: plans, tasks: tasks, documents: documents}
  end

  defp uniq_by_id(list) do
    list
    |> Enum.uniq_by(& &1.id)
  end

  defp visible_idea_ids_for(nil) do
    from(i in Idea, where: i.visibility == "public", select: i.id)
    |> Repo.all()
    |> MapSet.new()
  end

  defp visible_idea_ids_for(%User{id: user_id}) do
    own_ids = Repo.all(from(i in Idea, where: i.user_id == ^user_id, select: i.id))
    shared_ids = Repo.all(from(s in Share, where: s.shareable_type == "Idea" and s.user_id == ^user_id, select: s.shareable_id))
    public_ids = Repo.all(from(i in Idea, where: i.visibility == "public", select: i.id))
    MapSet.new(own_ids ++ shared_ids ++ public_ids)
  end

  # AI tools (stubs; pro-only)
  def ai_task_recommendations(%User{id: user_id}, %Idea{} = _idea, %Plan{} = _plan) do
    authorize_pro!(user_id)
    {:ok, [
      %{title: "Research related projects", description: "Look for prior art and inspiration."},
      %{title: "Define success criteria", description: "What does 'done' look like?"}
    ]}
  end

  def ai_document_summary(%User{id: user_id}, %Document{} = document) do
    authorize_pro!(user_id)
    content = document.content || ""
    summary = content |> String.split() |> Enum.take(50) |> Enum.join(" ")
    {:ok, summary}
  end

  def ai_document_completion(%User{id: user_id}, prompt) do
    authorize_pro!(user_id)
    {:ok, prompt <> " ..."}
  end

  defp authorize_pro!(user_id) do
    plan = get_user_subscription_plan(user_id)
    if plan != "pro", do: raise("pro_plan_required")
    :ok
  end
end
