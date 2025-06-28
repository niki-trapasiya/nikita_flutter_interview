class Todo {
  int? id;
  String? firebaseId;
  String title;
  String description;
  String priority;
  String date;
  String updatedAt;
  bool isDirty;

  Todo({
    this.id,
    this.firebaseId,
    required this.title,
    required this.description,
    required this.priority,
    required this.date,
    required this.updatedAt,
    this.isDirty = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firebaseId': firebaseId,
      'title': title,
      'description': description,
      'priority': priority,
      'date': date,
      'updatedAt': updatedAt,
      'isDirty': isDirty ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      firebaseId: map['firebaseId'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      date: map['date'],
      updatedAt: map['updatedAt'],
      isDirty: map['isDirty'] == 1,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'date': date,
      'updatedAt': updatedAt,
    };
  }

  static Todo fromFirestore(Map<String, dynamic> map, String firebaseId) {
    return Todo(
      firebaseId: firebaseId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: map['priority'] ?? 'Medium',
      date: map['date'] ?? '',
      updatedAt: map['updatedAt'] ?? DateTime.now().toIso8601String(),
      isDirty: false,
    );
  }
}
