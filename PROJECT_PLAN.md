# Project Plan: halfbaked

This document outlines the high-level execution plan for building the "halfbaked" application. The work is broken down into epics, with associated user stories.

---

## Epic 1: Project Setup & Foundation

- **Goal:** Initialize the project, set up the development environment, and create the basic application shell.
- **User Stories:**
  - As a developer, I want to generate a new Phoenix project with the necessary dependencies (e.g., TailwindCSS).
  - As a developer, I want to establish a basic file structure and configuration for the project.
  - As a developer, I want to create the main application layout (header, footer, sidenav, content area) as a static template.

## Epic 2: User Authentication

- **Goal:** Implement a complete and secure authentication system.
- **User Stories:**
  - As a user, I want to be able to create an account using my email and password.
  - As a user, I want to be able to log in and out with my email and password.
  - As a user, I want to be able to sign up and log in using my Google account.
  - As a user, I want to be able to sign up and log in using my GitHub account.
  - As a user, I want to be able to recover my password if I forget it.
  - As a user, I want my session to be remembered if I check "Remember Me".

## Epic 3: Core "Idea" Management

- **Goal:** Implement the primary functionality of creating and managing ideas.
- **User Stories:**
  - As a logged-in user, I want to be able to create a new idea with a title and description.
  - As the author of an idea, I want to be able to view and edit its details.
  - As the author of an idea, I want to be able to delete it.
  - As a user, I want to be able to see a list of my own ideas on my dashboard.
  - As any user, I want to be able to view any idea that is marked as "public".

## Epic 4: Content Creation (Plans, Tasks, Documents)

- **Goal:** Build the features for adding detailed content to an idea.
- **User Stories:**
  - As an idea author, I want to be able to add multiple "plans" to my idea.
  - As a plan author, I want to be able to add multiple "tasks" to my plan.
  - As a task owner, I want to be able to change the status of a task.
  - As an idea author, I want to be able to add multiple "documents" to my idea using a rich text editor.
  - As an idea author, I want to be able to CRUD all plans, tasks, and documents within my idea.

## Epic 5: Social & Collaboration Features

- **Goal:** Implement features that allow users to interact with content and each other.
- **User Stories:**
  - As a logged-in user, I want to be able to comment on ideas, plans, tasks, and documents.
  - As a logged-in user, I want to be able to reply to comments.
  - As a logged-in user, I want to be able to "star" content items.
  - As a logged-in user, I want to see a list of all items I have starred.
  - As an idea author, I want to be able to share my private ideas with other users with "view" or "edit" permissions.
  - As a user, I want to see a list of ideas that have been shared with me.

## Epic 6: Search & Discovery

- **Goal:** Implement a global search feature.
- **User Stories:**
  - As a user, I want to be able to use a search bar in the header to find content.
  - As a user, I want the search to look for my query in the title, description, and tags of all public content and my own private content.
  - As a user, I want to be able to tag my content (ideas, plans, etc.) to make it easier to find.

## Epic 7: Monetization & Subscriptions

- **Goal:** Integrate a payment system and manage user subscription plans.
- **User Stories:**
  - As a free user, I should be prevented from creating more than 10 private ideas.
  - As a user, I want to be able to upgrade my account from the Free to the Pro plan.
  - As a Pro user, I want to be able to manage my subscription and billing information.
  - As a Pro user, I want to be able to cancel my subscription.
  - As a developer, I want to integrate a payment provider (e.g., Stripe) to handle transactions.

## Epic 8: AI-Powered Tools (Pro Feature)

- **Goal:** Implement the exclusive AI features for Pro users.
- **User Stories:**
  - As a Pro user, I want to be able to generate task suggestions for my plans.
  - As a Pro user, I want to be able to generate a summary for any of my documents.
  - As a Pro user, I want to be able to get AI-powered text completion suggestions while writing a document.
