defmodule Halfbaked.Ideas.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "documents" do
    field :title, :string
    field :content, :string

    belongs_to :idea, Halfbaked.Ideas.Idea

    timestamps(type: :utc_datetime)
  end

  def changeset(document, attrs) do
    document
    |> cast(attrs, [:title, :content, :idea_id])
    |> validate_required([:title, :idea_id])
  end
end
