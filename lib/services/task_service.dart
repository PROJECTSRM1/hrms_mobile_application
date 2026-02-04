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
//     return prefs.getString("auth_token");
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

//   // POST /tasks/{task_id}/comment - Add comment to task
//   static Future<String> addTaskComment(int taskId, String comment) async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.post(
//         Uri.parse("$baseUrl/tasks/$taskId/comment"),
//         headers: headers,
//         body: jsonEncode({"comment": comment}),
//       );

//       if (response.statusCode == 200) {
//         return response.body;
//       } else {
//         throw Exception('Failed to add comment: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error adding comment: $e');
//     }
//   }

//   // GET /tasks/history/ - Get task history
//   static Future<List<Task>> getTaskHistory() async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(
//         Uri.parse("$baseUrl/tasks/history/"),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => Task.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load task history: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching task history: $e');
//     }
//   }

//   // GET /tasks/{task_id}/history - Get task history by task ID
//   static Future<List<TaskHistory>> getTaskHistoryById(int taskId) async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(
//         Uri.parse("$baseUrl/tasks/$taskId/history"),
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
//   static Future<List<Task>> getFilteredTaskHistory({
//     int? employeeId,
//     int? managerId,
//     int? projectId,
//     int? moduleId,
//   }) async {
//     try {
//       final headers = await _getHeaders();
//       final queryParams = <String, String>{};
      
//       if (employeeId != null) queryParams['employee_id'] = employeeId.toString();
//       if (managerId != null) queryParams['manager_id'] = managerId.toString();
//       if (projectId != null) queryParams['project_id'] = projectId.toString();
//       if (moduleId != null) queryParams['module_id'] = moduleId.toString();

//       final uri = Uri.parse("$baseUrl/tasks/history/filter")
//           .replace(queryParameters: queryParams);

//       final response = await http.get(uri, headers: headers);

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => Task.fromJson(json)).toList();
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

//   // POST /master-task-type/ - Create task type
//   static Future<TaskType> createTaskType(String name) async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.post(
//         Uri.parse("$baseUrl/master-task-type/"),
//         headers: headers,
//         body: jsonEncode({"name": name}),
//       );

//       if (response.statusCode == 200) {
//         return TaskType.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception('Failed to create task type: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error creating task type: $e');
//     }
//   }

//   // PUT /master-task-type/{task_type_id}/status - Update task type status
//   static Future<TaskType> updateTaskTypeStatus(int taskTypeId, bool isActive) async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.put(
//         Uri.parse("$baseUrl/master-task-type/$taskTypeId/status"),
//         headers: headers,
//         body: jsonEncode({"is_active": isActive}),
//       );

