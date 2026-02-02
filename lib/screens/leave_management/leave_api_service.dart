import 'dart:convert';
import 'package:http/http.dart' as http;

class LeaveApiService {
  static const String baseUrl = "https://hrms-be-ppze.onrender.com";

  /// APPLY LEAVE
  static Future<bool> applyLeave({
    required int empId,
    required int leaveTypeId,
    required String startDate,
    required String endDate,
    required String reason,
    required String mobile,
    required int reportingManagerId,
    String? cc,
  }) async {
    final uri = Uri.parse("$baseUrl/leave/apply");

    final request = http.MultipartRequest("POST", uri)
      ..fields['emp_id'] = empId.toString()
      ..fields['leavetype_id'] = leaveTypeId.toString()
      ..fields['start_date'] = startDate
      ..fields['end_date'] = endDate
      ..fields['reason'] = reason
      ..fields['mobile'] = mobile
      ..fields['reporting_manager_id'] = reportingManagerId.toString()
      ..fields['cc'] = cc ?? "";

    final response = await request.send();
    return response.statusCode == 200;
  }

  /// PENDING LEAVES
  static Future<List<dynamic>> getPendingLeaves(int empId) async {
    final uri = Uri.parse(
      "$baseUrl/leave/pending/$empId?limit=10&offset=0",
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  /// LEAVE HISTORY
  static Future<List<dynamic>> getLeaveHistory(int empId) async {
    final uri = Uri.parse(
      "$baseUrl/leave/history/$empId?limit=10&offset=0",
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
}
