import 'package:mytodoapp/core/error_handling/exceptions.dart';
import 'package:mytodoapp/data/datasources/task_local_datasource.dart';
import 'package:mytodoapp/data/models/task_model.dart';
import 'package:mytodoapp/domain/entities/task_entity.dart';
import 'package:mytodoapp/domain/repositories/task_repository_interface.dart';

/// Implementation of TaskRepositoryInterface using local data source
class TaskRepository implements TaskRepositoryInterface {
  final TaskLocalDataSource localDataSource;

  TaskRepository({required this.localDataSource});

  @override
  Future<int> insertTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      return await localDataSource.insertTask(taskModel);
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw TaskException('Failed to insert task', originalError: e);
    }
  }

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    try {
      final tasks = await localDataSource.getAllTasks();
      return tasks;
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw TaskException('Failed to get all tasks', originalError: e);
    }
  }

  @override
  Future<TaskEntity?> getTaskById(int id) async {
    try {
      return await localDataSource.getTaskById(id);
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw TaskException('Failed to get task by ID', originalError: e);
    }
  }

  @override
  Future<List<TaskEntity>> getTasksByCategory(String category) async {
    try {
      return await localDataSource.getTasksByCategory(category);
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw TaskException('Failed to get tasks by category', originalError: e);
    }
  }

  @override
  Future<int> updateTask(TaskEntity task) async {
    try {
      if (task.id == null) {
        throw TaskException('Cannot update task without ID');
      }
      final taskModel = TaskModel.fromEntity(task);
      return await localDataSource.updateTask(taskModel);
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw TaskException('Failed to update task', originalError: e);
    }
  }

  @override
  Future<int> deleteTask(int id) async {
    try {
      return await localDataSource.deleteTask(id);
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw TaskException('Failed to delete task', originalError: e);
    }
  }

  @override
  Future<List<TaskEntity>> getCompletedTasks() async {
    try {
      return await localDataSource.getCompletedTasks();
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw TaskException('Failed to get completed tasks', originalError: e);
    }
  }

  @override
  Future<List<TaskEntity>> getPendingTasks() async {
    try {
      return await localDataSource.getPendingTasks();
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw TaskException('Failed to get pending tasks', originalError: e);
    }
  }

  @override
  Future<List<TaskEntity>> getTasksByDate(DateTime date) async {
    try {
      return await localDataSource.getTasksByDate(date);
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw TaskException('Failed to get tasks by date', originalError: e);
    }
  }

  @override
  Future<List<TaskEntity>> searchTasks(String query) async {
    try {
      return await localDataSource.searchTasks(query);
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw TaskException('Failed to search tasks', originalError: e);
    }
  }
}
