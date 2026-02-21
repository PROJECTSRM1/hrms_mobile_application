// lib/models/interview_schedule_model.dart

class InterviewSchedule {
  final int id;
  final int candidateId;
  final int designationId;
  final int statusId;
  final int stageId;
  final DateTime interviewDate;
  final int? rating;
  final String? feedback;
  final bool isActive;
  final DateTime createdDate;

  InterviewSchedule({
    required this.id,
    required this.candidateId,
    required this.designationId,
    required this.statusId,
    required this.stageId,
    required this.interviewDate,
    this.rating,
    this.feedback,
    required this.isActive,
    required this.createdDate,
  });

  factory InterviewSchedule.fromJson(Map<String, dynamic> json) {
    return InterviewSchedule(
      id: json['id'] as int,
      candidateId: json['candidate_id'] as int,
      designationId: json['designation_id'] as int,
      statusId: json['status_id'] as int,
      stageId: json['stage_id'] as int,
      interviewDate: DateTime.parse(json['interview_date'] as String),
      rating: json['rating'] as int?,
      feedback: json['feedback'] as String?,
      isActive: json['is_active'] as bool,
      createdDate: DateTime.parse(json['created_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidate_id': candidateId,
      'designation_id': designationId,
      'status_id': statusId,
      'stage_id': stageId,
      'interview_date': interviewDate.toIso8601String().split('T')[0],
      'rating': rating,
      'feedback': feedback,
      'is_active': isActive,
      'created_date': createdDate.toIso8601String(),
    };
  }
}

class ScheduleInterviewRequest {
  final int candidateId;
  final int designationId;
  final int statusId;
  final int stageId;
  final String interviewDate;

  ScheduleInterviewRequest({
    required this.candidateId,
    required this.designationId,
    required this.statusId,
    required this.stageId,
    required this.interviewDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'candidate_id': candidateId,
      'designation_id': designationId,
      'status_id': statusId,
      'stage_id': stageId,
      'interview_date': interviewDate,
    };
  }
}

class UpdateInterviewScheduleRequest {
  final int candidateId;
  final int designationId;
  final int statusId;
  final int stageId;
  final String interviewDate;
  final int createdBy;
  final int? rating;
  final String? feedback;

  UpdateInterviewScheduleRequest({
    required this.candidateId,
    required this.designationId,
    required this.statusId,
    required this.stageId,
    required this.interviewDate,
    required this.createdBy,
    this.rating,
    this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'candidate_id': candidateId,
      'designation_id': designationId,
      'status_id': statusId,
      'stage_id': stageId,
      'interview_date': interviewDate,
      'created_by': createdBy,
      'rating': rating,
      'feedback': feedback,
    };
  }
}