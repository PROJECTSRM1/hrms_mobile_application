import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hrms_mobile_application/models/performance_rating.dart';
import 'package:hrms_mobile_application/models/top_performer.dart';
import 'package:hrms_mobile_application/models/pending_review.dart';
import 'package:hrms_mobile_application/models/average_rating.dart';
import 'package:hrms_mobile_application/models/performance_dashboard.dart';

class PerformanceService {
  // Update this with your actual API base URL
  static const String baseUrl = 'https://hrms-be-ppze.onrender.com';

  
  // Headers for API requests
  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      // Add authorization token if needed
      // 'Authorization': 'Bearer YOUR_TOKEN',
    };
  }

  // Get all performance ratings
  Future<List<PerformanceRating>> getAllPerformanceRatings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/performance-ratings/'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PerformanceRating.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load performance ratings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching performance ratings: $e');
    }
  }

  // Create a new performance rating
  Future<PerformanceRating> createPerformanceRating(
      PerformanceRating rating) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/employee-rating/'),
        headers: _getHeaders(),
        body: json.encode(rating.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return PerformanceRating.fromJson(data);
      } else {
        throw Exception('Failed to create performance rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating performance rating: $e');
    }
  }

  // Get top performers (rating >= 4.5)
  Future<List<TopPerformer>> getTopPerformers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/top-performers/'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TopPerformer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top performers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching top performers: $e');
    }
  }

  // Get average rating
  Future<AverageRating> getAverageRating() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/average-rating/'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AverageRating.fromJson(data);
      } else {
        throw Exception('Failed to load average rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching average rating: $e');
    }
  }

  // Get pending reviews
Future<List<PendingReview>> getPendingReviews() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/pending-reviews/'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // ✅ get employees list inside object
      final List<dynamic> employees = decoded['employees'] ?? [];

      return employees
          .map((json) => PendingReview.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load pending reviews: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching pending reviews: $e');
  }
}



  // Get dashboard data (combined data from multiple endpoints)
  Future<PerformanceDashboard> getDashboardData() async {
    try {
      // Fetch all data concurrently
      final results = await Future.wait([
        getTopPerformers(),
        getAverageRating(),
        getPendingReviews(),
      ]);

      final topPerformers = results[0] as List<TopPerformer>;
      final averageRating = results[1] as AverageRating;
      final pendingReviews = results[2] as List<PendingReview>;

      return PerformanceDashboard(
        topPerformersCount: topPerformers.length,
        averageRating: averageRating,
        pendingReviewsCount: pendingReviews.length,
        topPerformers: topPerformers,
        pendingReviews: pendingReviews,
      );
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
  }

  // Update a performance rating
  Future<PerformanceRating> updatePerformanceRating(
      int id, PerformanceRating rating) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/employee-rating/$id/'),
        headers: _getHeaders(),
        body: json.encode(rating.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PerformanceRating.fromJson(data);
      } else {
        throw Exception('Failed to update performance rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating performance rating: $e');
    }
  }

  // Delete a performance rating
  Future<void> deletePerformanceRating(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/employee-rating/$id/'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete performance rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting performance rating: $e');
    }
  }
}
