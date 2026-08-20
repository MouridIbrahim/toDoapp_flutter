import 'package:flutter/foundation.dart';
import 'package:mytodoapp/domain/entities/task_entity.dart';
import 'package:mytodoapp/domain/usecases/task_usecases.dart';
import 'package:mytodoapp/core/error_handling/exceptions.dart';

/// Task state for the presentation layer
class TaskState {
  final List<TaskEntity> tasks;
  final List<TaskEntity> workTasks;
  final List<TaskEntity> personalTasks;
  final bool isLoading;
  final String? errorMessage;

  const TaskState({
    this.tasks = const [],
    this.workTasks = const [],
    this.personalTasks = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  TaskState copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? workTasks,
    List<TaskEntity>? personalTasks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      workTasks: workTasks ?? this.workTasks,
      personalTasks: personalTasks ?? this.personalTasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Filter tasks by category
  void categorizeTasks() {
    workTasks = tasks.where((task) => task.category == 'Work').toList();
    personalTasks = tasks.where((task) => task.category == 'Personal').toList();
  }
}

/// Task provider for state management using Provider pattern
class TaskProvider with ChangeNotifier {
  final GetAllTasksUseCase getAllTasksUseCase;
  final InsertTaskUseCase insertTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetTasksByCategoryUseCase getTasksByCategoryUseCase;
  final SearchTasksUseCase searchTasksUseCase;
  final GetTasksByDateUseCase getTasksByDateUseCase;

  TaskState _state = const TaskState();

  TaskProvider({
    required this.getAllTasksUseCase,
    required this.insertTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.getTasksByCategoryUseCase,
    required this.searchTasksUseCase,
    required this.getTasksByDateUseCase,
  });

  TaskState get state => _state;
  List<TaskEntity> get tasks => _state.tasks;
  List<TaskEntity> get workTasks => _state.workTasks;
  List<TaskEntity> get personalTasks => _state.personalTasks;
  bool get isLoading => _state.isLoading;
  String? get errorMessage => _state.errorMessage;

  /// Load all tasks and categorize them
  Future<void> loadTasks() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final allTasks = await getAllTasksUseCase.execute();
      
      final workTasks = allTasks.where((task) => task.category == 'Work').toList();
      final personalTasks = allTasks.where((task) => task.category == 'Personal').toList();

      _state = _state.copyWith(
        tasks: allTasks,
        workTasks: workTasks,
        personalTasks: personalTasks,
        isLoading: false,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: e is AppException ? e.message : 'Failed to load tasks',
      );
      notifyListeners();
      rethrow;
    }
  }

  /// Add a new task
  Future<int?> addTask(TaskEntity task) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final id = await insertTaskUseCase.execute(task);
      await loadTasks(); // Reload tasks after insertion
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      return id;
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: e is AppException ? e.message : 'Failed to add task',
      );
      notifyListeners();
      rethrow;
    }
  }

  /// Update an existing task
  Future<bool> updateTask(TaskEntity task) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      await updateTaskUseCase.execute(task);
      await loadTasks(); // Reload tasks after update
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: e is AppException ? e.message : 'Failed to update task',
      );
      notifyListeners();
      return false;
    }
  }

  /// Delete a task
  Future<bool> deleteTask(int id) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      await deleteTaskUseCase.execute(id);
      await loadTasks(); // Reload tasks after deletion
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: e is AppException ? e.message : 'Failed to delete task',
      );
      notifyListeners();
      return false;
    }
  }

  /// Toggle task completion status
  Future<bool> toggleTaskCompletion(TaskEntity task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    return await updateTask(updatedTask);
  }

  /// Search tasks
  Future<List<TaskEntity>> searchTasks(String query) async {
    try {
      return await searchTasksUseCase.execute(query);
    } catch (e) {
      if (kDebugMode) {
        print('Search failed: $e');
      }
      return [];
    }
  }

  /// Get tasks by date
  Future<List<TaskEntity>> getTasksByDate(DateTime date) async {
    try {
      return await getTasksByDateUseCase.execute(date);
    } catch (e) {
      if (kDebugMode) {
        print('Get tasks by date failed: $e');
      }
      return [];
    }
  }

  /// Clear error message
  void clearError() {
    _state = _state.copyWith(errorMessage: null);
    notifyListeners();
  }
}
