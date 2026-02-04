class PerformanceRating {
  final int? id;
  final int empId;
  final String employeeName;
  final int designationId;
  final String designationName;
  final double rating;
  final int reviewerId;
  final String reviewerName;
  final String createdDate;
  final bool isActive;

  PerformanceRating({
    this.id,
    required this.empId,
    required this.employeeName,
    required this.designationId,
    required this.designationName,
    required this.rating,
    required this.reviewerId,
    required this.reviewerName,
    required this.createdDate,
    this.isActive = true,
  });

  factory PerformanceRating.fromJson(Map<String, dynamic> json) {
    return PerformanceRating(
      id: json['id'],
      empId: json['emp_id'],
      employeeName: json['employee_name'] ?? '',
      designationId: json['designation_id'],
      designationName: json['designation_name'] ?? '',
      rating: (json['rating'] is int) 
          ? (json['rating'] as int).toDouble() 
          : json['rating'].toDouble(),
      reviewerId: json['reviewer_id'],
      reviewerName: json['reviewer_name'] ?? '',
      createdDate: json['created_date'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'emp_id': empId,
      'designation_id': designationId,
      'rating': rating,
      'reviewer_id': reviewerId,
      'created_by': reviewerId,
      'created_date': DateTime.now().toIso8601String(),
      'is_active': isActive,
    };
  }

  PerformanceRating copyWith({
    int? id,
    int? empId,
    String? employeeName,
    int? designationId,
    String? designationName,
    double? rating,
    int? reviewerId,
    String? reviewerName,
    String? createdDate,
    bool? isActive,
  }) {
    return PerformanceRating(
      id: id ?? this.id,
      empId: empId ?? this.empId,
      employeeName: employeeName ?? this.employeeName,
      designationId: designationId ?? this.designationId,
      designationName: designationName ?? this.designationName,
      rating: rating ?? this.rating,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      createdDate: createdDate ?? this.createdDate,
      isActive: isActive ?? this.isActive,
    );
  }
}