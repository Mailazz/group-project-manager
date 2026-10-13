import '../models/task.dart';
import '../models/task_filter.dart';
import '../repositories/task_repository.dart';

// Business logic only: validation, filtering, progress.
class TaskService {
  final TaskRepository repository;

  TaskService(this.repository);

  List<Task> getTasks() => repository.getTasks();

  List<Task> getFilteredTasks(TaskFilter filter) {
    final tasks = repository.getTasks();
    switch (filter) {
      case TaskFilter.pending:
        return tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((t) => t.isCompleted).toList();
      case TaskFilter.all:
        return tasks;
    }
  }

  // Returns an error message, or null if the title is valid
  String? validateTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'Task title is required';
    }
    if (title.trim().length > 60) {
      return 'Title is too long';
    }
    return null;
  }

  void addTask({
    required String title,
    required String description,
    required String assignedTo,
    required DateTime dueDate,
  }) {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title.trim(),
      description: description.trim(),
      assignedTo: assignedTo,
      dueDate: dueDate,
    );
    repository.addTask(task);
  }

  void toggleTask(Task task) {
    task.isCompleted = !task.isCompleted;
    repository.updateTask(task);
  }

  void deleteTask(int id) => repository.deleteTask(id);

  int get completedCount =>
      repository.getTasks().where((t) => t.isCompleted).length;

  int get totalCount => repository.getTasks().length;

  // 0.0 to 1.0 for the progress bar
  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;
}
