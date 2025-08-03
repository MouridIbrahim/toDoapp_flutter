import 'package:flutter/material.dart';
import 'package:mytodoapp/models/Task.dart';
import 'package:mytodoapp/screens/details_page.dart';
import 'package:mytodoapp/screens/newtask_page.dart';
import 'package:mytodoapp/services/database_helper.dart';
import 'package:mytodoapp/services/task_repository.dart';
import 'package:mytodoapp/shared/styled_text.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late TaskRepository taskRepository;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    taskRepository = TaskRepository(databaseHelper: DatabaseHelper.instance);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await taskRepository.getAllTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  Future<void> _toggleTaskCompletion(Task task, bool? value) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      category: task.category,
      isCompleted: value ?? false,
    );

    await taskRepository.updateTask(updatedTask);
    _loadTasks();
  }

  Future<void> _deleteTask(int taskId) async {
    await taskRepository.deleteTask(taskId);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final workTasks = tasks.where((task) => task.category == 'Work').toList();
    final personalTasks = tasks.where((task) => task.category == 'Personal').toList();

    return Scaffold(
      appBar: AppBar(
        title: const StyledHeadline('Tasks'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewtaskPage()),
              );
              _loadTasks();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const StyledTitle('Work'),
            const SizedBox(height: 10),
            ..._buildTaskList(workTasks),
            const SizedBox(height: 20),
            const StyledTitle('Personal'),
            const SizedBox(height: 10),
            ..._buildTaskList(personalTasks),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTaskList(List<Task> tasks) {
    return tasks.map((task) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 2,
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            final updatedTask = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetails(task: task),
              ),
            );
            if (updatedTask != null) {
              await taskRepository.updateTask(updatedTask);
              _loadTasks();
            }
          },
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (bool? value) {
                  _toggleTaskCompletion(task, value);
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.dueDate ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: _getDueDateColor(task.dueDate ?? ''),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteTask(task.id!);
                },
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Color _getDueDateColor(String dueDate) {
    if (dueDate.isEmpty) return Colors.grey;

    try {
      final taskDate = DateTime.parse(dueDate);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      if (taskDate == today) {
        return Colors.red; // Due Today
      } else if (taskDate == tomorrow) {
        return Colors.orange; // Due Tomorrow
      } else if (taskDate.isBefore(today)) {
        return Colors.grey.shade700; // Past due date
      } else {
        return Colors.grey; // Future dates
      }
    } catch (e) {
      return Colors.grey;
    }
  }
}