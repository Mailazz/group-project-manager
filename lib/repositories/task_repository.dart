import '../models/task.dart';

// Abstraction: the service depends on this, not on a concrete class (DIP)
abstract class TaskRepository {
  List<Task> getTasks();
  void addTask(Task task);
  void deleteTask(int id);
  void updateTask(Task task);
}
