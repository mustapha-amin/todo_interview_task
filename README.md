# PocketTasks

A modern todo app that allows users to manage tasks effortlessly

## Features

- Beautiful UI with smooth animations
- Dark/Light theme toggle
- Create, edit, and delete tasks
- Mark tasks as complete/incmplete
- Set due dates for tasks
- Filter tasks (All, Active, Completed)
- Persistent local storage using Hive

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd todo_interview_task
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## State Management Approach

This app uses **Riverpod** as the state management solution, which provides:

- **Type Safety**: Compile-time safety with strong typing
- **Provider Pattern**: Clean dependency injection and state management
- **Automatic Disposal**: Memory management handled automatically
- **Testing Friendly**: Easy to test with mock providers

### Key Providers

- `todoNotifierProvider`: Manages todo CRUD operations
- `themeProvider`: Handles dark/light theme state
- `todoDBProvider`: Database service provider
- `todoBoxProvider`: Hive box provider for local storage

## Architecture Structure

This app uses a clean and maintainable architectural structure that is easy to understand at first glance

```
lib/
├── common/           # Shared utilities and extensions
├── models/          # Data models (Todo)
├── notifiers/       # State notifiers (TodoNotifier)
├── providers/       # Riverpod providers
├── screens/         # UI screens
├── services/        # Business logic (TodoDB)
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
```

## Screen recording

https://github.com/user-attachments/assets/26f432d1-f4af-4fed-997f-79a81eef5289


