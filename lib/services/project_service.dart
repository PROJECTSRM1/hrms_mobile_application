import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project_model.dart';

class ProjectService {
  static const String baseUrl =
      'https://hrms-be-ppze.onrender.com/projects';

  static Future<List<Project>> getProjects() async {
    final res = await http.get(Uri.parse('$baseUrl/'));
    final List data = jsonDecode(res.body);
    return data.map((e) => Project.fromJson(e)).toList();
  }

  static Future<void> createProject(String name) async {
    await http.post(
      Uri.parse('$baseUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'project_name': name}),
    );
  }

  static Future<void> updateStatus(int id, bool status) async {
    await http.put(
      Uri.parse('$baseUrl/$id/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'is_active': status}),
    );
  }
}
