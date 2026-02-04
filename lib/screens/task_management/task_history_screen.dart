// import 'package:flutter/material.dart';
// import '../../models/task.dart';
// import '../../services/task_service.dart';

// class TaskHistoryScreen extends StatefulWidget {
//   const TaskHistoryScreen({super.key});

//   @override
//   State<TaskHistoryScreen> createState() => _TaskHistoryScreenState();
// }

// class _TaskHistoryScreenState extends State<TaskHistoryScreen> {
//   List<Task> _historyTasks = [];
//   List<Task> _filteredTasks = [];
//   bool _isLoading = false;

//   int? _selectedEmployeeId;
//   int? _selectedManagerId;
//   int? _selectedProjectId;
//   int? _selectedModuleId;

//   final List<Map<String, dynamic>> _employees = [
//     {'id': 1, 'name': 'Mahesh Kesani'},
//     {'id': 2, 'name': 'Roshan Karthik'},
//     {'id': 3, 'name': 'Naveen Varma'},
//     {'id': 4, 'name': 'Anita Reddy'},
//   ];

//   final List<Map<String, dynamic>> _managers = [
//     {'id': 1, 'name': 'Mahesh Kesani'},
//     {'id': 2, 'name': 'Roshan Karthik'},
//     {'id': 3, 'name': 'Anita Reddy'},
//     {'id': 4, 'name': 'Naveen Varma'},
//   ];

//   final List<Map<String, dynamic>> _projects = [
//     {'id': 1, 'name': 'HRMS'},
//     {'id': 2, 'name': 'RJB'},
//     {'id': 3, 'name': 'INRFS'},
//   ];

//   // Mock history data matching the screenshot
//   final List<Map<String, dynamic>> _mockHistory = [
//     {
//       'employeeName': 'Mahesh Kesani',
//       'taskName': 'hrms',
//       'manager': 'Mahesh Kesani',
//       'completed': 'Not Completed',
//       'project': 'HRMS',
//       'efforts': 3,
//     },
//     {
//       'employeeName': 'Roshan Karthik',
//       'taskName': 'hrms',
//       'manager': 'Roshan Karthik',
//       'completed': 'Not Completed',
//       'project': 'HRMS',
//       'efforts': 2,
//     },
//     {
//       'employeeName': 'Roshan Karthik',
//       'taskName': 'RJB',
//       'manager': 'Roshan Karthik',
//       'completed': 'Not Completed',
//       'project': 'RJB',
//       'efforts': 1,
//     },
//     {
//       'employeeName': 'Naveen Varma',
//       'taskName': 'INRFS',
//       'manager': 'Naveen Varma',
//       'completed': '2026-01-21',
//       'project': 'INRFS',
//       'efforts': 2,
//     },
//     {
//       'employeeName': 'Anita Reddy',
//       'taskName': 'HRMS',
//       'manager': 'Anita Reddy',
//       'completed': '2026-01-22',
//       'project': 'HRMS',
//       'efforts': 1,
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadTaskHistory();
//   }

