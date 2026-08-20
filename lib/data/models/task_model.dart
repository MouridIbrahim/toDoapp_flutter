import 'package:mytodoapp/domain/entities/task_entity.dart';

/// Data model for Task - used for data layer operations
class TaskModel extends TaskEntity {
  const TaskModel({
    super.id,
    required super.title,
    required super.description,
    super.dueDate,
    required super.category,
    super.isCompleted = false,
  });

  /// Create TaskModel from Map (database row)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      dueDate: map['dueDate'] != null 
          ? DateTime.parse(map['dueDate'] as String) 
          : null,
      category: map['category'] as String? ?? 'None',
      isCompleted: (map['isCompleted'] as int?) == 1,
    );
  }

  /// Convert TaskModel to Map for database operations
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'dueDate': formattedDueDate,
      'category': category,
      'isCompleted': isCompleted ? 1 : 0,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Create TaskModel from TaskEntity
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      category: entity.category,
      isCompleted: entity.isCompleted,
    );
  }

  @override
  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? category,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
