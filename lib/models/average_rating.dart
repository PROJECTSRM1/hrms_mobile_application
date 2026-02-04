class AverageRating {
  final int totalRatings;
  final double sumOfRatings;
  final double averageRating;
  final String message;

  AverageRating({
    required this.totalRatings,
    required this.sumOfRatings,
    required this.averageRating,
    required this.message,
  });

  factory AverageRating.fromJson(Map<String, dynamic> json) {
    return AverageRating(
      totalRatings: json['total_ratings'] ?? 0,
      sumOfRatings: (json['sum_of_ratings'] is int)
          ? (json['sum_of_ratings'] as int).toDouble()
          : (json['sum_of_ratings'] ?? 0.0).toDouble(),
      averageRating: (json['average_rating'] is int)
          ? (json['average_rating'] as int).toDouble()
          : (json['average_rating'] ?? 0.0).toDouble(),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_ratings': totalRatings,
      'sum_of_ratings': sumOfRatings,
      'average_rating': averageRating,
      'message': message,
    };
  }
}