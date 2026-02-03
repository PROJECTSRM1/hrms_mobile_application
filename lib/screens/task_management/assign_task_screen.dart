// import 'package:flutter/material.dart';
// import '../../models/task.dart';
// import '../../services/task_service.dart';

// class AssignTaskScreen extends StatefulWidget {
//   const AssignTaskScreen({super.key});

//   @override
//   State<AssignTaskScreen> createState() => _AssignTaskScreenState();
// }

// class _AssignTaskScreenState extends State<AssignTaskScreen> {
//   int? _selectedTaskId;
//   int? _selectedEmployeeId;
//   bool _isLoading = false;
  
//   List<Task> _tasks = [];
  
//   final List<Map<String, dynamic>> _employees = [
//     {'id': 1, 'name': 'John Doe'},
//     {'id': 2, 'name': 'Jane Smith'},
//     {'id': 3, 'name': 'Bob Wilson'},
//     {'id': 4, 'name': 'Alice Brown'},
//     {'id': 5, 'name': 'Mahesh Kesani'},
//     {'id': 6, 'name': 'Anita Reddy'},
//     {'id': 7, 'name': 'Anil Kumar P'},
//     {'id': 8, 'name': 'Suresh Naik'},
//     {'id': 9, 'name': 'Roshan Karthik'},
//     {'id': 10, 'name': 'Naveen Varma'},
//   ];

//   // Mock data for assigned tasks matching the screenshot
//   final List<Map<String, dynamic>> _assignedTasks = [
//     {
//       'employeeName': 'Mahesh Kesani',
//       'projectName': 'HRMS',
//       'reportingManager': 'John Doe',
//       'taskTitle': 'swachi',
//       'taskDescription': 'demo',
//       'effortsInDays': 0,
//       'taskStatus': 'In Progress',
//       'dueDate': '2026-01-29',
//     },
//     {
//       'employeeName': 'Anita Reddy',
//       'projectName': 'swachify',
//       'reportingManager': 'John Doe',
//       'taskTitle': 'swachify',
//       'taskDescription': 'dgvrx',
//       'effortsInDays': 12,
//       'taskStatus': 'Completed',
//       'dueDate': '2026-01-29',
//     },
//     {
//       'employeeName': 'Anita Reddy',
//       'projectName': 'swachify',
//       'reportingManager': 'Rakesh Verma',
//       'taskTitle': 'main page',
//       'taskDescription': 'dcfvgbhnjm',
//       'effortsInDays': 1,
//       'taskStatus': '2',
//       'dueDate': '2026-01-28',
//     },
//     {
//       'employeeName': 'Anil kumar P',
//       'projectName': 'HRMS',
//       'reportingManager': 'John Doe',
//       'taskTitle': 'login page',
//       'taskDescription': 'pure frontend login page',
//       'effortsInDays': 4,
//       'taskStatus': '3',
//       'dueDate': '2026-01-28',
//     },
//     {
//       'employeeName': 'Mahesh Kesani',
//       'projectName': 'Hrms mobile',
//       'reportingManager': 'Mahesh Kesani',
//       'taskTitle': 'hrms',
//       'taskDescription': 'TASK UPDATED',
//       'effortsInDays': 3,
//       'taskStatus': '13',
//       'dueDate': '2026-01-29',
//     },
//     {
//       'employeeName': 'Anita Reddy',
//       'projectName': 'Hrms mobile',
//       'reportingManager': 'John Doe',
//       'taskTitle': 'sdfghjk',
//       'taskDescription': 'asdfghjkl',
//       'effortsInDays': 12,
//       'taskStatus': '7',
//       'dueDate': '2026-05-10',
//     },
//     {
//       'employeeName': 'Anita Reddy',
//       'projectName': 'Hrms mobile',
//       'reportingManager': 'Anita Reddy',
//       'taskTitle': 'jadh',
//       'taskDescription': 'dsfd',
//       'effortsInDays': 12,
//       'taskStatus': 'Completed',
//       'dueDate': '1021-01-10',
//     },
//     {
//       'employeeName': 'Anita Reddy',
//       'projectName': 'Hrms mobile',
//       'reportingManager': 'Anita Reddy',
//       'taskTitle': 'HRMS',
//       'taskDescription': 'sdfghj',
//       'effortsInDays': 2,
//       'taskStatus': 'Pending',
//       'dueDate': '2025-10-05',
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadTasks();
//   }

