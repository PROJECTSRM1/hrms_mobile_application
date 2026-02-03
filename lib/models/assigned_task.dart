class AssignedTask {
  final int? id;
  final String? employeeName;
  final String? projectName;
  final String? reportingManager;
  final String? taskTitle;
  final String? taskDescription;
  final int? effortsInDays;
  final String? taskStatus;
  final String? dueDate;
  final int? empId;
  final int? projectId;
  final int? reportingManagerId;
  final int? statusId;

  AssignedTask({
    this.id,
    this.employeeName,
    this.projectName,
    this.reportingManager,
    this.taskTitle,
    this.taskDescription,
    this.effortsInDays,
    this.taskStatus,
    this.dueDate,
    this.empId,
    this.projectId,
    this.reportingManagerId,
    this.statusId,
  });

  factory AssignedTask.fromJson(Map<String, dynamic> json) {
    return AssignedTask(
      id: json['id'],
      employeeName: json['employee_name'],
      projectName: json['project_name'],
      reportingManager: json['reporting_manager'],
      taskTitle: json['task_title'] ?? json['title'],
      taskDescription: json['task_description'] ?? json['description'],
      effortsInDays: json['efforts_in_days'],
      taskStatus: json['task_status'] ?? json['status'],
      dueDate: json['due_date'],
      empId: json['emp_id'],
      projectId: json['project_id'],
      reportingManagerId: json['reporting_manager_id'],
      statusId: json['status_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (employeeName != null) 'employee_name': employeeName,
      if (projectName != null) 'project_name': projectName,
      if (reportingManager != null) 'reporting_manager': reportingManager,
      if (taskTitle != null) 'title': taskTitle,
      if (taskDescription != null) 'description': taskDescription,
      if (effortsInDays != null) 'efforts_in_days': effortsInDays,
      if (taskStatus != null) 'status': taskStatus,
      if (dueDate != null) 'due_date': dueDate,
      if (empId != null) 'emp_id': empId,
      if (projectId != null) 'project_id': projectId,
      if (reportingManagerId != null) 'reporting_manager_id': reportingManagerId,
      if (statusId != null) 'status_id': statusId,
    };
  }
}