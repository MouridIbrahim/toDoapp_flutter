/// App-wide constants
class AppConstants {
  AppConstants._();

  // Database
  static const String databaseName = 'tasks.db';
  static const int databaseVersion = 1;

  // Table names
  static const String tasksTable = 'tasks';

  // Column names
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnDueDate = 'dueDate';
  static const String columnCategory = 'category';
  static const String columnIsCompleted = 'isCompleted';

  // Categories
  static const String categoryWork = 'Work';
  static const String categoryPersonal = 'Personal';
  static const String categoryNone = 'None';

  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String displayDateFormat = 'dd/MM/yyyy';

  // Validation
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int minTitleLength = 1;
}
