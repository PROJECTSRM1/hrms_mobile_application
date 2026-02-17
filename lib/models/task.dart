class Task {
  final int? id;
  final String title;
  final String description;
  final int? taskTypeId;
  final int? projectId;
  final int? projectModuleId;
  final int? empId;
  final int? reportingManagerId;
  final int? taskManagerId;
  final int? statusId;
  final String? dueDate;
  final int? effortsInDays;
  final bool? isActive;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.taskTypeId,
    this.projectId,
    this.projectModuleId,
    this.empId,
    this.reportingManagerId,
    this.taskManagerId,
    this.statusId,
    this.dueDate,
    this.effortsInDays,
    this.isActive,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      taskTypeId: json['task_type_id'],
      projectId: json['project_id'],
      projectModuleId: json['project_module_id'],
      empId: json['emp_id'],
      reportingManagerId: json['reporting_manager_id'],
      taskManagerId: json['task_manager_id'],
      statusId: json['status_id'],
      dueDate: json['due_date'],
      effortsInDays: json['efforts_in_days'],
      isActive: json['is_active'],
    );
  }

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'title': title,
    'description': description,
    'task_type_id': taskTypeId,
    'project_id': projectId,
    'project_module_id': projectModuleId,
    'emp_id': empId,
    'reporting_manager_id': reportingManagerId,
    'task_manager_id': taskManagerId,
    'status_id': statusId,
    'due_date': dueDate,
    'efforts_in_days': effortsInDays,
    'is_active': isActive,
  };
}


  Task copyWith({
    int? id,
    String? title,
    String? description,
    int? taskTypeId,
    int? projectId,
    int? projectModuleId,
    int? empId,
    int? reportingManagerId,
    int? taskManagerId,
    int? statusId,
    String? dueDate,
    int? effortsInDays,
    bool? isActive,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      taskTypeId: taskTypeId ?? this.taskTypeId,
      projectId: projectId ?? this.projectId,
      projectModuleId: projectModuleId ?? this.projectModuleId,
      empId: empId ?? this.empId,
      reportingManagerId: reportingManagerId ?? this.reportingManagerId,
      taskManagerId: taskManagerId ?? this.taskManagerId,
      statusId: statusId ?? this.statusId,
      dueDate: dueDate ?? this.dueDate,
      effortsInDays: effortsInDays ?? this.effortsInDays,
      isActive: isActive ?? this.isActive,
    );
  }
}