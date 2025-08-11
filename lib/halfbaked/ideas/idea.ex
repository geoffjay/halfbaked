defmodule Halfbaked.Ideas.Idea do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ideas" do
    field :title, :string
    field :description, :string
    field :visibility, :string, default: "public"

    belongs_to :user, Halfbaked.Accounts.User, type: :id

    has_many :plans, Halfbaked.Ideas.Plan
    has_many :documents, Halfbaked.Ideas.Document

    timestamps(type: :utc_datetime)
  end

  def changeset(idea, attrs) do
    idea
    |> cast(attrs, [:title, :description, :visibility, :user_id])
    |> validate_required([:title, :user_id])
    |> validate_inclusion(:visibility, ["public", "private"])
  end
end
