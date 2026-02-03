import 'dart:convert';
import 'package:http/http.dart' as http;

class DesignationService {
  static const String _baseUrl =
      'https://hrms-be-ppze.onrender.com';

  /// ================= GET ALL DESIGNATIONS =================
  static Future<List<dynamic>> fetchDesignations() async {
    final res = await http.get(
      Uri.parse('$_baseUrl/designations/'),
      headers: {'accept': 'application/json'},
    );

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Failed to load designations');
    }
  }

  /// ================= CREATE DESIGNATION =================
  static Future<void> createDesignation({
    required int deptId,
    required String name,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/designations/'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "designation_name": name,
        "dept_id": deptId,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create designation');
    }
  }

  /// ================= UPDATE DESIGNATION STATUS =================
  static Future<void> updateDesignationStatus(
    int designationId,
    bool isActive,
  ) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/designations/$designationId/status'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "is_active": isActive,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update designation status');
    }
  }
}
