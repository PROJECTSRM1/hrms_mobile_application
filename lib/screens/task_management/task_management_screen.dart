// import 'package:flutter/material.dart';
// import 'create_task_screen.dart';
// import 'assign_task_screen.dart';
// import 'task_history_screen.dart';

// class TaskManagementScreen extends StatefulWidget {
//   const TaskManagementScreen({super.key});

//   @override
//   State<TaskManagementScreen> createState() => _TaskManagementScreenState();
// }

// class _TaskManagementScreenState extends State<TaskManagementScreen> {
//   String _selectedPage = 'create';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Task Management'),
//         backgroundColor: const Color(0xFF0AA6B7),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           // Dropdown Navigation
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 bottom: BorderSide(color: Colors.grey[300]!),
//               ),
//             ),
//             child: DropdownButtonFormField<String>(
//               value: _selectedPage,
//               decoration: InputDecoration(
//                 labelText: 'Select Page',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//               ),
//               isExpanded: true,
//               items: const [
//                 DropdownMenuItem(
//                   value: 'create',
//                   child: Text('Create Task'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'assign',
//                   child: Text('Assign Task'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'history',
//                   child: Text('Task History'),
//                 ),
//               ],
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() {
//                     _selectedPage = value;
//                   });
//                 }
//               },
//             ),
//           ),
//           // Content
//           Expanded(
//             child: _buildSelectedPage(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSelectedPage() {
//     switch (_selectedPage) {
//       case 'create':
//         return const CreateTaskScreen();
//       case 'assign':
//         return const AssignTaskScreen();
//       case 'history':
//         return const TaskHistoryScreen();
//       default:
//         return const CreateTaskScreen();
//     }
//   }
// }