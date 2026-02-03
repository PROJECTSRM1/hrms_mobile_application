class LeaveBalanceResponse {
  final int empId;
  final int year;
  final List<LeaveBalance> leaves;

  LeaveBalanceResponse({
    required this.empId,
    required this.year,
    required this.leaves,
  });

  factory LeaveBalanceResponse.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceResponse(
      empId: (json['emp_id'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      leaves: (json['leaves'] as List)
          .map((e) => LeaveBalance.fromJson(e))
          .toList(),
    );
  }
}

class LeaveBalance {
  final int leaveTypeId;
  final String leaveType;
  final int granted;
  final int consumed;
  final int balance;

  LeaveBalance({
    required this.leaveTypeId,
    required this.leaveType,
    required this.granted,
    required this.consumed,
    required this.balance,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      leaveTypeId: (json['leave_type_id'] as num).toInt(),
      leaveType: json['leave_type'] ?? '',
      granted: (json['granted'] as num).toInt(),
      consumed: (json['consumed'] as num).toInt(),
      balance: (json['balance'] as num).toInt(),
    );
  }
}
