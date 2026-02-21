// lib/models/department_model.dart

class Department {
  final int id;
  final String department;
  final bool isActive;

  Department({
    required this.id,
    required this.department,
    required this.isActive,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as int,
      department: json['department'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department': department,
      'is_active': isActive,
    };
  }
}

class CreateDepartmentRequest {
  final String department;

  CreateDepartmentRequest({required this.department});

  Map<String, dynamic> toJson() {
    return {
      'department': department,
    };
  }
}

class UpdateDepartmentStatusRequest {
  final bool isActive;

  UpdateDepartmentStatusRequest({required this.isActive});

  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
    };
  }
}