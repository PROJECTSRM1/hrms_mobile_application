class CountModel {
  final int count;

  CountModel({required this.count});

  factory CountModel.fromJson(Map<String, dynamic> json) {
    return CountModel(
      count: json['count'] ?? 0,
    );
  }
}

class DashboardData {
  final CountModel totalEmployees;
  final CountModel activeEmployees;
  final CountModel inactiveEmployees;
  final CountModel uninformedLeaves;

  DashboardData({
    required this.totalEmployees,
    required this.activeEmployees,
    required this.inactiveEmployees,
    required this.uninformedLeaves,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalEmployees: CountModel.fromJson(json['total_employees']),
      activeEmployees: CountModel.fromJson(json['active_employees']),
      inactiveEmployees: CountModel.fromJson(json['inactive_employees']),
      uninformedLeaves: CountModel.fromJson(json['uninformed_leaves']),
    );
  }
}

class Activity {
  final String firstName;
  final String lastName;
  final String description;
  final String createdDate;

  Activity({
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.createdDate,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      firstName: json['employee_first_name'] ?? '',
      lastName: json['employee_last_name'] ?? '',
      description: json['activity_description'] ?? '',
      createdDate: json['created_date'] ?? '',
    );
  }
}