//   Future<void> _loadTasks() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final tasks = await TaskService.getTasks();
//       setState(() {
//         _tasks = tasks;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load tasks: $e')),
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

//   Future<void> _assignTask() async {
//     if (_selectedTaskId == null || _selectedEmployeeId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select both task and employee')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final task = _tasks.firstWhere((t) => t.id == _selectedTaskId);
//       final updatedTask = Task(
//         id: task.id,
//         title: task.title,
//         description: task.description,
//         taskTypeId: task.taskTypeId,
//         projectId: task.projectId,
//         empId: _selectedEmployeeId,
//         statusId: task.statusId,
//         dueDate: task.dueDate,
//         effortsInDays: task.effortsInDays,
//         isActive: task.isActive,
//       );

//       await TaskService.updateTask(_selectedTaskId!, updatedTask);

//       if (mounted) {
//         final employeeName = _employees
//             .firstWhere((e) => e['id'] == _selectedEmployeeId)['name'];
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Task assigned to $employeeName'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context, true);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to assign task: $e'),
//             backgroundColor: Colors.red,
//           ),
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Assign Task'),
//         backgroundColor: const Color(0xFF0AA6B7),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           color: Colors.white,
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Assigned Tasks Table with Horizontal Scroll
//               const Text(
//                 'Assign Task',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 24),
              
