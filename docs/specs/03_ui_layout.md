# Specification: UI Layout

This document describes the main UI layout and components for the "halfbaked" application, to be styled with TailwindCSS.

## 1. Overall Layout

The main application interface will consist of three fixed-position elements and one scrollable content area.

- **Header:** Fixed at the top.
- **Sidenav:** Fixed on the left.
- **Footer:** Fixed at the bottom.
- **Content Area:** The central area that will contain the page-specific content and will be vertically scrollable.

## 2. Header

- **Appearance:**
  - Full width of the viewport.
  - White background (`bg-white`).
  - A subtle bottom border (`border-b`).
  - Contains padding on the left and right.
- **Content:**
  - **Left Side:** Application Logo/Name.
  - **Right Side:**
    - Search bar.
    - Notifications icon.
    - User dropdown menu (avatar and name).

### 2.1. User Dropdown Menu
- Triggered by clicking the user's avatar/name in the header.
- **Menu Items:**
  - "Dashboard"
  - "Profile"
  - "Settings"
  - --- (Separator) ---
  - "Logout"

## 3. Sidenav

- **Appearance:**
  - Positioned on the left side of the screen.
  - White background (`bg-white`).
  - A subtle right border (`border-r`).
  - Two states: expanded (default) and collapsed.
- **States:**
  - **Expanded:** Shows an icon and text label for each menu item. A "Collapse" button is visible at the bottom.
  - **Collapsed:** Shows only the icon for each menu item. An "Expand" button is visible at the bottom. The sidenav's width is reduced significantly.
- **Menu Items:**
  - "Dashboard"
  - "My Ideas"
  - "Shared with Me"
  - "Starred"
  - "About"
  - "Settings"

## 4. Content Area

- **Appearance:**
  - Occupies the space between the header, sidenav, and footer.
  - Slate grey background color (`bg-slate-100` or similar).
  - The main content container within this area will have rounded corners (`rounded-lg`) and a drop shadow (`shadow-md`).
  - This is the only section of the main layout that scrolls.

## 5. Footer

- **Appearance:**
  - Full width of the viewport, positioned at the bottom.
  - White background (`bg-white`).
  - A subtle top border (`border-t`).
- **Content:**
  - Copyright notice (e.g., "© 2024 halfbaked").
  - Links to "Terms of Service", "Privacy Policy", and "About".

## 6. Login/Registration Pages

- These pages will use a simpler, centered layout.
- A card component in the center of the screen will contain the forms for login, registration, and password recovery.
- The application logo will be displayed above the card.
- Links for switching between login, registration, and password recovery will be present.
- Buttons for OAuth providers (Google, GitHub) will be displayed prominently.
