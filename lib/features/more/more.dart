import 'package:flutter/material.dart';
import '../../common/widgets/hrms_app_bar.dart';
import '../../services/auth_service.dart';

import '../../screens/task_management/create_task_screen.dart';
import '../../screens/task_management/assign_task_screen.dart';
import '../../screens/task_management/task_board_screen.dart';
import '../../screens/task_management/task_history_screen.dart';

import '../../screens/leave_management/create_leave_screen.dart';
import '../../screens/leave_management/pending_leave_screen.dart';
import '../../screens/leave_management/leave_history_screen.dart';
import '../../screens/leave_management/leave_balance_screen.dart';
import '../../screens/leave_management/leave_calendar_screen.dart';
import '../../screens/leave_management/my_approvals_screen.dart';
import '../../screens/leave_management/holiday_calendar_screen.dart';

import '../../screens/salary/create_payslips_screen.dart';
import '../../screens/salary/salary_revision_screen.dart';
import '../../screens/performance/performance_screen.dart';
import '../../screens/recruiting/recruiting_screen.dart';
import '../../screens/configuration/configuration_screen.dart';
import '../../screens/reports/reports_screen.dart';
import '../../screens/analytics/analytics_screen.dart';
import '../../screens/access_management/access_management_screen.dart';
import '../../screens/settings/settings_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  /// controls which expansion tile is open
  int _openedIndex = -1;

  /// profile
  String _name = '';
  String _role = '';
  bool _profileLoading = true;

  /// leave dropdown value
  String _leaveAction = 'Apply';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await AuthService.getProfile();
    if (!mounted) return;

    if (profile != null) {
      final first = profile['first_name'] ?? '';
      final last = profile['last_name'] ?? '';
      final roleId = profile['role_id'];

      setState(() {
        _name = '$first $last'.trim();
        _role = _mapRole(roleId);
        _profileLoading = false;
      });
    } else {
      setState(() => _profileLoading = false);
    }
  }

  String _mapRole(dynamic roleId) {
    switch (roleId) {
      case 1:
        return 'Admin';
      case 2:
        return 'Manager';
      case 3:
        return 'HR Manager';
      case 4:
        return 'Employee';
      default:
        return 'Employee';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: HrmsAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// ================= PROFILE =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFF0AA6B7),
                  child: Icon(Icons.person, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 12),
                _profileLoading
                    ? const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12, width: 120, child: LinearProgressIndicator()),
                          SizedBox(height: 6),
                          SizedBox(height: 10, width: 80, child: LinearProgressIndicator()),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _name.isEmpty ? '—' : _name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(_role, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// ================= TASK MANAGEMENT =================
          _expandableCard(
            index: 0,
            icon: Icons.task_alt,
            title: "Task Management",
            children: [
              _subItem(context, "Create Task", () => const CreateTaskScreen()),
              _subItem(context, "Assign Task", () => const AssignTaskScreen()),
              _subItem(context, "Task Board", () => const TaskBoardScreen()),
              _subItem(context, "Task History", () => const TaskHistoryScreen()),
            ],
          ),

          /// ================= LEAVE MANAGEMENT =================
          _expandableCard(
            index: 1,
            icon: Icons.event_note,
            title: "Leave Management",
            children: [
              _leaveDropdown(context),
              _subItem(context, "Leave Balance", () => const LeaveBalanceScreen()),
              _subItem(context, "Leave Calendar", () => const LeaveCalendarScreen()),
              _subItem(context, "My Approvals", () => const MyApprovalsScreen()),
              _subItem(context, "Holiday Calendar", () => const HolidayCalendarScreen()),
            ],
          ),

          /// ================= SALARY =================
          _expandableCard(
            index: 2,
            icon: Icons.payments,
            title: "Salary",
            children: [
              _subItem(context, "Create Payslips", () => const CreatePayslipsScreen()),
              _subItem(context, "Salary Revision", () => const SalaryRevisionScreen()),
            ],
          ),

          _simpleCard(context, Icons.trending_up, "Performance", () => const PerformanceScreen()),
          _simpleCard(context, Icons.group_add, "Recruiting", () => const RecruitingScreen()),
          _simpleCard(context, Icons.settings_suggest, "Config", () => const ConfigurationScreen()),
          _simpleCard(context, Icons.bar_chart, "Reports", () => const ReportsScreen()),
          _simpleCard(context, Icons.analytics, "Analytics", () => const AnalyticsScreen()),
          _simpleCard(context, Icons.lock_outline, "Access Management", () => const AccessManagementScreen()),
          _simpleCard(context, Icons.settings, "Settings", () => const SettingsScreen()),

          const SizedBox(height: 8),

          /// ================= LOGOUT =================
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
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

  /// ================= EXPANDABLE CARD =================
  Widget _expandableCard({
    required int index,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        key: ValueKey(index),
        leading: Icon(icon, color: const Color(0xFF0AA6B7)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        initiallyExpanded: _openedIndex == index,
        onExpansionChanged: (expanded) {
          setState(() {
            _openedIndex = expanded ? index : -1;
          });
        },
        children: children,
      ),
    );
  }

  /// ================= SUB ITEM =================
  Widget _subItem(BuildContext context, String title, Widget Function() screen) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      title: Text(title),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen()),
      ),
    );
  }

  /// ================= SIMPLE CARD =================
  Widget _simpleCard(BuildContext context, IconData icon, String title, Widget Function() screen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0AA6B7)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen()),
        ),
      ),
    );
  }

  /// ================= LEAVE DROPDOWN (NEAT + NAVIGATION) =================
  Widget _leaveDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 56, right: 16, bottom: 8),
      child: DropdownButtonFormField<String>(
        initialValue: _leaveAction,
        isExpanded: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        items: const [
          DropdownMenuItem(value: "Apply", child: Text("Apply Leave")),
          DropdownMenuItem(value: "Pending", child: Text("Pending Leaves")),
          DropdownMenuItem(value: "History", child: Text("Leave History")),
        ],
        onChanged: (value) {
          if (value == null) return;
          setState(() => _leaveAction = value);

          Widget screen;
          switch (value) {
            case "Apply":
              screen = const ApplyLeaveScreen();
              break;
            case "Pending":
              screen = const PendingLeaveScreen();
              break;
            case "History":
              screen = const LeaveHistoryScreen();
              break;
            default:
              return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
      ),
    );
  }

  /// ================= LOGOUT =================
  void _showLogoutDialog(BuildContext context) {
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
