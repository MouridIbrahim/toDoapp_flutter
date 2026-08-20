import 'package:equatable/equatable.dart';

/// Domain entity representing a Task
class TaskEntity extends Equatable {
  final int? id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final String category;
  final bool isCompleted;

  const TaskEntity({
    this.id,
    required this.title,
    required this.description,
    this.dueDate,
    required this.category,
    this.isCompleted = false,
  });

  /// Get formatted due date string
  String? get formattedDueDate {
    if (dueDate == null) return null;
    return '${dueDate!.year}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}';
  }

  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return dueDate!.isBefore(todayDate);
  }

  /// Check if task is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return dueDate!.year == todayDate.year &&
        dueDate!.month == todayDate.month &&
        dueDate!.day == todayDate.day;
  }

  /// Check if task is due tomorrow
  bool get isDueTomorrow {
    if (dueDate == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    return dueDate!.year == tomorrowDate.year &&
        dueDate!.month == tomorrowDate.month &&
        dueDate!.day == tomorrowDate.day;
  }

  @override
  List<Object?> get props => [id, title, description, dueDate, category, isCompleted];

  /// Create a copy of this entity with updated fields
  TaskEntity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? category,
    bool? isCompleted,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
