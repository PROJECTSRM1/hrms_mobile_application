import 'dart:convert';
import 'package:http/http.dart' as http;

class InterviewStageService {
  static const String _baseUrl =
      "https://hrms-be-ppze.onrender.com/interview-stage/interview-stage";

  /// GET all interview stages
  static Future<List<dynamic>> fetchStages() async {
    final response = await http.get(Uri.parse("$_baseUrl/"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch interview stages");
    }
  }

  /// POST create new stage
  static Future<void> createStage(String stageName) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"stage_name": stageName}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create stage");
    }
  }

  /// PUT update stage status
  static Future<void> updateStageStatus(int stageId, bool isActive) async {
    final response = await http.put(
      Uri.parse("$_baseUrl/$stageId/status"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"is_active": isActive}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update stage status");
    }
  }
}
