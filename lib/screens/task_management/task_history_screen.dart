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
import '../../models/task.dart';
import '../../services/task_service.dart';

class TaskHistoryScreen extends StatefulWidget {
  const TaskHistoryScreen({super.key});

  @override
  State<TaskHistoryScreen> createState() => _TaskHistoryScreenState();
}

class _TaskHistoryScreenState extends State<TaskHistoryScreen> {
  List<Task> _historyTasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = false;

  int? _selectedEmployeeId;
  int? _selectedManagerId;
  int? _selectedProjectId;
  int? _selectedModuleId;

  final List<Map<String, dynamic>> _employees = [
    {'id': 1, 'name': 'Mahesh Kesani'},
    {'id': 2, 'name': 'Roshan Karthik'},
    {'id': 3, 'name': 'Naveen Varma'},
    {'id': 4, 'name': 'Anita Reddy'},
  ];

  final List<Map<String, dynamic>> _managers = [
    {'id': 1, 'name': 'Mahesh Kesani'},
    {'id': 2, 'name': 'Roshan Karthik'},
    {'id': 3, 'name': 'Anita Reddy'},
    {'id': 4, 'name': 'Naveen Varma'},
  ];

  final List<Map<String, dynamic>> _projects = [
    {'id': 1, 'name': 'HRMS'},
    {'id': 2, 'name': 'RJB'},
    {'id': 3, 'name': 'INRFS'},
  ];

  // Mock history data matching the screenshot
  final List<Map<String, dynamic>> _mockHistory = [
    {
      'employeeName': 'Mahesh Kesani',
      'taskName': 'hrms',
      'manager': 'Mahesh Kesani',
      'completed': 'Not Completed',
      'project': 'HRMS',
      'efforts': 3,
    },
    {
      'employeeName': 'Roshan Karthik',
      'taskName': 'hrms',
      'manager': 'Roshan Karthik',
      'completed': 'Not Completed',
      'project': 'HRMS',
      'efforts': 2,
    },
    {
      'employeeName': 'Roshan Karthik',
      'taskName': 'RJB',
      'manager': 'Roshan Karthik',
      'completed': 'Not Completed',
      'project': 'RJB',
      'efforts': 1,
    },
    {
      'employeeName': 'Naveen Varma',
      'taskName': 'INRFS',
      'manager': 'Naveen Varma',
      'completed': '2026-01-21',
      'project': 'INRFS',
      'efforts': 2,
    },
    {
      'employeeName': 'Anita Reddy',
      'taskName': 'HRMS',
      'manager': 'Anita Reddy',
      'completed': '2026-01-22',
      'project': 'HRMS',
      'efforts': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadTaskHistory();
  }

  Future<void> _loadTaskHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = await TaskService.getTaskHistory();
      setState(() {
        _historyTasks = tasks;
        _filteredTasks = tasks;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load task history: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _applyFilters() async {
    if (_selectedEmployeeId == null &&
        _selectedManagerId == null &&
        _selectedProjectId == null &&
        _selectedModuleId == null) {
      setState(() {
        _filteredTasks = _historyTasks;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = await TaskService.getFilteredTaskHistory(
        employeeId: _selectedEmployeeId,
        managerId: _selectedManagerId,
        projectId: _selectedProjectId,
        moduleId: _selectedModuleId,
      );
      setState(() {
        _filteredTasks = tasks;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to apply filters: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedEmployeeId = null;
      _selectedManagerId = null;
      _selectedProjectId = null;
      _selectedModuleId = null;
      _filteredTasks = _historyTasks;
    });
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
            onPressed: _loadTaskHistory,
          ),
        ],
      ),
      body: Column(
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
                        value: _selectedEmployeeId,
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
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedManagerId,
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedProjectId,
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
                        },
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
                        items: const [],
                        onChanged: (value) {
                          setState(() {
                            _selectedModuleId = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _applyFilters,
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
                        onPressed: _clearFilters,
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
                ? const Center(child: CircularProgressIndicator())
                : _buildHistoryTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTable() {
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
                    flex: 1,
                    child: Text(
                      'Description',
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
                      'Completed',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Project',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Efforts (days)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            // Table Rows
            ..._mockHistory.map((item) {
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
                      child: Text(item['employeeName']),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(item['taskName']),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(''),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(item['manager']),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        item['completed'],
                        style: TextStyle(
                          color: item['completed'] == 'Not Completed'
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(item['project']),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(item['efforts'].toString()),
                    ),
                  ],
                ),
              );
            }),
            // Pagination
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {},
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0AA6B7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '1',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('2'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('3'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('4'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}