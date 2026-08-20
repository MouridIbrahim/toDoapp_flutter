import 'package:mytodoapp/domain/entities/task_entity.dart';

/// Abstract repository interface for task operations
/// This defines the contract that all task repositories must implement
abstract class TaskRepositoryInterface {
  /// Insert a new task
  Future<int> insertTask(TaskEntity task);

  /// Get all tasks
  Future<List<TaskEntity>> getAllTasks();

  /// Get task by ID
  Future<TaskEntity?> getTaskById(int id);

  /// Get tasks by category
  Future<List<TaskEntity>> getTasksByCategory(String category);

  /// Update an existing task
  Future<int> updateTask(TaskEntity task);

  /// Delete a task by ID
  Future<int> deleteTask(int id);

  /// Get completed tasks
  Future<List<TaskEntity>> getCompletedTasks();

  /// Get pending tasks
  Future<List<TaskEntity>> getPendingTasks();

  /// Get tasks due on a specific date
  Future<List<TaskEntity>> getTasksByDate(DateTime date);

  /// Search tasks by title or description
  Future<List<TaskEntity>> searchTasks(String query);
}
