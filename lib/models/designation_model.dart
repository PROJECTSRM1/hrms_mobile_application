// lib/models/designation_model.dart

class Designation {
  final int id;
  final String designationName;
  final int deptId;
  final bool isActive;

  Designation({
    required this.id,
    required this.designationName,
    required this.deptId,
    required this.isActive,
  });

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(
      id: json['id'] as int,
      designationName: json['designation_name'] as String,
      deptId: json['dept_id'] as int,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation_name': designationName,
      'dept_id': deptId,
      'is_active': isActive,
    };
  }
}

class CreateDesignationRequest {
  final String designationName;
  final int deptId;

  CreateDesignationRequest({
    required this.designationName,
    required this.deptId,
  });

  Map<String, dynamic> toJson() {
    return {
      'designation_name': designationName,
      'dept_id': deptId,
    };
  }
}

class UpdateDesignationStatusRequest {
  final bool isActive;

  UpdateDesignationStatusRequest({required this.isActive});

  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
    };
  }
}