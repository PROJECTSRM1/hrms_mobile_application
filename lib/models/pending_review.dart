class PendingReview {
  final int empId;
  final String employeeName;

  PendingReview({
    required this.empId,
    required this.employeeName,
  });

  factory PendingReview.fromJson(Map<String, dynamic> json) {
    return PendingReview(
      empId: json['employee_id'],
      employeeName: json['employee_name'] ?? '',
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'emp_id': empId,
  //     'employee_name': employeeName,
  //   };
  // }
}