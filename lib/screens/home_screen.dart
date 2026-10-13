import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/task_filter.dart';
import '../services/task_service.dart';
import '../widgets/progress_header.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  final TaskService service;
  final VoidCallback onToggleTheme;

  const HomeScreen({
    super.key,
    required this.service,
    required this.onToggleTheme,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TaskFilter selectedFilter = TaskFilter.all;

  void showMessage(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> openAddScreen() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(service: widget.service),
      ),
    );
    if (!mounted) return;
    if (added == true) {
      setState(() {});
      showMessage('Task added ✅');
    }
  }

  void toggleTask(Task task) {
    setState(() {
      widget.service.toggleTask(task);
    });
    showMessage(task.isCompleted ? 'Task completed 🎉' : 'Marked as pending');
  }

  void deleteTask(Task task) {
    setState(() {
      widget.service.deleteTask(task.id);
    });
    showMessage('Task deleted 🗑️');
  }

  Widget buildFilterChip(String label, TaskFilter filter) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedFilter == filter,
        onSelected: (value) {
          setState(() {
            selectedFilter = filter;
          });
        },
      ),
    );
  }

  Widget buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_outlined, size: 70, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No tasks here yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Tap the + button to add a task for your group.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.service.getFilteredTasks(selectedFilter);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Group Project Manager 👥',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Change theme',
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          ProgressHeader(
            progress: widget.service.progress,
            done: widget.service.completedCount,
            total: widget.service.totalCount,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                buildFilterChip('All', TaskFilter.all),
                buildFilterChip('Pending', TaskFilter.pending),
                buildFilterChip('Completed', TaskFilter.completed),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: tasks.isEmpty
                ? buildEmptyState()
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        onToggle: () => toggleTask(task),
                        onDelete: () => deleteTask(task),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddScreen,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}
