defmodule Halfbaked.Ideas.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tasks" do
    field :title, :string
    field :description, :string
    field :status, :string, default: "todo"
    field :due_date, :date

    belongs_to :plan, Halfbaked.Ideas.Plan

    timestamps(type: :utc_datetime)
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :status, :due_date, :plan_id])
    |> validate_required([:title, :plan_id])
    |> validate_inclusion(:status, ["todo", "in_progress", "done"])
  end
end
