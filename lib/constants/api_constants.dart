class ApiConstants {
  static const String baseUrl = 'https://hrms-be-ppze.onrender.com';

  // Candidates
  static const String candidates = '/candidates/';
  static String updateCandidate(int id) => '/candidates/$id';

  // Departments
  static const String departments = '/departments/';
  static String departmentStatus(int id) => '/departments/$id/status';

  // Designations
  static const String designations = '/designations/';
  static String designationStatus(int id) => '/designations/$id/status';

  // Job openings
  static const String jobOpenings = '/job-openings/';
  static String jobOpeningStatus(int id) => '/job-openings/$id/status';
  static String jobOpeningUpdate(int id) => '/job-openings/$id/update';

  // Interview schedule
  static const String scheduleInterview = '/interview-schedule/schedule';
  static const String getInterviewSchedules = '/interview-schedule/';
  static String updateInterviewSchedule(int id) =>
      '/interview-schedule/$id';

  // Interview stage
  static const String interviewStages = '/interview-stage/';
  static String interviewStage(int id) => '/interview-stage/$id';
  static String interviewStageStatus(int id) =>
      '/interview-stage/$id/status';

  // Resume
  static const String uploadResume = '/upload/resume';
  static String getResume(String f) => '/upload/resume/$f';
  static String viewResume(String f) => '/upload/resume/view/$f';
}
