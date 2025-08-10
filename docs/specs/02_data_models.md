# Specification: Data Models

This document defines the database schema and relationships for the "halfbaked" application.

## 1. `users`
Stores user authentication credentials.

- `id`: UUID, Primary Key
- `email`: VARCHAR(255), Unique, Not Null (for email/pass auth)
- `password_hash`: VARCHAR(255), Nullable (null for OAuth users)
- `provider`: VARCHAR(50) (e.g., "email", "google", "github")
- `provider_id`: VARCHAR(255), Nullable (for OAuth users)
- `confirmed_at`: DATETIME, Nullable (for email verification)
- `timestamps`: `inserted_at`, `updated_at`

**Relationships:**
- Has one `profile`
- Has many `ideas`
- Has many `comments`
- Has many `stars`
- Has many `shares`

## 2. `profiles`
Stores user profile information.

- `id`: UUID, Primary Key
- `user_id`: UUID, Foreign Key to `users.id`, Not Null
- `full_name`: VARCHAR(255)
- `avatar_url`: VARCHAR(255), Nullable
- `subscription_plan`: VARCHAR(50), Default: "free" ("free", "pro")
- `timestamps`: `inserted_at`, `updated_at`

**Relationships:**
- Belongs to one `user`

## 3. `ideas`
The core workspace for an idea.

- `id`: UUID, Primary Key
- `user_id`: UUID, Foreign Key to `users.id`, Not Null
- `title`: VARCHAR(255), Not Null
- `description`: TEXT
- `visibility`: VARCHAR(50), Default: "public" ("public", "private")
- `timestamps`: `inserted_at`, `updated_at`

**Relationships:**
- Belongs to one `user`
- Has many `plans`
- Has many `documents`
- Has many `tags` (through a join table)
- Has many `comments` (polymorphic)
- Has many `stars` (polymorphic)
- Has many `shares`

## 4. `plans`
A collection of tasks to execute an idea.

- `id`: UUID, Primary Key
- `idea_id`: UUID, Foreign Key to `ideas.id`, Not Null
- `title`: VARCHAR(255), Not Null
- `description`: TEXT
- `timestamps`: `inserted_at`, `updated_at`

**Relationships:**
- Belongs to one `idea`
- Has many `tasks`
- Has many `tags` (through a join table)
- Has many `comments` (polymorphic)

## 5. `tasks`
A single, actionable item within a plan.

- `id`: UUID, Primary Key
- `plan_id`: UUID, Foreign Key to `plans.id`, Not Null
- `title`: VARCHAR(255), Not Null
- `description`: TEXT
- `status`: VARCHAR(50), Default: "todo" ("todo", "in_progress", "done")
- `due_date`: DATE, Nullable
- `timestamps`: `inserted_at`, `updated_at`

**Relationships:**
- Belongs to one `plan`
- Has many `tags` (through a join table)
- Has many `comments` (polymorphic)

## 6. `documents`
Stores user-generated content related to an idea.

- `id`: UUID, Primary Key
- `idea_id`: UUID, Foreign Key to `ideas.id`, Not Null
- `title`: VARCHAR(255), Not Null
- `content`: TEXT
- `timestamps`: `inserted_at`, `updated_at`

**Relationships:**
- Belongs to one `idea`
- Has many `tags` (through a join table)
- Has many `comments` (polymorphic)

## 7. `tags`
For categorizing content.

- `id`: UUID, Primary Key
- `name`: VARCHAR(50), Unique, Not Null

## 8. `taggings` (Join Table)
Connects tags to taggable items.

- `tag_id`: UUID, Foreign Key to `tags.id`
- `taggable_id`: UUID (polymorphic)
- `taggable_type`: VARCHAR(50) (e.g., "Idea", "Plan", "Task", "Document")

## 9. `comments`
User comments on various resources.

- `id`: UUID, Primary Key
- `user_id`: UUID, Foreign Key to `users.id`
- `content`: TEXT, Not Null
- `parent_comment_id`: UUID, Foreign Key to `comments.id`, Nullable (for replies)
- `commentable_id`: UUID (polymorphic)
- `commentable_type`: VARCHAR(50)
- `timestamps`: `inserted_at`, `updated_at`

## 10. `stars`
User "stars" or "likes" on various resources.

- `id`: UUID, Primary Key
- `user_id`: UUID, Foreign Key to `users.id`
- `starable_id`: UUID (polymorphic)
- `starable_type`: VARCHAR(50)

## 11. `shares`
Manages access for shared content.

- `id`: UUID, Primary Key
- `user_id`: UUID, Foreign Key to `users.id` (the user being shared with)
- `shareable_id`: UUID (polymorphic)
- `shareable_type`: VARCHAR(50)
- `permission_level`: VARCHAR(50) ("view", "edit")
- `timestamps`: `inserted_at`, `updated_at`
