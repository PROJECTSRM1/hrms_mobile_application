import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/leave_balance_model.dart';

class LeaveBalanceService {
  static Future<LeaveBalanceResponse> fetchLeaveBalance({
    required int empId,
    required int year,
  }) async {
    final uri = Uri.parse(
      'https://hrms-be-ppze.onrender.com/leave/balance'
      '?emp_id=$empId&year=$year&limit=50&offset=0',
    );

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        // 'Authorization': 'Bearer YOUR_TOKEN'
      },
    );

    if (response.statusCode == 200) {
      return LeaveBalanceResponse.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Failed to load leave balance');
    }
  }
}
