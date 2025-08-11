defmodule Halfbaked.Ideas.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "plans" do
    field :title, :string
    field :description, :string

    belongs_to :idea, Halfbaked.Ideas.Idea
    has_many :tasks, Halfbaked.Ideas.Task

    timestamps(type: :utc_datetime)
  end

  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:title, :description, :idea_id])
    |> validate_required([:title, :idea_id])
  end
end
