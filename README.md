# Group Project Manager 👥

A small Flutter app where a group assigns tasks, sets deadlines and tracks project progress.
Built for the Mobile Computing course using SOLID principles.

## Features
- Progress bar showing how much of the project is done
- Add tasks with title (required), description, assigned member and deadline
- Mark tasks complete, delete tasks, filter by All / Pending / Completed
- Overdue deadlines highlighted in red
- Light / dark theme toggle
- Empty state and snackbar feedback

## Project structure
```
lib/
├── main.dart
├── models/        task.dart, task_filter.dart, team_members.dart
├── repositories/  task_repository.dart (abstract), mock_task_repository.dart
├── services/      task_service.dart
├── screens/       home_screen.dart, add_task_screen.dart
└── widgets/       task_card.dart, progress_header.dart
```
UI → TaskService → TaskRepository (abstract) ← MockTaskRepository

## How to run
```
flutter create .
flutter pub get
flutter run
```
`flutter create .` generates the Android/iOS/web folders without touching `lib/`.
