# ToDoApp

A cross-platform Flutter application for managing tasks, featuring user authentication, task CRUD operations, and a clean, well-documented codebase.

## Features
- User authentication (login, signup, logout)
- Task creation, editing, deletion, and completion
- Due date management with calendar picker
- Search and filter tasks by title, description, and status
- Responsive UI with custom header and styles
- Backend integration using Parse Server
- Well-documented code with Dart documentation comments

## Directory Structure
```
lib/
  main.dart                # App entry point and configuration
  routing/
    app_router.dart        # Route generation and mapping
  screens/
    home.dart              # Initial navigation based on authentication
    login.dart             # Login and signup UI and logic
    task_list.dart         # Task list, search, filter, and sort
    task_details.dart      # Task detail view and editing
  services/
    task_service.dart      # Backend service for task CRUD
  widgets/
    common_header.dart     # Reusable app bar/header
  themes/
    styles.dart            # Common text styles
  helpers/
    helper_service.dart    # UI helper utilities (e.g., SnackBar)
    app_regex.dart         # Regex helpers for validation
```

## Main Classes and Responsibilities
- **Home**: Determines initial navigation based on user authentication.
- **Login**: Handles user login and registration, with form validation.
- **TaskList**: Displays, filters, and sorts the list of tasks.
- **TaskDetails**: Allows viewing and editing of a single task.
- **TaskService**: Handles all backend operations for tasks (save, delete).
- **CommonHeader**: Custom app bar for consistent branding.
- **TextStyles**: Centralized text style definitions.
- **HelperService**: Utility for showing messages and UI helpers.
- **AppRegexHelper**: Utility for validating email and password formats.

## Documentation and Code Style
- All main classes and public methods are documented using Dart's `///` documentation comments.
- Comments explain the purpose and usage of each class and function for maintainability.
- Follows Dart and Flutter best practices for naming, structure, and widget composition.

## Getting Started
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Update Parse Server credentials in `main.dart` if needed.
4. Run the app with `flutter run`.

## Backend
- Uses [Back4App Parse Server](https://www.back4app.com/) for user and task data storage.
- Update `applicationId`, `clientKey`, and `parseURL` in `main.dart` for your own backend.

## Contribution
- Please ensure all new classes and public methods include documentation comments.
- Follow the established directory and naming conventions.

---
This project demonstrates best practices in Flutter app development, code organization, and documentation.
