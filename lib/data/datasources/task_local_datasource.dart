import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mytodoapp/core/constants/app_constants.dart';
import 'package:mytodoapp/core/error_handling/exceptions.dart';
import 'package:mytodoapp/data/models/task_model.dart';

/// Local database data source for task operations
class TaskLocalDataSource {
  final Database? _database;

  TaskLocalDataSource({Database? database}) : _database = database;

  /// Get database instance (lazy initialization)
  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDatabase();
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDatabase,
    );
  }

  /// Create database tables
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.tasksTable} (
        ${AppConstants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.columnTitle} TEXT NOT NULL,
        ${AppConstants.columnDescription} TEXT,
        ${AppConstants.columnDueDate} TEXT,
        ${AppConstants.columnCategory} TEXT,
        ${AppConstants.columnIsCompleted} INTEGER DEFAULT 0
      )
    ''');
  }

  /// Insert a task
  Future<int> insertTask(TaskModel task) async {
    try {
      final db = await database;
      return await db.insert(AppConstants.tasksTable, task.toMap());
    } catch (e) {
      throw DatabaseException('Failed to insert task', originalError: e);
    }
  }

  /// Get all tasks
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(AppConstants.tasksTable);
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get tasks', originalError: e);
    }
  }

  /// Get task by ID
  Future<TaskModel?> getTaskById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.tasksTable,
        where: '${AppConstants.columnId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return TaskModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw DatabaseException('Failed to get task by ID', originalError: e);
    }
  }

  /// Get tasks by category
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.tasksTable,
        where: '${AppConstants.columnCategory} = ?',
        whereArgs: [category],
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get tasks by category', originalError: e);
    }
  }

  /// Update a task
  Future<int> updateTask(TaskModel task) async {
    try {
      if (task.id == null) {
        throw DatabaseException('Cannot update task without ID');
      }
      final db = await database;
      return await db.update(
        AppConstants.tasksTable,
        task.toMap(),
        where: '${AppConstants.columnId} = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      throw DatabaseException('Failed to update task', originalError: e);
    }
  }

  /// Delete a task
  Future<int> deleteTask(int id) async {
    try {
      final db = await database;
      return await db.delete(
        AppConstants.tasksTable,
        where: '${AppConstants.columnId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete task', originalError: e);
    }
  }

  /// Get completed tasks
  Future<List<TaskModel>> getCompletedTasks() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.tasksTable,
        where: '${AppConstants.columnIsCompleted} = ?',
        whereArgs: [1],
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get completed tasks', originalError: e);
    }
  }

  /// Get pending tasks
  Future<List<TaskModel>> getPendingTasks() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.tasksTable,
        where: '${AppConstants.columnIsCompleted} = ?',
        whereArgs: [0],
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get pending tasks', originalError: e);
    }
  }

  /// Get tasks by date
  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    try {
      final db = await database;
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.tasksTable,
        where: '${AppConstants.columnDueDate} = ?',
        whereArgs: [dateString],
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get tasks by date', originalError: e);
    }
  }

  /// Search tasks by title or description
  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.tasksTable,
        where: '${AppConstants.columnTitle} LIKE ? OR ${AppConstants.columnDescription} LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to search tasks', originalError: e);
    }
  }

  /// Close database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