//               // Horizontal Scrollable Table
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey[300]!),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     headingRowHeight: 56,
//                     dataRowHeight: 56,
//                     columnSpacing: 24,
//                     headingRowColor: MaterialStateProperty.all(
//                       const Color(0xFFF8F9FA),
//                     ),
//                     border: TableBorder.all(
//                       color: Colors.grey[300]!,
//                       width: 1,
//                     ),
//                     columns: const [
//                       DataColumn(
//                         label: Text(
//                           'Employee Name',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Project Name',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Reporting Manager',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Task Title',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Task Description',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Efforts (Days)',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Task Status',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Due Date',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Actions',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                     rows: _assignedTasks.map((task) {
//                       return DataRow(
//                         cells: [
//                           DataCell(
//                             SizedBox(
//                               width: 140,
//                               child: DropdownButtonFormField<String>(
//                                 initialValue: task['employeeName'],
//                                 decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 8,
//                                   ),
//                                   isDense: true,
//                                 ),
//                                 items: _employees
//                                     .map((emp) => DropdownMenuItem(
//                                           value: emp['name'] as String,
//                                           child: Text(
//                                             emp['name'] as String,
//                                             style: const TextStyle(fontSize: 13),
//                                           ),
//                                         ))
//                                     .toList(),
//                                 onChanged: (value) {},
//                               ),
//                             ),
//                           ),
//                           DataCell(
//                             SizedBox(
//                               width: 100,
//                               child: Text(
//                                 task['projectName'],
//                                 style: const TextStyle(fontSize: 13),
//                               ),
//                             ),
//                           ),
//                           DataCell(
//                             SizedBox(
//                               width: 120,
//                               child: Text(
//                                 task['reportingManager'],
//                                 style: const TextStyle(fontSize: 13),
//                               ),
//                             ),
//                           ),
//                           DataCell(
//                             SizedBox(
//                               width: 100,
//                               child: Text(
//                                 task['taskTitle'],
//                                 style: const TextStyle(fontSize: 13),
//                               ),
//                             ),
//                           ),
//                           DataCell(
//                             SizedBox(
//                               width: 150,
//                               child: Text(
//                                 task['taskDescription'],
//                                 style: const TextStyle(fontSize: 13),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                           DataCell(
//                             SizedBox(
//                               width: 80,
//                               child: TextFormField(
//                                 initialValue: task['effortsInDays'].toString(),
//                                 decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 8,
//                                   ),
//                                   isDense: true,
//                                 ),
//                                 style: const TextStyle(fontSize: 13),
//                               ),
//                             ),
//                           ),
//                           DataCell(
//                             SizedBox(
//                               width: 120,
//                               child: DropdownButtonFormField<String>(
//                                 initialValue: task['taskStatus'],
//                                 decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 8,
//                                   ),
//                                   isDense: true,
//                                 ),
//                                 items: [
//                                   'Pending',
//                                   'In Progress',
//                                   'Completed',
//                                   '2',
//                                   '3',
//                                   '7',
//                                   '13'
//                                 ]
//                                     .map((status) => DropdownMenuItem(
//                                           value: status,
//                                           child: Text(
//                                             status,
//                                             style: const TextStyle(fontSize: 13),
//                                           ),
//                                         ))
//                                     .toList(),
//                                 onChanged: (value) {},
//                               ),
//                             ),
//                           ),
//                           DataCell(
//                             SizedBox(
//                               width: 100,
//                               child: Text(
//                                 task['dueDate'],
//                                 style: const TextStyle(fontSize: 13),
//                               ),
//                             ),
//                           ),
//                           DataCell(
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(
//                                     Icons.edit_outlined,
//                                     size: 18,
//                                   ),
//                                   onPressed: () {
//                                     // Edit functionality
//                                   },
//                                   padding: EdgeInsets.zero,
//                                   constraints: const BoxConstraints(),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 6,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.green,
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   child: const Text(
//                                     'Assigned',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';

class AssignTaskScreen extends StatefulWidget {
  const AssignTaskScreen({super.key});

  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  int? _selectedTaskId;
  int? _selectedEmployeeId;
  bool _isLoading = false;
  
  List<Task> _tasks = [];
  
  final List<Map<String, dynamic>> _employees = [
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

  // Mock data for assigned tasks matching the screenshot
  final List<Map<String, dynamic>> _assignedTasks = [
    {
      'employeeName': 'Mahesh Kesani',
      'projectName': 'HRMS',
      'reportingManager': 'John Doe',
      'taskTitle': 'swachi',
      'taskDescription': 'demo',
      'effortsInDays': 0,
      'taskStatus': 'Completed',
      'dueDate': '2026-01-29',
    },
    {
      'employeeName': 'Anita Reddy',
      'projectName': 'swachify',
      'reportingManager': 'John Doe',
      'taskTitle': 'swachify',
      'taskDescription': 'dgvrx',
      'effortsInDays': 12,
      'taskStatus': 'Completed',
      'dueDate': '2026-01-29',
    },
    {
      'employeeName': 'Anita Reddy',
      'projectName': 'swachify',
      'reportingManager': 'Rakesh Verma',
      'taskTitle': 'main page',
      'taskDescription': 'dcfvgbhnjm',
      'effortsInDays': 1,
      'taskStatus': '2',
      'dueDate': '2026-01-28',
    },
    {
      'employeeName': 'Anil kumar P',
      'projectName': 'HRMS',
      'reportingManager': 'John Doe',
      'taskTitle': 'login page',
      'taskDescription': 'pure frontend login page',
      'effortsInDays': 4,
      'taskStatus': '3',
      'dueDate': '2026-01-28',
    },
    {
      'employeeName': 'Mahesh Kesani',
      'projectName': 'Hrms mobile',
      'reportingManager': 'Mahesh Kesani',
      'taskTitle': 'hrms',
      'taskDescription': 'TASK UPDATED',
      'effortsInDays': 3,
      'taskStatus': '13',
      'dueDate': '2026-01-29',
    },
    {
      'employeeName': 'Anita Reddy',
      'projectName': 'Hrms mobile',
      'reportingManager': 'John Doe',
      'taskTitle': 'sdfghjk',
      'taskDescription': 'asdfghjkl',
      'effortsInDays': 12,
      'taskStatus': '7',
      'dueDate': '2026-05-10',
    },
    {
      'employeeName': 'Anita Reddy',
      'projectName': 'Hrms mobile',
      'reportingManager': 'Anita Reddy',
      'taskTitle': 'jadh',
      'taskDescription': 'dsfd',
      'effortsInDays': 12,
      'taskStatus': 'Completed',
      'dueDate': '1021-01-10',
    },
    {
      'employeeName': 'Anita Reddy',
      'projectName': 'Hrms mobile',
      'reportingManager': 'Anita Reddy',
      'taskTitle': 'HRMS',
      'taskDescription': 'sdfghj',
      'effortsInDays': 2,
      'taskStatus': 'Pending',
      'dueDate': '2025-10-05',
    },
    {
      'employeeName': 'Anita Reddy',
      'projectName': 'Hrms mobile',
      'reportingManager': 'Anita Reddy',
      'taskTitle': 'brsvhjdf',
      'taskDescription': 'fwvrdgd',
      'effortsInDays': 12,
      'taskStatus': '7',
      'dueDate': '2026-05-10',
    },
    {
      'employeeName': 'Anita Reddy',
      'projectName': 'Hrms mobile',
      'reportingManager': 'Anita Reddy',
      'taskTitle': 'cfsf',
      'taskDescription': 'vdfsd',
      'effortsInDays': 10,
      'taskStatus': 'Completed',
      'dueDate': '2026-01-28',
    },
    {
      'employeeName': 'Mahesh Kesani',
      'projectName': 'HRMS',
      'reportingManager': 'Naveen Varma',
      'taskTitle': 'INRFS',
      'taskDescription': 'checking for completed tasks',
      'effortsInDays': 1,
      'taskStatus': 'Completed',
      'dueDate': '2026-01-28',
    },
    {
      'employeeName': 'Suresh Naik',
      'projectName': 'HRMS',
      'reportingManager': 'Suresh Naik',
      'taskTitle': 'HRMS',
      'taskDescription': 'HRMS Task',
      'effortsInDays': 2,
      'taskStatus': 'Completed',
      'dueDate': '2026-01-27',
    },
    {
      'employeeName': 'Anita Reddy',
      'projectName': 'HRMS',
      'reportingManager': 'Anita Reddy',
      'taskTitle': 'HRMS',
      'taskDescription': 'HRMS Improvement',
      'effortsInDays': 1,
      'taskStatus': 'Completed',
      'dueDate': '2026-01-22',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = await TaskService.getTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load tasks: $e')),
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

  Future<void> _assignTask() async {
    if (_selectedTaskId == null || _selectedEmployeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both task and employee')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final task = _tasks.firstWhere((t) => t.id == _selectedTaskId);
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        taskTypeId: task.taskTypeId,
        projectId: task.projectId,
        empId: _selectedEmployeeId,
        statusId: task.statusId,
        dueDate: task.dueDate,
        effortsInDays: task.effortsInDays,
        isActive: task.isActive,
      );

      await TaskService.updateTask(_selectedTaskId!, updatedTask);

      if (mounted) {
        final employeeName = _employees
            .firstWhere((e) => e['id'] == _selectedEmployeeId)['name'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task assigned to $employeeName')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to assign task: $e')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Assign Task'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Task',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          initialValue: _selectedTaskId,
                          decoration: const InputDecoration(
                            labelText: 'Task',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.task),
                          ),
                          items: _tasks
                              .map((task) => DropdownMenuItem(
                                    value: task.id,
                                    child: Text(task.title),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTaskId = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          initialValue: _selectedEmployeeId,
                          decoration: const InputDecoration(
                            labelText: 'Assign To',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          items: _employees
                              .map((employee) => DropdownMenuItem(
                                    value: employee['id'] as int,
                                    child: Text(employee['name'] as String),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedEmployeeId = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedTaskId != null &&
                              _selectedEmployeeId != null &&
                              !_isLoading
                          ? _assignTask
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0AA6B7),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Assign Task',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Assigned Tasks Table
                  const Text(
                    'Assigned Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAssignedTasksTable(),
                ],
              ),
            ),
    );
  }

  Widget _buildAssignedTasksTable() {
    return Container(
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            const Color(0xFFF6F8FB),
          ),
          columns: const [
            DataColumn(label: Text('Employee Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Project Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Reporting Manager', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Task Title', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Task Description', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Efforts (Days)', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Task Status', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Due Date', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: _assignedTasks.map((task) {
            return DataRow(
              cells: [
                DataCell(Text(task['employeeName'])),
                DataCell(Text(task['projectName'])),
                DataCell(Text(task['reportingManager'])),
                DataCell(Text(task['taskTitle'])),
                DataCell(Text(task['taskDescription'])),
                DataCell(Text(task['effortsInDays'].toString())),
                DataCell(Text(task['taskStatus'])),
                DataCell(Text(task['dueDate'])),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () {
                          // Edit functionality
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Assigned',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}