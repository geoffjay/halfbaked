# Specification: Features

This document details the core features of the "halfbaked" application.

## 1. Idea Management (CRUD)

- **Create:** Users can create a new idea from their dashboard. The creation form will require a `title`, `description`, and optional `tags`. The `visibility` will default to "public".
- **Read:** Users can view any public idea. They can view their own private ideas or ideas shared with them. The idea view will show the title, description, tags, associated plans, and documents.
- **Update:** The author of an idea can edit its `title`, `description`, `tags`, and `visibility`.
- **Delete:** The author of an idea can delete it. This action should require a confirmation step.

## 2. Plan and Task Management

- **Plans:** Within an idea, a user can create multiple plans. Each plan has a `title` and `description`.
- **Tasks:** Within a plan, a user can create multiple tasks. Each task has a `title`, `description`, `status` (`todo`, `in_progress`, `done`), and an optional `due_date`. Users can update the status of a task (e.g., via drag-and-drop).

## 3. Document Management

- Within an idea, a user can create multiple documents. Each document has a `title` and `content`.
- The `content` field should support rich text editing (e.g., using a Markdown editor).

## 4. Search

- A global search bar will be present in the header.
- Search functionality will query across `ideas`, `plans`, `tasks`, and `documents`.
- The search will match against the `title`, `description`, and `tags` of the searchable items.
- Search results will be displayed on a dedicated search results page, categorized by item type.

## 5. Commenting

- Users can add comments to `ideas`, `plans`, `tasks`, and `documents`.
- Users can reply to existing comments, creating nested threads.
- Comment authors can edit or delete their own comments.

## 6. Starring

- Users can "star" `ideas`, `plans`, `tasks`, and `documents`.
- A "Starred" page, accessible from the sidenav, will list all items the user has starred.
- The UI will display a count of how many stars an item has received.

## 7. Sharing

- The author of an `idea` can share it with other registered users.
- Sharing can be configured with two permission levels:
  - **View:** The shared user can only view the idea and its contents.
  - **Edit:** The shared user has full CRUD permissions on the idea and its contents (plans, tasks, documents).
- A "Shared with Me" page, accessible from the sidenav, will list all ideas that have been shared with the current user.

## 8. Public and Private Visibility

- `Ideas` can be marked as "public" or "private".
- **Public:** Viewable by anyone, including non-authenticated users. Non-authenticated users cannot interact (comment, star, etc.).
- **Private:** Viewable only by the author and users it has been explicitly shared with.
- A user's free plan has a limit on the number of private ideas they can create.

## 9. AI Tools (Pro Plan Feature)

- **Task Recommendations:** On a `plan` page, a button will allow pro users to generate suggested tasks based on the `idea` and `plan` descriptions.
- **Document Summarization:** On a `document` page, a button will allow pro users to generate a concise summary of the document's content.
- **Document Completion:** Within the document editor, a pro user can trigger an AI-powered text completion suggestion.
