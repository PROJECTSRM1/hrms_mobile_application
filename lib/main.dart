import 'package:flutter/material.dart';
import 'features/auth/screens/splash_screen.dart';

void main() {
  runApp(const HrmsApp());
}

class HrmsApp extends StatelessWidget {
  const HrmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}








// import 'package:flutter/material.dart';
// import 'screens/task_managment/create_task_screen.dart';
// import 'screens/task_managment/assign_task_screen.dart';
// import 'screens/task_managment/task_board_screen.dart';
// import 'screens/task_managment/task_history_screen.dart';

// void main() {
//   runApp(const HrmsApp());
// }

// class HrmsApp extends StatelessWidget {
//   const HrmsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'HRMS Mobile Application',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF0AA6B7),
//         ),
//         useMaterial3: true,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F8FB),
//       appBar: AppBar(
//         title: const Text('HRMS - Task Management'),
//         backgroundColor: const Color(0xFF0AA6B7),
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           children: [
//             _buildMenuCard(
//               context,
//               'Create Task',
//               Icons.add_task,
//               Colors.blue,
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CreateTaskScreen(),
//                 ),
//               ),
//             ),
//             _buildMenuCard(
//               context,
//               'Assign Task',
//               Icons.assignment_ind,
//               Colors.green,
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const AssignTaskScreen(),
//                 ),
//               ),
//             ),
//             _buildMenuCard(
//               context,
//               'Task Board',
//               Icons.dashboard,
//               Colors.orange,
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const TaskBoardScreen(),
//                 ),
//               ),
//             ),
//             _buildMenuCard(
//               context,
//               'Task History',
//               Icons.history,
//               Colors.purple,
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const TaskHistoryScreen(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: color.withValues(alpha: 0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 size: 48,
//                 color: color,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }