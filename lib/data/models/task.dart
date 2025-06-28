class Task {
  String id;
  String title;
  String? description;
  DateTime dueDate;
  int priority;
  DateTime updatedAt;
  bool isDirty;
  bool isSynced;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.updatedAt,
    this.isDirty = true,
    this.isSynced = false,
  });

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    dueDate: DateTime.parse(map['dueDate']),
    priority: map['priority'],
    updatedAt: DateTime.parse(map['updatedAt']),
    isDirty: map['isDirty'] == 0,
    isSynced: map['isSynced'] == 0,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate.toIso8601String(),
    'priority': priority,
    'updatedAt': updatedAt.toIso8601String(),
    'isDirty': isDirty ? 0 : 1,
    'isSynced': isSynced ? 0 : 1,
  };

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    int? priority,
    DateTime? updatedAt,
    bool? isDirty,
    bool? isSynced,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      updatedAt: updatedAt ?? this.updatedAt,
      isDirty: isDirty ?? this.isDirty,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
