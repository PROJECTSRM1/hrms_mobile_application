import 'dart:convert';
import 'package:http/http.dart' as http;

class MasterDataService {
  static const String _baseUrl =
      "https://hrms-be-ppze.onrender.com";

  /// ================= DEPARTMENTS =================
  static Future<List<Map<String, dynamic>>> getDepartments() async {
    final res =
        await http.get(Uri.parse("$_baseUrl/departments"));

    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(res.body));
    } else {
      throw Exception("Failed to load departments");
    }
  }

  /// ================= DESIGNATIONS =================
  static Future<List<Map<String, dynamic>>> getDesignations() async {
    final res =
        await http.get(Uri.parse("$_baseUrl/designations"));

    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(res.body));
    } else {
      throw Exception("Failed to load designations");
    }
  }

  /// ================= EMPLOYEES (MANAGERS) =================
  static Future<List<Map<String, dynamic>>> getManagers() async {
    final res =
        await http.get(Uri.parse("$_baseUrl/employees"));

    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(res.body));
    } else {
      throw Exception("Failed to load managers");
    }
  }
}