//       if (response.statusCode == 200) {
//         return TaskType.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception('Failed to update task type status: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error updating task type status: $e');
//     }
//   }
// }











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

  // ============ TASK OPERATIONS ============

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
        throw Exception('Failed to create task: ${response.statusCode} - ${response.body}');
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
        throw Exception('Failed to update task: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  // PUT /tasks/{task_id} - Update task with custom data
  static Future<void> updateTaskById(int taskId, Map<String, dynamic> updateData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse("$baseUrl/tasks/$taskId"),
        headers: headers,
        body: jsonEncode(updateData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update task: ${response.statusCode} - ${response.body}');
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

  // ============ TASK HISTORY ============

  // GET /tasks/history/ - Get task history
  static Future<List<TaskHistory>> getTaskHistory() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/tasks/history/"),
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
  static Future<List<TaskHistory>> getFilteredTaskHistory({
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
        return data.map((json) => TaskHistory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load filtered history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching filtered history: $e');
    }
  }

  // ============ TASK TYPES ============

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

  // ============ ADDITIONAL DATA ENDPOINTS ============

  // GET Employees (assuming endpoint exists)
  static Future<List<Map<String, dynamic>>> getEmployees() async {
    try {
      final headers = await _getHeaders();
      // Replace with actual endpoint when available
      final response = await http.get(
        Uri.parse("$baseUrl/employees/"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => {
          'id': e['id'] ?? e['emp_id'],
          'name': e['name'] ?? e['employee_name'] ?? '${e['first_name'] ?? ''} ${e['last_name'] ?? ''}'.trim(),
        }).toList();
      } else {
        // Return mock data if endpoint doesn't exist yet
        return _getMockEmployees();
      }
    } catch (e) {
      // Return mock data on error
      return _getMockEmployees();
    }
  }

  // GET Managers (assuming endpoint exists or use employees endpoint)
  static Future<List<Map<String, dynamic>>> getManagers() async {
    try {
      final headers = await _getHeaders();
      // Try to get from managers endpoint or use employees
      final response = await http.get(
        Uri.parse("$baseUrl/managers/"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => {
          'id': e['id'] ?? e['manager_id'],
          'name': e['name'] ?? e['manager_name'] ?? '${e['first_name'] ?? ''} ${e['last_name'] ?? ''}'.trim(),
        }).toList();
      } else {
        // Fallback to employees
        return await getEmployees();
      }
    } catch (e) {
      // Fallback to employees or mock data
      return await getEmployees();
    }
  }

  // GET Projects
  static Future<List<Map<String, dynamic>>> getProjects() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/projects/"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => {
          'id': e['id'] ?? e['project_id'],
          'name': e['name'] ?? e['project_name'],
        }).toList();
      } else {
        return _getMockProjects();
      }
    } catch (e) {
      return _getMockProjects();
    }
  }

  // GET Project Modules
  static Future<List<Map<String, dynamic>>> getProjectModules(int projectId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/projects/$projectId/modules"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => {
          'id': e['id'] ?? e['module_id'],
          'name': e['name'] ?? e['module_name'],
        }).toList();
      } else {
        return _getMockModules();
      }
    } catch (e) {
      return _getMockModules();
    }
  }

  // GET Assigned Tasks
  static Future<List<Map<String, dynamic>>> getAssignedTasks() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse("$baseUrl/tasks/assigned"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((task) => {
          'taskId': task['id'] ?? task['task_id'],
          'employeeName': task['employee_name'] ?? 'N/A',
          'projectName': task['project_name'] ?? 'N/A',
          'reportingManager': task['reporting_manager_name'] ?? 'No Manager',
          'taskTitle': task['title'] ?? task['task_title'] ?? '',
          'taskDescription': task['description'] ?? task['task_description'] ?? '',
          'effortsInDays': task['efforts_in_days'] ?? 0,
          'taskStatus': task['status_name'] ?? task['task_status'] ?? 'N/A',
          'dueDate': task['due_date'] ?? 'N/A',
        }).toList();
      } else {
        // Try alternative endpoint
        final tasks = await getTasks();
        return tasks.where((task) => task.empId != null).map((task) => {
          'taskId': task.id,
          'employeeName': 'N/A', // Would need to fetch from employee service
          'projectName': 'N/A', // Would need to fetch from project service
          'reportingManager': 'No Manager',
          'taskTitle': task.title,
          'taskDescription': task.description,
          'effortsInDays': task.effortsInDays ?? 0,
          'taskStatus': 'N/A',
          'dueDate': task.dueDate ?? 'N/A',
        }).toList();
      }
    } catch (e) {
      throw Exception('Error fetching assigned tasks: $e');
    }
  }

  // ============ MOCK DATA (fallback) ============

  static List<Map<String, dynamic>> _getMockEmployees() {
    return [
      {'id': 1, 'name': 'John Doe'},
      {'id': 2, 'name': 'Jane Smith'},
      {'id': 3, 'name': 'Bob Wilson'},
      {'id': 4, 'name': 'Alice Brown'},
      {'id': 5, 'name': 'Mahesh Kesani'},
      {'id': 6, 'name': 'Anita Reddy'},
      {'id': 7, 'name': 'Anil Kumar P'},
      {'id': 8, 'name': 'Suresh Naik'},
      {'id': 9, 'name': 'Roshan Karthik'},
      {'id': 10, 'name': 'Naveen Varma'},
    ];
  }

  static List<Map<String, dynamic>> _getMockProjects() {
    return [
      {'id': 1, 'name': 'HRMS'},
      {'id': 2, 'name': 'Swachify'},
      {'id': 3, 'name': 'RJB'},
      {'id': 4, 'name': 'INRFS'},
      {'id': 5, 'name': 'Hrms mobile'},
    ];
  }

  static List<Map<String, dynamic>> _getMockModules() {
    return [
      {'id': 1, 'name': 'Dashboard'},
      {'id': 2, 'name': 'User Management'},
      {'id': 3, 'name': 'Reports'},
      {'id': 4, 'name': 'Settings'},
    ];
  }
}