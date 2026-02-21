// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/department_model.dart';
import '../models/designation_model.dart';
import '../models/job_opening_model.dart';
import '../models/candidate_model.dart';
import '../models/interview_schedule_model.dart';
import '../models/interview_stage_model.dart';

class ApiService {
  final String baseUrl = ApiConstants.baseUrl;

  // Helper method to get headers
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Helper method to handle errors
  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  // ==================== DEPARTMENTS ====================

  Future<List<Department>> getDepartments() async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.departments}'),
      headers: _getHeaders(),
    );
    _handleError(response);

    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Department.fromJson(json)).toList();
  }

  Future<Department> createDepartment(CreateDepartmentRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConstants.departments}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return Department.fromJson(json.decode(response.body));
  }

  Future<Department> updateDepartmentStatus(
      int deptId, UpdateDepartmentStatusRequest request) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiConstants.departmentStatus(deptId)}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return Department.fromJson(json.decode(response.body));
  }

  // ==================== DESIGNATIONS ====================

  Future<List<Designation>> getDesignations() async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.designations}'),
      headers: _getHeaders(),
    );
    _handleError(response);

    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Designation.fromJson(json)).toList();
  }

  Future<Designation> createDesignation(CreateDesignationRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConstants.designations}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return Designation.fromJson(json.decode(response.body));
  }

  Future<Designation> updateDesignationStatus(
      int designationId, UpdateDesignationStatusRequest request) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiConstants.designationStatus(designationId)}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return Designation.fromJson(json.decode(response.body));
  }

  // ==================== JOB OPENINGS ====================

  Future<List<JobOpening>> getJobOpenings() async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.jobOpenings}'),
      headers: _getHeaders(),
    );
    _handleError(response);

    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => JobOpening.fromJson(json)).toList();
  }

  Future<JobOpening> createJobOpening(CreateJobOpeningRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConstants.jobOpenings}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return JobOpening.fromJson(json.decode(response.body));
  }

  Future<JobOpening> updateJobOpening(
      int jobId, UpdateJobOpeningRequest request) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiConstants.jobOpeningUpdate(jobId)}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return JobOpening.fromJson(json.decode(response.body));
  }

  Future<JobOpening> updateJobOpeningStatus(
      int jobId, UpdateJobOpeningStatusRequest request) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiConstants.jobOpeningStatus(jobId)}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return JobOpening.fromJson(json.decode(response.body));
  }

  // ==================== CANDIDATES ====================

  Future<List<Candidate>> getCandidates() async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.candidates}'),
      headers: _getHeaders(),
    );
    _handleError(response);

    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Candidate.fromJson(json)).toList();
  }

  Future<Candidate> createCandidate(CreateCandidateRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConstants.candidates}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return Candidate.fromJson(json.decode(response.body));
  }

  Future<Candidate> updateCandidate(
      int id, UpdateCandidateRequest request) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiConstants.updateCandidate(id)}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return Candidate.fromJson(json.decode(response.body));
  }

  // ==================== RESUME UPLOAD ====================

  Future<String> uploadResume(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl${ApiConstants.uploadResume}'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode >= 400) {
      throw Exception('Resume upload failed: $responseData');
    }

    return json.decode(responseData);
  }

  Future<String> getResume(String filename) async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.getResume(filename)}'),
      headers: _getHeaders(),
    );
    _handleError(response);

    return json.decode(response.body);
  }

  Future<String> viewResume(String filename) async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.viewResume(filename)}'),
      headers: _getHeaders(),
    );
    _handleError(response);

    return json.decode(response.body);
  }

  // ==================== INTERVIEW SCHEDULE ====================

  Future<InterviewSchedule> scheduleInterview(
      ScheduleInterviewRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConstants.scheduleInterview}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return InterviewSchedule.fromJson(json.decode(response.body));
  }

  Future<List<InterviewSchedule>> getInterviewSchedules() async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.getInterviewSchedules}'),
      headers: _getHeaders(),
    );
    _handleError(response);

    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => InterviewSchedule.fromJson(json)).toList();
  }

  Future<InterviewSchedule> updateInterviewSchedule(
      int interviewId, UpdateInterviewScheduleRequest request) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiConstants.updateInterviewSchedule(interviewId)}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return InterviewSchedule.fromJson(json.decode(response.body));
  }

  // ==================== INTERVIEW STAGES ====================

  Future<List<InterviewStage>> getInterviewStages() async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.interviewStages}'),
      headers: _getHeaders(),
    );
    _handleError(response);

    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => InterviewStage.fromJson(json)).toList();
  }

  Future<InterviewStage> createStage(CreateStageRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConstants.interviewStages}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return InterviewStage.fromJson(json.decode(response.body));
  }

  Future<InterviewStage> getStage(int stageId) async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiConstants.interviewStage(stageId)}'),
      headers: _getHeaders(),
    );
    _handleError(response);

    return InterviewStage.fromJson(json.decode(response.body));
  }

  Future<InterviewStage> updateStage(
      int stageId, UpdateStageRequest request) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiConstants.interviewStage(stageId)}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return InterviewStage.fromJson(json.decode(response.body));
  }

  Future<void> deleteStage(int stageId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl${ApiConstants.interviewStage(stageId)}'),
      headers: _getHeaders(),
    );
    _handleError(response);
  }

  Future<InterviewStage> updateStageStatus(
      int stageId, UpdateStageStatusRequest request) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiConstants.interviewStageStatus(stageId)}'),
      headers: _getHeaders(),
      body: json.encode(request.toJson()),
    );
    _handleError(response);

    return InterviewStage.fromJson(json.decode(response.body));
  }
}