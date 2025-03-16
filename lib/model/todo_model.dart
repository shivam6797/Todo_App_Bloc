class TodoModel {
  final int? id;
  final String title;
  final String? description;
  final String category;
  final bool? isCompleted;
  final int priority;
  final String? dueDate;
  final String createdAt;

  TodoModel({
    this.id,
    required this.title,
    this.description,
    required this.category,
    this.isCompleted = false,
    this.priority = 1,
    this.dueDate,
    required this.createdAt,
  });

  // Convert TodoModel object to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'isCompleted': isCompleted == true ? 1 : 0,
      'priority': priority,
      'dueDate': dueDate,
      'createdAt': createdAt,
    };
  }

  // Create a TodoModel object from Map (for reading from database)
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      isCompleted: map['isCompleted'] == 1,
      priority: map['priority'],
      dueDate: map['dueDate'],
      createdAt: map['createdAt'],
    );
  }

   // CopyWith Function (Update Data Easily)
  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
    int? priority,
    String? dueDate,
    String? createdAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
