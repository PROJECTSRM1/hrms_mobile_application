class TaskHistory {
  final int? historyId;
  final int? taskId;
  final String? title;
  final int? empId;
  final String? employeeName;
  final int? projectId;
  final String? projectName;
  final int? projectModuleId;
  final String? moduleName;
  final int? reportingManagerId;
  final String? reportingManagerName;
  final String? comments;
  final int? effortsInDays;
  final String? createdDate;
  final String? modifiedDate;

  TaskHistory({
    this.historyId,
    this.taskId,
    this.title,
    this.empId,
    this.employeeName,
    this.projectId,
    this.projectName,
    this.projectModuleId,
    this.moduleName,
    this.reportingManagerId,
    this.reportingManagerName,
    this.comments,
    this.effortsInDays,
    this.createdDate,
    this.modifiedDate,
  });

  factory TaskHistory.fromJson(Map<String, dynamic> json) {
    return TaskHistory(
      historyId: json['history_id'],
      taskId: json['task_id'],
      title: json['title'],
      empId: json['emp_id'],
      employeeName: json['employee_name'],
      projectId: json['project_id'],
      projectName: json['project_name'],
      projectModuleId: json['project_module_id'],
      moduleName: json['project_module'],
      reportingManagerId: json['reporting_manager_id'],
      reportingManagerName: json['reporting_manager_name'],
      comments: json['comments'],   // ✅ correct
      effortsInDays: json['efforts_in_days'],
      createdDate: json['created_date'],
      modifiedDate: json['modified_date'],
    );
  }
}
