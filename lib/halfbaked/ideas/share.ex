defmodule Halfbaked.Ideas.Share do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "shares" do
    field :shareable_id, :binary_id
    field :shareable_type, :string
    field :permission_level, :string, default: "view"

    belongs_to :user, Halfbaked.Accounts.User, type: :id

    timestamps(type: :utc_datetime)
  end

  def changeset(share, attrs) do
    share
    |> cast(attrs, [:user_id, :shareable_id, :shareable_type, :permission_level])
    |> validate_required([:user_id, :shareable_id, :shareable_type, :permission_level])
    |> validate_inclusion(:permission_level, ["view", "edit"])
  end
end
