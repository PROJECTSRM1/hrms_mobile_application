import 'package:flutter/material.dart';
import '../../common/widgets/hrms_app_bar.dart';
import '../../screens/task_management/create_task_screen.dart';
import '../../screens/task_management/assign_task_screen.dart';
import '../../screens/task_management/task_board_screen.dart';
import '../../screens/task_management/task_history_screen.dart';
import '../../screens/leave_management/create_leave_screen.dart';
import '../../screens/leave_management/leave_balance_screen.dart';
import '../../screens/leave_management/leave_calendar_screen.dart';
import '../../screens/leave_management/my_approvals_screen.dart';
import '../../screens/leave_management/holiday_calendar_screen.dart';
import '../../screens/leave_management/pending_leave_screen.dart';
import '../../screens/leave_management/leave_history_screen.dart';
import '../../screens/salary/create_payslips_screen.dart';
import '../../screens/salary/salary_revision_screen.dart';
import '../../screens/performance/performance_screen.dart';
import '../../screens/recruiting/recruiting_screen.dart';
import '../../screens/configuration/configuration_screen.dart';
import '../../screens/reports/reports_screen.dart';
import '../../screens/analytics/analytics_screen.dart';
import '../../screens/access_management/access_management_screen.dart';
import '../../screens/settings/settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: HrmsAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// ================= PROFILE HEADER =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFF0AA6B7),
                  child: Icon(Icons.person, size: 32, color: Colors.white),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mahesh Kesani",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text("HR Manager", style: TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// ================= MODULES =================
          _expandableCard(
            context: context,
            icon: Icons.task_alt,
            title: "Task Management",
            children: [
              _subItem(context, "Create Task", () => const CreateTaskScreen()),
              _subItem(context, "Assign Task", () => const AssignTaskScreen()),
              _subItem(context, "Task Board", () => const TaskBoardScreen()),
              _subItem(context, "Task History", () => const TaskHistoryScreen()),
            ],
          ),

          _expandableCard(
            context: context,
            icon: Icons.event_note,
            title: "Leave Management",
            children: [
              _leaveDropdown(context), // ✅ ONLY CHANGE HERE
              _subItem(context, "Leave Balance", () => const LeaveBalanceScreen()),
              _subItem(context, "Leave Calendar", () => const LeaveCalendarScreen()),
              _subItem(context, "My Approvals", () => const MyApprovalsScreen()),
              _subItem(context, "Holiday Calendar", () => const HolidayCalendarScreen()),
            ],
          ),

          _expandableCard(
            context: context,
            icon: Icons.payments,
            title: "Salary",
            children: [
              _subItem(context, "Create Payslips", () => const CreatePayslipsScreen()),
              _subItem(context, "Salary Revision", () => const SalaryRevisionScreen()),
            ],
          ),

          _simpleCard(context, Icons.trending_up, "Performance", () => const PerformanceScreen()),
          _simpleCard(context, Icons.group_add, "Recruiting", () => const RecruitingScreen()),
          _simpleCard(context, Icons.settings_suggest, "Configuration", () => const ConfigurationScreen()),
          _simpleCard(context, Icons.bar_chart, "Reports", () => const ReportsScreen()),
          _simpleCard(context, Icons.analytics, "Analytics", () => const AnalyticsScreen()),
          _simpleCard(context, Icons.lock_outline, "Access Management", () => const AccessManagementScreen()),
          _simpleCard(context, Icons.settings, "Settings", () => const SettingsScreen()),

          const SizedBox(height: 8),

          /// ================= LOGOUT =================
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                "Logout",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent),
              ),
              onTap: () => _showLogoutDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= LEAVE DROPDOWN =================
  static Widget _leaveDropdown(BuildContext context) {
    String value = "Apply";

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(left: 56, right: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Create / Apply Leave"),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  color: const Color(0xFFF6F8FB),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: "Apply", child: Text("Apply Leave")),
                      DropdownMenuItem(value: "Pending", child: Text("Pending Leaves")),
                      DropdownMenuItem(value: "History", child: Text("Leave History")),
                    ],
                    onChanged: (v) {
                      setState(() => value = v!);

                      if (v == "Apply") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ApplyLeaveScreen()));
                      } else if (v == "Pending") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const PendingLeaveScreen()));
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const LeaveHistoryScreen()));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ================= HELPERS =================
  static Widget _expandableCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        leading: Icon(icon, color: const Color(0xFF0AA6B7)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: children,
      ),
    );
  }

  static Widget _subItem(BuildContext context, String title, Widget Function() screen) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      title: Text(title),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen())),
    );
  }

  static Widget _simpleCard(BuildContext context, IconData icon, String title, Widget Function() screen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0AA6B7)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen())),
      ),
    );
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
