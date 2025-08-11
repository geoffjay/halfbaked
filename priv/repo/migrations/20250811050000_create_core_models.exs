defmodule Halfbaked.Repo.Migrations.CreateCoreModels do
  use Ecto.Migration

  def change do
    # 1. profiles (uuid pk), belongs_to users (integer id)
    create table(:profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :full_name, :string
      add :avatar_url, :string
      add :subscription_plan, :string, null: false, default: "free"

      timestamps(type: :utc_datetime)
    end
    create unique_index(:profiles, [:user_id])

    # 2. ideas (uuid pk), belongs_to users (integer id)
    create table(:ideas, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :description, :text
      add :visibility, :string, null: false, default: "public"

      timestamps(type: :utc_datetime)
    end
    create index(:ideas, [:user_id])

    # 3. plans (uuid pk), belongs_to ideas (uuid)
    create table(:plans, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :idea_id, references(:ideas, type: :binary_id, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :description, :text

      timestamps(type: :utc_datetime)
    end
    create index(:plans, [:idea_id])

    # 4. tasks (uuid pk), belongs_to plans (uuid)
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :plan_id, references(:plans, type: :binary_id, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :description, :text
      add :status, :string, null: false, default: "todo"
      add :due_date, :date

      timestamps(type: :utc_datetime)
    end
    create index(:tasks, [:plan_id])

    # 5. documents (uuid pk), belongs_to ideas (uuid)
    create table(:documents, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :idea_id, references(:ideas, type: :binary_id, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :content, :text

      timestamps(type: :utc_datetime)
    end
    create index(:documents, [:idea_id])

    # 6. tags (uuid pk)
    create table(:tags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
    end
    create unique_index(:tags, [:name])

    # 7. taggings (join; polymorphic)
    create table(:taggings, primary_key: false) do
      add :tag_id, references(:tags, type: :binary_id, on_delete: :delete_all), null: false
      add :taggable_id, :binary_id, null: false
      add :taggable_type, :string, null: false
    end
    create index(:taggings, [:tag_id])
    create index(:taggings, [:taggable_type, :taggable_id])
    create unique_index(:taggings, [:tag_id, :taggable_type, :taggable_id], name: :taggings_uniq)

    # 8. comments (uuid pk; polymorphic; self-referencing parent)
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :content, :text, null: false
      add :parent_comment_id, references(:comments, type: :binary_id, on_delete: :nilify_all)
      add :commentable_id, :binary_id, null: false
      add :commentable_type, :string, null: false

      timestamps(type: :utc_datetime)
    end
    create index(:comments, [:user_id])
    create index(:comments, [:parent_comment_id])
    create index(:comments, [:commentable_type, :commentable_id])

    # 9. stars (uuid pk; polymorphic)
    create table(:stars, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :starable_id, :binary_id, null: false
      add :starable_type, :string, null: false
    end
    create index(:stars, [:user_id])
    create index(:stars, [:starable_type, :starable_id])
    create unique_index(:stars, [:user_id, :starable_type, :starable_id], name: :stars_uniq)

    # 10. shares (uuid pk; polymorphic)
    create table(:shares, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :shareable_id, :binary_id, null: false
      add :shareable_type, :string, null: false
      add :permission_level, :string, null: false, default: "view"

      timestamps(type: :utc_datetime)
    end
    create index(:shares, [:user_id])
    create index(:shares, [:shareable_type, :shareable_id])
    create unique_index(:shares, [:user_id, :shareable_type, :shareable_id], name: :shares_uniq)
  end
end
