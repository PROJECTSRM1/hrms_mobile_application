import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/task_history.dart';
import '../models/task_type.dart';

class TaskService {
  static const String baseUrl = "https://hrms-be-ppze.onrender.com";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      "Content-Type": "application/json",
      "accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // GET /tasks/ - Get all tasks
  static Future<List<Task>> getTasks() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/tasks/"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  // POST /tasks/ - Create a new task
  static Future<Task> createTask(Task task) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse("$baseUrl/tasks/"),
        headers: headers,
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  // PUT /tasks/{task_id} - Update a task
  static Future<Task> updateTask(int taskId, Task task) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse("$baseUrl/tasks/$taskId"),
        headers: headers,
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  // PUT /tasks/{task_id}/status - Update task status
  static Future<Task> updateTaskStatus(int taskId, int statusId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse("$baseUrl/tasks/$taskId/status"),
        headers: headers,
        body: jsonEncode({"status_id": statusId}),
      );

      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update task status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating task status: $e');
    }
  }

  // POST /tasks/{task_id}/comment - Add comment to task
  static Future<String> addTaskComment(int taskId, String comment) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse("$baseUrl/tasks/$taskId/comment"),
        headers: headers,
        body: jsonEncode({"comment": comment}),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  // GET /tasks/history/ - Get task history
  static Future<List<Task>> getTaskHistory() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/tasks/history/"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load task history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching task history: $e');
    }
  }

  // GET /tasks/{task_id}/history - Get task history by task ID
  static Future<List<TaskHistory>> getTaskHistoryById(int taskId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/tasks/$taskId/history"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TaskHistory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load task history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching task history: $e');
    }
  }

  // GET /tasks/history/filter - Get filtered task history
  static Future<List<Task>> getFilteredTaskHistory({
    int? employeeId,
    int? managerId,
    int? projectId,
    int? moduleId,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{};
      
      if (employeeId != null) queryParams['employee_id'] = employeeId.toString();
      if (managerId != null) queryParams['manager_id'] = managerId.toString();
      if (projectId != null) queryParams['project_id'] = projectId.toString();
      if (moduleId != null) queryParams['module_id'] = moduleId.toString();

      final uri = Uri.parse("$baseUrl/tasks/history/filter")
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load filtered history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching filtered history: $e');
    }
  }

  // GET /master-task-type/ - Get task types
  static Future<List<TaskType>> getTaskTypes() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/master-task-type/"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TaskType.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load task types: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching task types: $e');
    }
  }

  // POST /master-task-type/ - Create task type
  static Future<TaskType> createTaskType(String name) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse("$baseUrl/master-task-type/"),
        headers: headers,
        body: jsonEncode({"name": name}),
      );

      if (response.statusCode == 200) {
        return TaskType.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create task type: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating task type: $e');
    }
  }

  // PUT /master-task-type/{task_type_id}/status - Update task type status
  static Future<TaskType> updateTaskTypeStatus(int taskTypeId, bool isActive) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse("$baseUrl/master-task-type/$taskTypeId/status"),
        headers: headers,
        body: jsonEncode({"is_active": isActive}),
      );

      if (response.statusCode == 200) {
        return TaskType.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update task type status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating task type status: $e');
    }
  }
}









// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/task.dart';
// import '../models/task_history.dart';
// import '../models/task_type.dart';

// class TaskService {
//   static const String baseUrl = "https://hrms-be-ppze.onrender.com";

//   static Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("hrms-token") ?? prefs.getString("auth_token");
//   }

//   static Future<Map<String, String>> _getHeaders() async {
//     final token = await _getToken();
//     return {
//       "Content-Type": "application/json",
//       "accept": "application/json",
//       if (token != null) "Authorization": "Bearer $token",
//     };
//   }

//   // GET /tasks/ - Get all tasks
//   static Future<List<Task>> getTasks() async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(
//         Uri.parse("$baseUrl/tasks/"),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => Task.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load tasks: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching tasks: $e');
//     }
//   }

//   // POST /tasks/ - Create a new task
//   static Future<Task> createTask(Task task) async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.post(
//         Uri.parse("$baseUrl/tasks/"),
//         headers: headers,
//         body: jsonEncode(task.toJson()),
//       );

//       if (response.statusCode == 200) {
//         return Task.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception('Failed to create task: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error creating task: $e');
//     }
//   }

//   // PUT /tasks/{task_id} - Update a task
//   static Future<Task> updateTask(int taskId, Task task) async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.put(
//         Uri.parse("$baseUrl/tasks/$taskId"),
//         headers: headers,
//         body: jsonEncode(task.toJson()),
//       );

//       if (response.statusCode == 200) {
//         return Task.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception('Failed to update task: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error updating task: $e');
//     }
//   }

