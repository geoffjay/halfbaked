defmodule Halfbaked.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles" do
    field :full_name, :string
    field :avatar_url, :string
    field :subscription_plan, :string, default: "free"

    belongs_to :user, Halfbaked.Accounts.User, type: :id

    timestamps(type: :utc_datetime)
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:full_name, :avatar_url, :subscription_plan, :user_id])
    |> validate_required([:user_id])
    |> validate_inclusion(:subscription_plan, ["free", "pro"])
  end
end
