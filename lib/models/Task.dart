class Task {
  final int? id;
  final String title;
  final String description;
  final String? dueDate;
  final String category;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.dueDate,
    required this.category,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'category': category,
      'isCompleted': isCompleted ? 1 : 0,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Add this method exactly as is:
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      category: map['category'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

   Task copyWith({
    int? id,
    String? title,
    String? description,
    String? dueDate,
    String? category,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
