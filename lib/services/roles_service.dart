import 'dart:convert';
import 'package:http/http.dart' as http;

class RolesService {
  static const String _baseUrl =
      'https://hrms-be-ppze.onrender.com/roles/';

  // GET roles
  static Future<List<dynamic>> fetchRoles() async {
    final res = await http.get(
      Uri.parse(_baseUrl),
      headers: {'accept': 'application/json'},
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to load roles');
    }
  }

  // POST create role
  static Future<void> createRole(String roleName) async {
    final res = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'role_name': roleName}),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create role');
    }
  }

  // PUT update role status
  static Future<void> updateRoleStatus(int id, bool isActive) async {
    final res = await http.put(
      Uri.parse('$_baseUrl$id'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'is_active': isActive}),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update role');
    }
  }
}
