import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee_model.dart';

class EmployeeService {
  static const String _baseUrl =
      'https://hrms-be-ppze.onrender.com';

  /// ================= FETCH ALL EMPLOYEES =================
  static Future<List<Employee>> fetchEmployees() async {
    final res = await http.get(
      Uri.parse('$_baseUrl/employees'),
    );

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  /// ================= FETCH EMPLOYEE BY ID =================
  static Future<Map<String, dynamic>> fetchEmployeeById(
    String employeeId,
  ) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/employees/$employeeId'),
    );

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Employee not found');
    }
  }

  /// ================= CREATE EMPLOYEE =================
  static Future<bool> createEmployee(
    Map<String, dynamic> payload,
  ) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/employees'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      throw Exception(
        'Failed to create employee: ${res.body}',
      );
    }
  }
}
