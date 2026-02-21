// lib/models/candidate_model.dart

class Candidate {
  final int id;
  final String candidateName;
  final int designationId;
  final DateTime dob;
  final String email;
  final String mobile;
  final String address;
  final int applicationStatusId;
  final String uploadResume;
  final bool isActive;
  final DateTime createdDate;

  Candidate({
    required this.id,
    required this.candidateName,
    required this.designationId,
    required this.dob,
    required this.email,
    required this.mobile,
    required this.address,
    required this.applicationStatusId,
    required this.uploadResume,
    required this.isActive,
    required this.createdDate,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'] as int,
      candidateName: json['candidate_name'] as String,
      designationId: json['designation_id'] as int,
      dob: DateTime.parse(json['dob'] as String),
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      address: json['address'] as String,
      applicationStatusId: json['application_status_id'] as int,
      uploadResume: json['upload_resume'] as String,
      isActive: json['is_active'] as bool,
      createdDate: DateTime.parse(json['created_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidate_name': candidateName,
      'designation_id': designationId,
      'dob': dob.toIso8601String().split('T')[0],
      'email': email,
      'mobile': mobile,
      'address': address,
      'application_status_id': applicationStatusId,
      'upload_resume': uploadResume,
      'is_active': isActive,
      'created_date': createdDate.toIso8601String(),
    };
  }
}

class CreateCandidateRequest {
  final String candidateName;
  final int designationId;
  final String dob;
  final String email;
  final String mobile;
  final String address;
  final int applicationStatusId;
  final String uploadResume;

  CreateCandidateRequest({
    required this.candidateName,
    required this.designationId,
    required this.dob,
    required this.email,
    required this.mobile,
    required this.address,
    required this.applicationStatusId,
    required this.uploadResume,
  });

  Map<String, dynamic> toJson() {
    return {
      'candidate_name': candidateName,
      'designation_id': designationId,
      'dob': dob,
      'email': email,
      'mobile': mobile,
      'address': address,
      'application_status_id': applicationStatusId,
      'upload_resume': uploadResume,
    };
  }
}

class UpdateCandidateRequest {
  final String candidateName;
  final int designationId;
  final String dob;
  final String email;
  final String mobile;
  final String address;
  final int applicationStatusId;
  final String uploadResume;

  UpdateCandidateRequest({
    required this.candidateName,
    required this.designationId,
    required this.dob,
    required this.email,
    required this.mobile,
    required this.address,
    required this.applicationStatusId,
    required this.uploadResume,
  });

  Map<String, dynamic> toJson() {
    return {
      'candidate_name': candidateName,
      'designation_id': designationId,
      'dob': dob,
      'email': email,
      'mobile': mobile,
      'address': address,
      'application_status_id': applicationStatusId,
      'upload_resume': uploadResume,
    };
  }
}