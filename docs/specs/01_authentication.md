# Specification: Authentication

This document outlines the authentication requirements for the "halfbaked" application.

## 1. User Account Types

Users can authenticate using three methods:
- Email and Password
- Google OAuth2
- GitHub OAuth2

## 2. Registration Flow

### 2.1. Email/Password Registration
- A "Create Account" page will be accessible from a link on the Login page.
- The registration form will require:
  - Full Name
  - Email Address (must be unique)
  - Password (must be at least 12 characters)
- Upon submission, the system will:
  - Validate the input.
  - Create a new `User` record.
  - Create an associated `Profile` record.
  - Send a verification email to the user's email address.
  - Log the user in and redirect them to the dashboard.

### 2.2. OAuth2 Registration (Google/GitHub)
- On the Login or Register page, users can click "Sign in with Google" or "Sign in with GitHub".
- The standard OAuth2 flow will be initiated.
- Upon successful authentication with the provider, the system will:
  - Check if a user with the provider's email already exists.
  - If the user does not exist, a new `User` and `Profile` will be created using the information from the provider (name, email).
  - If the user exists, the OAuth2 identity will be linked to the existing user account.
  - Log the user in and redirect them to the dashboard.

## 3. Login Flow

### 3.1. Email/Password Login
- The login page will have fields for Email and Password.
- Upon successful authentication, the user is redirected to the application dashboard.
- If authentication fails, an "Invalid email or password" message is shown.

### 3.2. OAuth2 Login (Google/GitHub)
- Users can log in by clicking the Google or GitHub buttons.
- This will follow the same flow as OAuth2 registration. If the user account exists, they will be logged in and redirected to the dashboard.

## 4. Password Recovery
- A "Forgot Password?" link will be available on the login page.
- This link will lead to a page where the user can enter their email address.
- If the email exists in the system, a password reset link will be sent to their email.
- The link will be a single-use token with a limited expiry time (e.g., 1 hour).
- Clicking the link will take the user to a page where they can set a new password.

## 5. User Sessions
- Sessions will be managed using secure cookies.
- A "Remember Me" option on the login page will extend the session duration.
- The user's session should be terminated on the server-side upon logout.
