class TaskType {
  final int id;
  final String name;
  final bool? isActive;

  TaskType({
    required this.id,
    required this.name,
    this.isActive,
  });

  factory TaskType.fromJson(Map<String, dynamic> json) {
    return TaskType(
      id: json['id'],
      name: json['name'] ?? json['task_type'] ?? '',
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (isActive != null) 'is_active': isActive,
    };
  }
}