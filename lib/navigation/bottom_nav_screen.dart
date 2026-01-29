import 'package:flutter/material.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/employees/employees_screen.dart';
import '../features/attendance/attendance_screen.dart';
import '../features/payroll/payroll_screen.dart';
import '../features/more/more.dart';


class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    EmployeesScreen(),
    AttendanceScreen(),
    PayrollScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF0AA6B7),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Employees",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Attendance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: "Payroll",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "More",
          ),
        ],
      ),
    );
  }
}