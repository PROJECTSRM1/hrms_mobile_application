import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payroll_model.dart';

class PayrollService {
  static const String baseUrl =
      "https://hrms-be-ppze.onrender.com";

  static Future<List<PayrollModel>> getPayroll({
    required int monthId,
    required int yearId,
  }) async {
    final uri = Uri.parse(
      "$baseUrl/payroll/calculate-all?month_id=$monthId&year_id=$yearId",
    );

    final response = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => PayrollModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch payroll data");
    }
  }
}
