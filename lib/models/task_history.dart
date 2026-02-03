// class TaskHistory {
//   final int? historyId;
//   final int? taskId;
//   final String? title;
//   final int? empId;
//   final String? employeeName;
//   final int? projectId;
//   final String? projectName;
//   final int? projectModuleId;
//   final String? projectModule;
//   final int? fromAssigneeId;
//   final int? toAssigneeId;
//   final int? reportingManagerId;
//   final String? reportingManagerName;
//   final String? comments;
//   final int? rating;
//   final int? effortsInDays;
//   final String? createdDate;
//   final String? modifiedDate;

//   TaskHistory({
//     this.historyId,
//     this.taskId,
//     this.title,
//     this.empId,
//     this.employeeName,
//     this.projectId,
//     this.projectName,
//     this.projectModuleId,
//     this.projectModule,
//     this.fromAssigneeId,
//     this.toAssigneeId,
//     this.reportingManagerId,
//     this.reportingManagerName,
//     this.comments,
//     this.rating,
//     this.effortsInDays,
//     this.createdDate,
//     this.modifiedDate,
//   });

//   factory TaskHistory.fromJson(Map<String, dynamic> json) {
//     return TaskHistory(
//       historyId: json['history_id'],
//       taskId: json['task_id'],
//       title: json['title'],
//       empId: json['emp_id'],
//       employeeName: json['employee_name'],
//       projectId: json['project_id'],
//       projectName: json['project_name'],
//       projectModuleId: json['project_module_id'],
//       projectModule: json['project_module'],
//       fromAssigneeId: json['from_assignee_id'],
//       toAssigneeId: json['to_assignee_id'],
//       reportingManagerId: json['reporting_manager_id'],
//       reportingManagerName: json['reporting_manager_name'],
//       comments: json['comments'],
//       rating: json['rating'],
//       effortsInDays: json['efforts_in_days'],
//       createdDate: json['created_date'],
//       modifiedDate: json['modified_date'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'history_id': historyId,
//       'task_id': taskId,
//       'title': title,
//       'emp_id': empId,
//       'employee_name': employeeName,
//       'project_id': projectId,
//       'project_name': projectName,
//       'project_module_id': projectModuleId,
//       'project_module': projectModule,
//       'from_assignee_id': fromAssigneeId,
//       'to_assignee_id': toAssigneeId,
//       'reporting_manager_id': reportingManagerId,
//       'reporting_manager_name': reportingManagerName,
//       'comments': comments,
//       'rating': rating,
//       'efforts_in_days': effortsInDays,
//       'created_date': createdDate,
//       'modified_date': modifiedDate,
//     };
//   }
// }








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
  final String? description;
  final int? statusId;
  final String? statusName;
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
    this.description,
    this.statusId,
    this.statusName,
    this.effortsInDays,
    this.createdDate,
    this.modifiedDate,
  });

  factory TaskHistory.fromJson(Map<String, dynamic> json) {
    return TaskHistory(
      historyId: json['history_id'] ?? json['id'],
      taskId: json['task_id'],
      title: json['title'],
      empId: json['emp_id'],
      employeeName: json['employee_name'],
      projectId: json['project_id'],
      projectName: json['project_name'],
      projectModuleId: json['project_module_id'],
      moduleName: json['module_name'] ?? json['project_module'],
      reportingManagerId: json['reporting_manager_id'],
      reportingManagerName: json['reporting_manager_name'],
      description: json['description'],
      statusId: json['status_id'],
      statusName: json['status_name'],
      effortsInDays: json['efforts_in_days'],
      createdDate: json['created_date'],
      modifiedDate: json['modified_date'],
    );
  }
}