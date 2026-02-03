import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/holiday_model.dart';

class HolidayService {
  static Future<List<Holiday>> fetchHolidays() async {
    final response = await http.get(
      Uri.parse('https://hrms-be-ppze.onrender.com/holidays/'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Holiday.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load holidays');
    }
  }
}
