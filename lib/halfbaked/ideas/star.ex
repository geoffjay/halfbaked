defmodule Halfbaked.Ideas.Star do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "stars" do
    field :starable_id, :binary_id
    field :starable_type, :string

    belongs_to :user, Halfbaked.Accounts.User, type: :id
  end

  def changeset(star, attrs) do
    star
    |> cast(attrs, [:user_id, :starable_id, :starable_type])
    |> validate_required([:user_id, :starable_id, :starable_type])
  end
end
