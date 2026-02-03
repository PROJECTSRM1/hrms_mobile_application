import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "https://hrms-be-ppze.onrender.com";

  /* ===================== TOKEN ===================== */

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /* ===================== HEADERS ===================== */

  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {
      "Content-Type": "application/json",
      "accept": "application/json",
    };

    if (auth) {
      final token = await getToken();
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return headers;
  }

  /* ===================== AUTH ===================== */

  /// POST /auth/login
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["token"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);

        return true;
      }

      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  /// PUT /auth/me
  static Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
  }) async {
    final res = await http.put(
      Uri.parse("$baseUrl/auth/me"),
      headers: await _headers(),
      body: jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "mobile": mobile,
      }),
    );

    return res.statusCode == 200;
  }

  /* ===================== CHANGE PASSWORD ===================== */

  /// PUT /auth/change-password
  static Future<bool> changePassword({
    required String current,
    required String newPass,
    required String confirm,
  }) async {
    final res = await http.put(
      Uri.parse("$baseUrl/auth/change-password"),
      headers: await _headers(),
      body: jsonEncode({
        "current_password": current,
        "new_password": newPass,
        "confirm_password": confirm,
      }),
    );

    return res.statusCode == 200;
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}