// lib/models/job_opening_model.dart

class JobOpening {
  final int id;
  final int designationId;
  final int departmentId;
  final int statusId;
  final bool isActive;

  JobOpening({
    required this.id,
    required this.designationId,
    required this.departmentId,
    required this.statusId,
    required this.isActive,
  });

  factory JobOpening.fromJson(Map<String, dynamic> json) {
    return JobOpening(
      id: json['id'] as int,
      designationId: json['designation_id'] as int,
      departmentId: json['department_id'] as int,
      statusId: json['status_id'] as int,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation_id': designationId,
      'department_id': departmentId,
      'status_id': statusId,
      'is_active': isActive,
    };
  }
}

class CreateJobOpeningRequest {
  final int designationId;
  final int departmentId;
  final int statusId;

  CreateJobOpeningRequest({
    required this.designationId,
    required this.departmentId,
    required this.statusId,
  });

  Map<String, dynamic> toJson() {
    return {
      'designation_id': designationId,
      'department_id': departmentId,
      'status_id': statusId,
    };
  }
}

class UpdateJobOpeningRequest {
  final int designationId;
  final int departmentId;
  final int statusId;
  final bool isActive;

  UpdateJobOpeningRequest({
    required this.designationId,
    required this.departmentId,
    required this.statusId,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'designation_id': designationId,
      'department_id': departmentId,
      'status_id': statusId,
      'is_active': isActive,
    };
  }
}

class UpdateJobOpeningStatusRequest {
  final bool isActive;

  UpdateJobOpeningStatusRequest({required this.isActive});

  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
    };
  }
}