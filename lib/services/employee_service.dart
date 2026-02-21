import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee_model.dart';
import 'package:flutter/foundation.dart';

class EmployeeService {
  static const String _baseUrl =
      'https://hrms-be-ppze.onrender.com';

  /// ================= FETCH ALL EMPLOYEES =================
  static Future<List<Employee>> fetchEmployees() async {
    final res = await http.get(
      Uri.parse('$_baseUrl/employees/'),
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

  // 🔥 ADD DEFAULTS HERE
  payload['status_id'] ??= 1;
  payload['blood_group_id'] ??= 1;
  payload['gender_id'] ??= 1;
  payload['marital_status_id'] ??= 1;
  payload['designation_id'] ??= 1;
  payload['department_id'] ??= 1;
  payload['employee_type_id'] ??= 1;
  // payload['manager_id'] ??= 1;
  payload['role_id'] ??= 1;
  payload['work_location_id'] ??= 1;
  payload['shift_id'] ??= 1;
  payload['bank_id'] ??= 1;
  // payload['created_by'] ??= 1;
  payload['salary'] ??= 0;
  payload['ctc'] ??= 0;
  payload['family_members'] ??= [];
  payload['upload_doc'] ??= "";

  payload.remove('created_by');


  final res = await http.post(
    Uri.parse('$_baseUrl/employees/employee'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(payload),
  );

  debugPrint("STATUS => ${res.statusCode}");
  debugPrint("BODY => ${res.body}");

  // return res.statusCode == 200 || res.statusCode == 201;
  if (res.statusCode == 200 || res.statusCode == 201) {
    return true;
  } 
  else {
  try {
    final body = jsonDecode(res.body);
    throw Exception(body["detail"] ?? "Failed to create employee");
  } catch (_) {
    throw Exception(res.body);
  }
}


}


  /// ================= UPDATE EMPLOYEE =================
static Future<void> updateEmployee(
  String employeeId,
  Map<String, dynamic> payload,
) async {

  payload["modified_by"] ??= 1; // 🔥 REQUIRED

  final res = await http.put(
    Uri.parse('$_baseUrl/employees/$employeeId'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(payload),
  );

  // if (res.statusCode != 200) {
  //   final body = jsonDecode(res.body);
  //   throw Exception(body["detail"]);
  // }
    if (res.statusCode != 200) {
    try {
      final body = jsonDecode(res.body);
      throw Exception(body["detail"] ?? "Update failed");
    } catch (_) {
      throw Exception(res.body);
    }
  }

}


}
