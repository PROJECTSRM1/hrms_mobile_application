import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/dashboard_models.dart';

class DashboardService {
  static const String baseUrl = "https://hrms-be-ppze.onrender.com";

  static Future<DashboardData?> getDashboardSummary() async {
    final token = await AuthService.getToken();

    if (token == null) return null;

    final response = await http.get(
      Uri.parse("$baseUrl/dashboard/summary"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return DashboardData.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  static Future<List<Activity>> getRecentActivities() async {
    final token = await AuthService.getToken();

    if (token == null) return [];

    final response = await http.get(
      Uri.parse("$baseUrl/dashboard/recent-activities"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json["activities"] as List)
          .map((e) => Activity.fromJson(e))
          .toList();
    }

    return [];
  }
}
