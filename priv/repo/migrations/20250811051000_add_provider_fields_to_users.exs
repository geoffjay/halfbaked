defmodule Halfbaked.Repo.Migrations.AddProviderFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :provider, :string, null: false, default: "email"
      add :provider_id, :string
    end

    create index(:users, [:provider])
    create unique_index(:users, [:provider, :provider_id], where: "provider_id IS NOT NULL", name: :users_provider_provider_id_unique)
  end
end