//   Future<void> _loadTaskHistory() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final tasks = await TaskService.getTaskHistory();
//       setState(() {
//         _historyTasks = tasks;
//         _filteredTasks = tasks;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load task history: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _applyFilters() async {
//     if (_selectedEmployeeId == null &&
//         _selectedManagerId == null &&
//         _selectedProjectId == null &&
//         _selectedModuleId == null) {
//       setState(() {
//         _filteredTasks = _historyTasks;
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final tasks = await TaskService.getFilteredTaskHistory(
//         employeeId: _selectedEmployeeId,
//         managerId: _selectedManagerId,
//         projectId: _selectedProjectId,
//         moduleId: _selectedModuleId,
//       );
//       setState(() {
//         _filteredTasks = tasks;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to apply filters: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   void _clearFilters() {
//     setState(() {
//       _selectedEmployeeId = null;
//       _selectedManagerId = null;
//       _selectedProjectId = null;
//       _selectedModuleId = null;
//       _filteredTasks = _historyTasks;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F8FB),
//       appBar: AppBar(
//         title: const Text('Task History'),
//         backgroundColor: const Color(0xFF0AA6B7),
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _loadTaskHistory,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Filters Section
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButtonFormField<int>(
//                         initialValue: _selectedEmployeeId,
//                         decoration: const InputDecoration(
//                           labelText: 'Employee',
//                           border: OutlineInputBorder(),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ),
//                         ),
//                         items: _employees
//                             .map((emp) => DropdownMenuItem(
//                                   value: emp['id'] as int,
//                                   child: Text(emp['name'] as String),
//                                 ))
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedEmployeeId = value;
//                           });
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: DropdownButtonFormField<int>(
//                         initialValue: _selectedManagerId,
//                         decoration: const InputDecoration(
//                           labelText: 'Manager',
//                           border: OutlineInputBorder(),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ),
//                         ),
//                         items: _managers
//                             .map((mgr) => DropdownMenuItem(
//                                   value: mgr['id'] as int,
//                                   child: Text(mgr['name'] as String),
//                                 ))
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedManagerId = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButtonFormField<int>(
//                         initialValue: _selectedProjectId,
//                         decoration: const InputDecoration(
//                           labelText: 'Project',
//                           border: OutlineInputBorder(),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ),
//                         ),
//                         items: _projects
//                             .map((proj) => DropdownMenuItem(
//                                   value: proj['id'] as int,
//                                   child: Text(proj['name'] as String),
//                                 ))
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedProjectId = value;
//                           });
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: DropdownButtonFormField<int>(
//                         initialValue : _selectedModuleId,
//                         decoration: const InputDecoration(
//                           labelText: 'Module',
//                           border: OutlineInputBorder(),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ),
//                         ),
//                         items: const [],
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedModuleId = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: _applyFilters,
//                         icon: const Icon(Icons.filter_list, size: 18),
//                         label: const Text('Apply Filters'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF0AA6B7),
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: _clearFilters,
//                         icon: const Icon(Icons.clear, size: 18),
//                         label: const Text('Clear'),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1),
//           // History Table
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _buildHistoryTable(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHistoryTable() {
//     return SingleChildScrollView(
//       child: Container(
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // Table Header
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF6F8FB),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(12),
//                   topRight: Radius.circular(12),
//                 ),
//               ),
//               child: const Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       'Employee Name',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       'Task Name',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Text(
//                       'Description',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       'Manager',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       'Completed',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Text(
//                       'Project',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Text(
//                       'Efforts (days)',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Table Rows
//             ..._mockHistory.map((item) {
//               return Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(color: Color(0xFFF6F8FB)),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(item['employeeName']),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Text(item['taskName']),
//                     ),
//                     const Expanded(
//                       flex: 1,
//                       child: Text(''),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Text(item['manager']),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         item['completed'],
//                         style: TextStyle(
//                           color: item['completed'] == 'Not Completed'
//                               ? Colors.orange
//                               : Colors.green,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Text(item['project']),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Text(item['efforts'].toString()),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//             // Pagination
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.chevron_left),
//                     onPressed: () {},
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF0AA6B7),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: const Text(
//                       '1',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: const Text('2'),
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: const Text('3'),
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: const Text('4'),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.chevron_right),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }












import 'package:flutter/material.dart';
import '../../models/task_history.dart';
import '../../services/task_service.dart';

class TaskHistoryScreen extends StatefulWidget {
  const TaskHistoryScreen({super.key});

  @override
  State<TaskHistoryScreen> createState() => _TaskHistoryScreenState();
}

class _TaskHistoryScreenState extends State<TaskHistoryScreen> {
  List<TaskHistory> _historyTasks = [];
  List<TaskHistory> _filteredTasks = [];
  bool _isLoading = false;
  bool _isInitialLoading = true;

  int? _selectedEmployeeId;
  int? _selectedManagerId;
  int? _selectedProjectId;
  int? _selectedModuleId;

  List<Map<String, dynamic>> _employees = [];
  List<Map<String, dynamic>> _managers = [];
  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _modules = [];

  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _totalPages = 1;
  List<TaskHistory> _currentPageData = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isInitialLoading = true;
    });

    try {
      await Future.wait([
        _loadTaskHistory(),
        _loadEmployees(),
        _loadManagers(),
        _loadProjects(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  Future<void> _loadTaskHistory() async {
    try {
      final tasks = await TaskService.getTaskHistory();
      setState(() {
        _historyTasks = tasks;
        _filteredTasks = tasks;
        _updatePagination();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load task history: $e')),
        );
      }
    }
  }

  Future<void> _loadEmployees() async {
    try {
      final employees = await TaskService.getEmployees();
      setState(() {
        _employees = employees;
      });
    } catch (e) {
      // Silently fail for dropdowns
      print('Failed to load employees: $e');
    }
  }

  Future<void> _loadManagers() async {
    try {
      final managers = await TaskService.getManagers();
      setState(() {
        _managers = managers;
      });
    } catch (e) {
      // Silently fail for dropdowns
      print('Failed to load managers: $e');
    }
  }

  Future<void> _loadProjects() async {
    try {
      final projects = await TaskService.getProjects();
      setState(() {
        _projects = projects;
      });
    } catch (e) {
      // Silently fail for dropdowns
      print('Failed to load projects: $e');
    }
  }

  Future<void> _loadModules(int projectId) async {
    try {
      final modules = await TaskService.getProjectModules(projectId);
      setState(() {
        _modules = modules;
        _selectedModuleId = null;
      });
    } catch (e) {
      print('Failed to load modules: $e');
    }
  }

  void _updatePagination() {
    _totalPages = (_filteredTasks.length / _itemsPerPage).ceil();
    if (_totalPages == 0) _totalPages = 1;
    
    if (_currentPage > _totalPages) {
      _currentPage = _totalPages;
    }
    
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    
    _currentPageData = _filteredTasks.sublist(
      startIndex,
      endIndex > _filteredTasks.length ? _filteredTasks.length : endIndex,
    );
  }


Future<void> _applyFilters() async {
  setState(() => _isLoading = true);

  await Future.delayed(const Duration(milliseconds: 200));

  List<TaskHistory> temp = _historyTasks;

  if (_selectedEmployeeId != null) {
    temp = temp
        .where((t) => t.empId == _selectedEmployeeId)
        .toList();
  }

  if (_selectedManagerId != null) {
    temp = temp
        .where((t) => t.reportingManagerId == _selectedManagerId)
        .toList();
  }

  if (_selectedProjectId != null) {
    temp = temp
        .where((t) => t.projectId == _selectedProjectId)
        .toList();
  }

  if (_selectedModuleId != null) {
    temp = temp
        .where((t) => t.projectModuleId == _selectedModuleId)
        .toList();
  }

  setState(() {
    _filteredTasks = temp;
    _currentPage = 1;
    _updatePagination();
    _isLoading = false;
  });
}




  void _clearFilters() {
    setState(() {
      _selectedEmployeeId = null;
      _selectedManagerId = null;
      _selectedProjectId = null;
      _selectedModuleId = null;
      _modules = [];
      _filteredTasks = _historyTasks;
      _currentPage = 1;
      _updatePagination();
    });
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
        _updatePagination();
      });
    }
  }

  String _getStatusDisplay(TaskHistory task) {
    if (task.statusName != null) {
      return task.statusName!;
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Task History'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInitialData,
          ),
        ],
      ),
      body: _isInitialLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0AA6B7)),
              ),
            )
          : Column(
              children: [
                // Filters Section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _selectedEmployeeId,
                              decoration: const InputDecoration(
                                labelText: 'Employee',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              items: _employees
                                  .map((emp) => DropdownMenuItem(
                                        value: emp['id'] as int,
                                        child: Text(emp['name'] as String),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedEmployeeId = value;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _selectedManagerId,
                              decoration: const InputDecoration(
                                labelText: 'Manager',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              items: _managers
                                  .map((mgr) => DropdownMenuItem(
                                        value: mgr['id'] as int,
                                        child: Text(mgr['name'] as String),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedManagerId = value;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _selectedProjectId,
                              decoration: const InputDecoration(
                                labelText: 'Project',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              items: _projects
                                  .map((proj) => DropdownMenuItem(
                                        value: proj['id'] as int,
                                        child: Text(proj['name'] as String),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedProjectId = value;
                                });
                                if (value != null) {
                                  _loadModules(value);
                                }
                              },
                              isExpanded: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _selectedModuleId,
                              decoration: const InputDecoration(
                                labelText: 'Module',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              items: _modules
                                  .map((mod) => DropdownMenuItem(
                                        value: mod['id'] as int,
                                        child: Text(mod['name'] as String),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedModuleId = value;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _applyFilters,
                              icon: const Icon(Icons.filter_list, size: 18),
                              label: const Text('Apply Filters'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0AA6B7),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isLoading ? null : _clearFilters,
                              icon: const Icon(Icons.clear, size: 18),
                              label: const Text('Clear'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                
                // History Table
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0AA6B7)),
                          ),
                        )
                      : _buildHistoryTable(),
                ),
              ],
            ),
    );
  }

  Widget _buildHistoryTable() {
    if (_currentPageData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No task history found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF6F8FB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Employee Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Task Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Manager',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Project',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Efforts',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            // Table Rows
            ..._currentPageData.map((task) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFF6F8FB)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(task.employeeName ?? 'N/A'),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(task.title ?? 'N/A'),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(task.reportingManagerName ?? 'N/A'),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        _getStatusDisplay(task),
                        style: TextStyle(
                          color: task.statusName?.toLowerCase() == 'completed'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(task.projectName ?? 'N/A'),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(task.effortsInDays?.toString() ?? '0'),
                    ),
                  ],
                ),
              );
            }),
            
            // Pagination
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${(_currentPage - 1) * _itemsPerPage + 1} to ${(_currentPage * _itemsPerPage > _filteredTasks.length) ? _filteredTasks.length : _currentPage * _itemsPerPage} of ${_filteredTasks.length} entries',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _currentPage > 1
                            ? () => _goToPage(_currentPage - 1)
                            : null,
                      ),
                      ..._buildPageNumbers(),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _currentPage < _totalPages
                            ? () => _goToPage(_currentPage + 1)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pageButtons = [];
    
    // Show max 5 page numbers
    int startPage = _currentPage - 2;
    int endPage = _currentPage + 2;
    
    if (startPage < 1) {
      startPage = 1;
      endPage = _totalPages < 5 ? _totalPages : 5;
    }
    
    if (endPage > _totalPages) {
      endPage = _totalPages;
      startPage = _totalPages - 4 > 0 ? _totalPages - 4 : 1;
    }
    
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(
        _currentPage == i
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0AA6B7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  i.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              )
            : TextButton(
                onPressed: () => _goToPage(i),
                child: Text(i.toString()),
              ),
      );
    }
    
    return pageButtons;
  }
}