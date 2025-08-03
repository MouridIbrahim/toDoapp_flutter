import 'package:mytodoapp/models/Task.dart';
import 'package:mytodoapp/services/database_helper.dart';




class TaskRepository {
  final DatabaseHelper databaseHelper;

  TaskRepository({required this.databaseHelper});

  // Insert a new task
  Future<int> insertTask(Task task) async {
    final db = await databaseHelper.database;
    return await db.insert('tasks', task.toMap());
  }

  // Fetch all tasks
  Future<List<Task>> getAllTasks() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return maps.map((map) => Task.fromMap(map)).toList();
  }

  // Fetch tasks by category (optional helper)
  Future<List<Task>> getTasksByCategory(String category) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'category = ?',
      whereArgs: [category],
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  // Update a task
  Future<int> updateTask(Task task) async {
    final db = await databaseHelper.database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task
  Future<int> deleteTask(int id) async {
    final db = await databaseHelper.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Optional: fetch only completed tasks
  Future<List<Task>> getCompletedTasks() async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }

    Future<Task?> getTask(int id) async {
    final db = await databaseHelper.database;
    final taskData = await databaseHelper.getTask(id);
    return taskData != null ? Task.fromMap(taskData) : null;
  }
}
