import 'dart:convert';
import 'package:http/http.dart' as http;

class DesignationService {
  static const String _baseUrl =
      'https://hrms-be-ppze.onrender.com';

  /// GET ALL DESIGNATIONS
  static Future<List<dynamic>> fetchDesignations() async {
    final res = await http.get(
      Uri.parse('$_baseUrl/designations/'),
      headers: {'accept': 'application/json'},
    );

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Failed to load designations');
    }
  }
}
