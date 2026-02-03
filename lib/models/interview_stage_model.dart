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
      id: json['id'],
      stageName: json['stage_name'],
      isActive: json['is_active'],
    );
  }
}
