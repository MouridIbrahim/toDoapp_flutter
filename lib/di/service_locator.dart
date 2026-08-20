import 'package:get_it/get_it.dart';
import 'package:mytodoapp/data/datasources/task_local_datasource.dart';
import 'package:mytodoapp/data/repositories/task_repository_impl.dart';
import 'package:mytodoapp/domain/repositories/task_repository_interface.dart';
import 'package:mytodoapp/domain/usecases/task_usecases.dart';
import 'package:mytodoapp/presentation/providers/task_provider.dart';
import 'package:mytodoapp/theme_provider.dart';

/// Service locator for dependency injection
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<TaskRepositoryInterface>(
    () => TaskRepository(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllTasksUseCase(sl()));
  sl.registerLazySingleton(() => InsertTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetTasksByCategoryUseCase(sl()));
  sl.registerLazySingleton(() => SearchTasksUseCase(sl()));
  sl.registerLazySingleton(() => GetTasksByDateUseCase(sl()));

  // Providers
  sl.registerFactory(() => TaskProvider(
        getAllTasksUseCase: sl(),
        insertTaskUseCase: sl(),
        updateTaskUseCase: sl(),
        deleteTaskUseCase: sl(),
        getTasksByCategoryUseCase: sl(),
        searchTasksUseCase: sl(),
        getTasksByDateUseCase: sl(),
      ));
  
  sl.registerFactory(() => ThemeProvider());
}
