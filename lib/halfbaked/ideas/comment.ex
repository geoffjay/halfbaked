defmodule Halfbaked.Ideas.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :content, :string
    field :commentable_id, :binary_id
    field :commentable_type, :string

    belongs_to :user, Halfbaked.Accounts.User, type: :id
    belongs_to :parent_comment, __MODULE__, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :commentable_id, :commentable_type, :user_id, :parent_comment_id])
    |> validate_required([:content, :commentable_id, :commentable_type, :user_id])
  end
end
