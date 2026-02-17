import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "https://hrms-be-ppze.onrender.com";

  /* ===================== STORAGE KEYS ===================== */
  static const String _tokenKey = "auth_token";
  static const String _employeeIdKey = "employee_id";

  /* ===================== TOKEN ===================== */

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
  }

  static Future<void> _saveEmpId(dynamic empId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("emp_id", empId.toString());
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<int?> getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_employeeIdKey);
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
      if (token != null && token.isNotEmpty && token.isNotEmpty) {
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
        final employeeId = data["emp_id"]; // from backend

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setInt(_employeeIdKey, employeeId);


        await _saveToken(data["token"]);
        await _saveEmpId(data["emp_id"]);

        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    }
  }



  /* ===================== PROFILE ===================== */

  /// GET /auth/me
  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/auth/me"),
        headers: await _headers(),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      return null;
    } catch (e) {
      print("Profile error: $e");
      return null;
    }
  }

  /// PUT /auth/me
  static Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
  }) async {
    try {
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
    } catch (e) {
      debugPrint("Update profile error: $e");
      return false;
    }
  }

  /* ===================== PASSWORD ===================== */

  /// PUT /auth/change-password
  static Future<bool> changePassword({
    required String current,
    required String newPass,
    required String confirm,
  }) async {
    try {
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
    } catch (e) {
      debugPrint("Change password error: $e");
      return false;
    }
  }

  /* ===================== SESSION ===================== */

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
