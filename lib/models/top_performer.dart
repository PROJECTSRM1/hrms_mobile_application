class TopPerformer {
  final int empId;
  final int designationId;
  final double rating;
  final String createdDate;

  TopPerformer({
    required this.empId,
    required this.designationId,
    required this.rating,
    required this.createdDate,
  });

  factory TopPerformer.fromJson(Map<String, dynamic> json) {
    return TopPerformer(
      empId: json['emp_id'],
      designationId: json['designation_id'],
      rating: (json['rating'] is int) 
          ? (json['rating'] as int).toDouble() 
          : json['rating'].toDouble(),
      createdDate: json['created_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emp_id': empId,
      'designation_id': designationId,
      'rating': rating,
      'created_date': createdDate,
    };
  }
}