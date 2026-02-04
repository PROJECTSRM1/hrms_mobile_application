import 'package:hrms_mobile_application/models/average_rating.dart';
import 'package:hrms_mobile_application/models/top_performer.dart';
import 'package:hrms_mobile_application/models/pending_review.dart';

class PerformanceDashboard {
  final int topPerformersCount;
  final AverageRating averageRating;
  final int pendingReviewsCount;
  final List<TopPerformer> topPerformers;
  final List<PendingReview> pendingReviews;

  PerformanceDashboard({
    required this.topPerformersCount,
    required this.averageRating,
    required this.pendingReviewsCount,
    required this.topPerformers,
    required this.pendingReviews,
  });

  factory PerformanceDashboard.empty() {
    return PerformanceDashboard(
      topPerformersCount: 0,
      averageRating: AverageRating(
        totalRatings: 0,
        sumOfRatings: 0.0,
        averageRating: 0.0,
        message: '',
      ),
      pendingReviewsCount: 0,
      topPerformers: [],
      pendingReviews: [],
    );
  }
}