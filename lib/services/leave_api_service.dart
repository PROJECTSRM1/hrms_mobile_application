import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeaveApiService {
  static const String _baseUrl = 'https://hrms-be-ppze.onrender.com';

  /* ================= PREFS ================= */

  static Future<SharedPreferences> _prefs() async {
    return SharedPreferences.getInstance();
  }

  static Future<String?> _getToken() async {
    final prefs = await _prefs();
    return prefs.getString('auth_token');
  }

  static Future<int?> _getEmpId() async {
    final prefs = await _prefs();
    return prefs.getInt('emp_id');
  }

  /* ================= APPLY LEAVE ================= */

  static Future<bool> applyLeave({
    required int leaveTypeId,
    required String startDate,
    required String endDate,
    required String fromSession,
    required String toSession,
    required String reason,
    required String mobile,
    required int reportingManagerId,
    File? file,
  }) async {
    final empId = await _getEmpId();
    final token = await _getToken();

    if (empId == null || token == null) return false;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/leave/apply'),
    );

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields.addAll({
      'emp_id': empId.toString(),
      'leavetype_id': leaveTypeId.toString(),
      'start_date': startDate,
      'end_date': endDate,
      'from_date_session_id': fromSession,
      'to_date_session_id': toSession,
      'reason': reason,
      'mobile': mobile,
      'reporting_manager_id': empId.toString(),
    });

    if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath('upload_file', file.path),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    debugPrint("LEAVE APPLY STATUS: ${response.statusCode}");
    debugPrint("LEAVE APPLY BODY: $body");

    return response.statusCode == 200 || response.statusCode == 201;
  }

  /* ================= PENDING LEAVES ================= */

  static Future<List<dynamic>> getPendingLeaves({
    int limit = 10,
    int offset = 0,
  }) async {
    final empId = await _getEmpId();
    final token = await _getToken();

    if (empId == null || token == null) return [];

    final url =
        '$_baseUrl/leave/pending/$empId?limit=$limit&offset=$offset';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }
}
