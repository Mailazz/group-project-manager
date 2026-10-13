import '../models/task.dart';
import 'task_repository.dart';

// In-memory data source. Later you can add ApiTaskRepository
// without changing any screen (OCP + LSP).
class MockTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    Task(
      id: 1,
      title: 'Write project report',
      description: 'Introduction and methodology',
      assignedTo: 'Ayesha',
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Task(
      id: 2,
      title: 'Design app screens',
      description: 'Home screen and add task screen',
      assignedTo: 'Ali',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      isCompleted: true,
    ),
    Task(
      id: 3,
      title: 'Prepare presentation',
      description: 'Make 10 slides',
      assignedTo: 'Sara',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  List<Task> getTasks() => List.unmodifiable(_tasks);

  @override
  void addTask(Task task) => _tasks.add(task);

  @override
  void deleteTask(int id) => _tasks.removeWhere((t) => t.id == id);

  @override
  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }
}