//   // PUT /tasks/{task_id}/status - Update task status
//   static Future<Task> updateTaskStatus(int taskId, int statusId) async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.put(
//         Uri.parse("$baseUrl/tasks/$taskId/status"),
//         headers: headers,
//         body: jsonEncode({"status_id": statusId}),
//       );

//       if (response.statusCode == 200) {
//         return Task.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception('Failed to update task status: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error updating task status: $e');
//     }
//   }

//   // GET /tasks/history/ - Get task history
//   static Future<List<TaskHistory>> getTaskHistory() async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(
//         Uri.parse("$baseUrl/tasks/history/"),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => TaskHistory.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load task history: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching task history: $e');
//     }
//   }

//   // GET /tasks/history/filter - Get filtered task history
//   static Future<List<TaskHistory>> getFilteredTaskHistory({
//     int? employeeId,
//     int? managerId,
//     int? projectId,
//     int? moduleId,
//     int? statusId,
//   }) async {
//     try {
//       final headers = await _getHeaders();
//       final queryParams = <String, String>{};
      
//       if (employeeId != null) queryParams['employee_id'] = employeeId.toString();
//       if (managerId != null) queryParams['manager_id'] = managerId.toString();
//       if (projectId != null) queryParams['project_id'] = projectId.toString();
//       if (moduleId != null) queryParams['module_id'] = moduleId.toString();
//       if (statusId != null) queryParams['status_id'] = statusId.toString();

//       final uri = Uri.parse("$baseUrl/tasks/history/filter")
//           .replace(queryParameters: queryParams);

//       final response = await http.get(uri, headers: headers);

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => TaskHistory.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load filtered history: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching filtered history: $e');
//     }
//   }

//   // GET /master-task-type/ - Get task types
//   static Future<List<TaskType>> getTaskTypes() async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(
//         Uri.parse("$baseUrl/master-task-type/"),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => TaskType.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load task types: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching task types: $e');
//     }
//   }

//   // GET /employees/ - Get employees
//   static Future<List<Map<String, dynamic>>> getEmployees() async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(
//         Uri.parse("$baseUrl/employees/"),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((emp) => {
//           'id': emp['id'],
//           'name': '${emp['first_name'] ?? ''} ${emp['last_name'] ?? ''}'.trim(),
//           'managerId': emp['manager_id'],
//         }).toList();
//       } else {
//         throw Exception('Failed to load employees');
//       }
//     } catch (e) {
//       throw Exception('Error fetching employees: $e');
//     }
//   }

//   // GET /projects/ - Get projects
//   static Future<List<Map<String, dynamic>>> getProjects() async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(
//         Uri.parse("$baseUrl/projects/"),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final dynamic responseData = jsonDecode(response.body);
//         final List<dynamic> data = responseData is List ? responseData : responseData['data'] ?? [];
//         return data.map((proj) => {
//           'id': proj['id'],
//           'name': proj['name'] ?? proj['project_name'] ?? 'Unknown',
//           'isActive': proj['is_active'] ?? true,
//         }).toList();
//       } else {
//         throw Exception('Failed to load projects');
//       }
//     } catch (e) {
//       throw Exception('Error fetching projects: $e');
//     }
//   }

//   // GET /project-modules/ - Get project modules
//   static Future<List<Map<String, dynamic>>> getProjectModules() async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(
//         Uri.parse("$baseUrl/project-modules/"),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final dynamic responseData = jsonDecode(response.body);
//         final List<dynamic> data = responseData is List ? responseData : responseData['data'] ?? [];
//         return data.map((module) => {
//           'id': module['id'],
//           'name': module['project_module'] ?? module['name'] ?? 'Unknown',
//           'projectId': module['project_id'],
//           'isActive': module['is_active'] ?? true,
//         }).toList();
//       } else {
//         throw Exception('Failed to load modules');
//       }
//     } catch (e) {
//       throw Exception('Error fetching modules: $e');
//     }
//   }

//   // GET /task-statuses/ - Get task statuses
//   static Future<List<Map<String, dynamic>>> getTaskStatuses() async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(
//         Uri.parse("$baseUrl/task-statuses/"),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((status) => {
//           'id': status['id'],
//           'name': status['name'],
//           'isActive': status['is_active'] ?? true,
//         }).toList();
//       } else {
//         // Return default statuses if endpoint fails
//         return [
//           {'id': 11, 'name': 'Pending', 'isActive': true},
//           {'id': 1, 'name': 'In Progress', 'isActive': true},
//           {'id': 12, 'name': 'Completed', 'isActive': true},
//         ];
//       }
//     } catch (e) {
//       // Return default statuses if error
//       return [
//         {'id': 11, 'name': 'Pending', 'isActive': true},
//         {'id': 1, 'name': 'In Progress', 'isActive': true},
//         {'id': 12, 'name': 'Completed', 'isActive': true},
//       ];
//     }
//   }
// }