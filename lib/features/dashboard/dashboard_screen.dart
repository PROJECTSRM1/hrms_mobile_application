import 'package:flutter/material.dart';
import '../../common/widgets/hrms_app_bar.dart';

import '../../services/dashboard_service.dart';
import '../../models/dashboard_models.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardData? dashboard;
  List<Activity> activities = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

 Future<void> _loadDashboard() async {
  try {
    final dash = await DashboardService.getDashboardSummary();
    final acts = await DashboardService.getRecentActivities();

    if (!mounted) return;

    setState(() {
      dashboard = dash;
      activities = acts;
      loading = false;
    });
  } catch (e) {
    print("LOAD ERROR: $e");
    setState(() => loading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        appBar: HrmsAppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (dashboard == null) {
      return const Scaffold(
        appBar: HrmsAppBar(),
        body: Center(child: Text("No dashboard data available")),
      );
    }

    return Scaffold(
      appBar: const HrmsAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= CARDS =================
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.25,
              children: [
                _DashboardCard(
                  title: "Total Employees",
                  value: dashboard!.totalEmployees.count.toString(),
                  icon: Icons.people_outline,
                  color: const Color(0xFF607D9B),
                ),
                _DashboardCard(
                  title: "Active Employees",
                  value: dashboard!.activeEmployees.count.toString(),
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF6FA27A),
                ),
                _DashboardCard(
                  title: "Inactive Employees",
                  value: dashboard!.inactiveEmployees.count.toString(),
                  icon: Icons.block,
                  color: const Color(0xFFC23A48),
                ),
                _DashboardCard(
                  title: "Uninformed Leaves",
                  value: dashboard!.uninformedLeaves.count.toString(),
                  icon: Icons.warning_amber_outlined,
                  color: const Color(0xFFC9A633),
                ),
              ],
            ),

            const SizedBox(height: 32),

            /// ================= RECENT ACTIVITIES =================
            const Text(
              "Recent Activities",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            _RecentActivitiesTable(activities: activities),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          /// HEADING (FIXED HEIGHT → ALL SAME SIZE)
          SizedBox(
            height: 22,
            child: Center(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// ICON + NUMBER
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 42, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivitiesTable extends StatelessWidget {
  final List<Activity> activities;

  const _RecentActivitiesTable({required this.activities});

  String formatDate(String ts) {
    final d = DateTime.parse(ts);
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: activities.isEmpty
          ? const Center(
              child: Text(
                "No recent activity found",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              children: activities.map((a) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(child: Text("${a.firstName} ${a.lastName}")),
                      Expanded(child: Text(a.description)),
                      Expanded(child: Text(formatDate(a.createdDate))),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
