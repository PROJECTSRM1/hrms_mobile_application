class Project {
  final int id;
  final String projectName;
  final bool isActive;

  Project({
    required this.id,
    required this.projectName,
    required this.isActive,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      projectName: json['project_name'],
      isActive: json['is_active'],
    );
  }
}
