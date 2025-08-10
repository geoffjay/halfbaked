# halfbaked

## a half baked ideas application

half baked is a website where users can create spaces to share their "half
baked" ideas. tooling would be available to the user to improve their ideas
through documentation, suggestions for similar prior works, and via a community
of users who also have ideas that they don't know how to start. 

your task is to create an elixir application that uses pheonix, viewcomponent,
and should use tailwindcss for styling. oauth2 authentication should be added
and should support google and github as providers, the ability to create an
account using an email address and password should also be supported. the
following should be created:

- a login screen with:
  - email/password, google provider, or gitlab provider
  - a link to register/create an account on the login screen
  - a link to recover a user name or password
  - completing login that takes you to the application dashboard
- a dashboard page with:
  - a header bar that is the full width of the page, and a white background
  - a sidenav on the left that contains a menu where each item has an icon and text, and when collapsed shows only the icon, and white background
  - a content section that has rounded corners and a drop shadow, and is slate grey
  - a footer that has a white background
  - the header, sidenav, and footer should all be fixed and the content section is what scrolls all of the page content
- an about page
- a profile page
- a settings page

the backend application should have a user model for authentication and a
profile model containing personal and account information, users can have
ideas, plans, tasks, and documents.

## ideas, plans, tasks, and documents

the ideas, plans, tasks, and documents should be stored in a database, and
should be searchable by title, description, and tags. the ideas, plans, tasks,
and documents should be able to be created, edited, and deleted by the user.

the ideas, plans, tasks, and documents should be able to be shared with other
users, and the user should be able to see who has shared the idea, plan, task,
or document.

the ideas, plans, tasks, and documents should be able to be commented on, and
users should be able to reply to comments.

the ideas, plans, tasks, and documents should be able to be starred, and users
should be able to see who has starred the idea, plan, task, or document.

## user authentication

user authentication should be done using oauth2 with google and github as
providers. the user should be able to create an account using an email address
and password, and the user should be able to login using an email address and
password.

## user profile

a user profile should be created that contains personal and account information.
the user should be able to edit their profile information.

## public and private

ideas, plans, tasks, and documents should be able to be public or private. a user
does not need to be logged in to view public ideas, plans, tasks, and documents.
a user that is not logged can not create, edit, or delete public ideas, plans,
tasks, or documents. they also cannot comment on public ideas, plans, tasks, or
documents.

## ideas

an idea is a workspace, it is the core of halfbaked and is what users will be
creating and editing. an idea should be searchable by title, description, and
tags.

when created, an idea should be created with a title, description, and tags.
by default, an idea should be public, but it should be possible to make an idea
private.

## documents

## tags

ideas, plans, tasks, and documents should be able to be tagged with tags. the
tags should be searchable by tag name.

## search

ideas, plans, tasks, and documents should be searchable by title, description,
and tags.

## comments

ideas, plans, tasks, and documents should be able to be commented on, and users
should be able to reply to comments.

## starring

ideas, plans, tasks, and documents should be able to be starred, and users should
be able to see who has starred the idea, plan, task, or document.

## sharing

ideas, plans, tasks, and documents should be able to be shared with other users.

## free plan features

a free plan should be available that includes the following features:

- unlimited public ideas
- 10 private ideas
- unlimited plans
- unlimited tasks
- unlimited documents

## pro/paid plan features

a pro/paid plan should be available that includes the following features:

- everything in the free plan
- unlimited private workspaces
- access to AI tools that can perform tasks such as task recommendations, 
  document summarization, and document completion

the pro/paid plan should be available for $8/month.
