import 'package:mytodoapp/domain/entities/task_entity.dart';
import 'package:mytodoapp/domain/repositories/task_repository_interface.dart';

/// Use case for getting all tasks
class GetAllTasksUseCase {
  final TaskRepositoryInterface repository;

  GetAllTasksUseCase(this.repository);

  Future<List<TaskEntity>> execute() async {
    return await repository.getAllTasks();
  }
}

/// Use case for inserting a task
class InsertTaskUseCase {
  final TaskRepositoryInterface repository;

  InsertTaskUseCase(this.repository);

  Future<int> execute(TaskEntity task) async {
    return await repository.insertTask(task);
  }
}

/// Use case for updating a task
class UpdateTaskUseCase {
  final TaskRepositoryInterface repository;

  UpdateTaskUseCase(this.repository);

  Future<int> execute(TaskEntity task) async {
    return await repository.updateTask(task);
  }
}

/// Use case for deleting a task
class DeleteTaskUseCase {
  final TaskRepositoryInterface repository;

  DeleteTaskUseCase(this.repository);

  Future<int> execute(int id) async {
    return await repository.deleteTask(id);
  }
}

/// Use case for getting tasks by category
class GetTasksByCategoryUseCase {
  final TaskRepositoryInterface repository;

  GetTasksByCategoryUseCase(this.repository);

  Future<List<TaskEntity>> execute(String category) async {
    return await repository.getTasksByCategory(category);
  }
}

/// Use case for searching tasks
class SearchTasksUseCase {
  final TaskRepositoryInterface repository;

  SearchTasksUseCase(this.repository);

  Future<List<TaskEntity>> execute(String query) async {
    return await repository.searchTasks(query);
  }
}

/// Use case for getting tasks by date
class GetTasksByDateUseCase {
  final TaskRepositoryInterface repository;

  GetTasksByDateUseCase(this.repository);

  Future<List<TaskEntity>> execute(DateTime date) async {
    return await repository.getTasksByDate(date);
  }
}
