import 'dart:io';
import 'package:http/http.dart' as http;

class LeaveApiService {
  static Future<bool> applyLeave({
    required int empId,
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
    final uri = Uri.parse(
      "https://hrms-be-ppze.onrender.com/leave/apply",
    );

    final request = http.MultipartRequest("POST", uri);

    // 🔑 HEADERS (very important)
    request.headers.addAll({
      "Accept": "application/json",
      // If backend needs auth token:
      // "Authorization": "Bearer YOUR_TOKEN",
    });

    // 📦 BODY FIELDS (Swagger match)
    request.fields.addAll({
      "emp_id": empId.toString(),
      "leavetype_id": leaveTypeId.toString(),
      "start_date": startDate,
      "end_date": endDate,
      "from_date_session_id": fromSession,
      "to_date_session_id": toSession,
      "reason": reason,
      "mobile": mobile,
      "reporting_manager_id": reportingManagerId.toString(),
      "cc": "",
    });

    // 📎 FILE
    if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "upload_file", // ⚠️ MUST match Swagger key
          file.path,
        ),
      );
    }

    final response = await request.send();

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
