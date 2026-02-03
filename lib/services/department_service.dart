import 'dart:convert';
import 'package:http/http.dart' as http;

class DepartmentService {
  static const String _baseUrl =
      'https://hrms-be-ppze.onrender.com';

  static const Map<String, String> _headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };

  /// GET ALL DEPARTMENTS
  static Future<List<dynamic>> fetchDepartments() async {
    final res = await http.get(
      Uri.parse('$_baseUrl/departments/'),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Failed to load departments');
    }
  }

  /// CREATE DEPARTMENT
  static Future<void> createDepartment({
    required String name,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/departments/'),
      headers: _headers,
      body: json.encode({
        "department": name,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create department');
    }
  }

  /// UPDATE STATUS (ACTIVE / INACTIVE)
  static Future<void> updateDepartmentStatus({
    required int deptId,
    required bool isActive,
  }) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/departments/$deptId/status'),
      headers: _headers,
      body: json.encode({
        "is_active": isActive,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update status');
    }
  }

  /// UPDATE DEPARTMENT NAME (EDIT)
  static Future<void> updateDepartment({
    required int deptId,
    required String name,
  }) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/departments/$deptId'),
      headers: _headers,
      body: json.encode({
        "department": name,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update department');
    }
  }
}
