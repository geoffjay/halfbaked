defmodule Halfbaked.Ideas.Tagging do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "taggings" do
    belongs_to :tag, Halfbaked.Ideas.Tag, type: :binary_id
    field :taggable_id, :binary_id
    field :taggable_type, :string
  end

  def changeset(tagging, attrs) do
    tagging
    |> cast(attrs, [:tag_id, :taggable_id, :taggable_type])
    |> validate_required([:tag_id, :taggable_id, :taggable_type])
  end
end
