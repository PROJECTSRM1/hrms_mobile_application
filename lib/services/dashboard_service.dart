import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_models.dart';

class DashboardService {
  static const String baseUrl = "https://hrms-be-ppze.onrender.com/";

  static Future<DashboardData?> getDashboardSummary() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/dashboard/summary"),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer YOUR_TOKEN", // if needed
        },
      );

      print("DASHBOARD STATUS: ${response.statusCode}");
      print("DASHBOARD BODY: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return DashboardData.fromJson(json);
      }
      return null;
    } catch (e) {
      print("DASHBOARD ERROR: $e");
      return null;
    }
  }

  static Future<List<Activity>> getRecentActivities() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/dashboard/recent-activities"),
      );

      print("ACTIVITY STATUS: ${response.statusCode}");
      print("ACTIVITY BODY: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return (json['activities'] as List)
            .map((e) => Activity.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print("ACTIVITY ERROR: $e");
      return [];
    }
  }
}
