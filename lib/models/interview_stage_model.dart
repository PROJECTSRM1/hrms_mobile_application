// class InterviewStage {
//   final int id;
//   final String stageName;
//   final bool isActive;

//   InterviewStage({
//     required this.id,
//     required this.stageName,
//     required this.isActive,
//   });

//   factory InterviewStage.fromJson(Map<String, dynamic> json) {
//     return InterviewStage(
//       id: json['id'],
//       stageName: json['stage_name'],
//       isActive: json['is_active'],
//     );
//   }
// }








// lib/models/interview_stage_model.dart

class InterviewStage {
  final int id;
  final String stageName;
  final bool isActive;

  InterviewStage({
    required this.id,
    required this.stageName,
    required this.isActive,
  });

  factory InterviewStage.fromJson(Map<String, dynamic> json) {
    return InterviewStage(
      id: json['id'] as int,
      stageName: json['stage_name'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stage_name': stageName,
      'is_active': isActive,
    };
  }
}

class CreateStageRequest {
  final String stageName;
  final bool isActive;

  CreateStageRequest({
    required this.stageName,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'stage_name': stageName,
      'is_active': isActive,
    };
  }
}

class UpdateStageRequest {
  final String stageName;
  final bool isActive;

  UpdateStageRequest({
    required this.stageName,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'stage_name': stageName,
      'is_active': isActive,
    };
  }
}

class UpdateStageStatusRequest {
  final bool isActive;

  UpdateStageStatusRequest({required this.isActive});

  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
    };
  }
}