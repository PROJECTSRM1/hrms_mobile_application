import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                    child: Icon(Icons.person, size: 32),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mahesh Kesani",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "HR Manager",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// ================= MODULE LIST =================
            Expanded(
              child: ListView(
                children: [
                  _expandableCard(
                    icon: Icons.task_alt,
                    title: "Task Management",
                    children: [
                      _subItem("Create Task"),
                      _subItem("Assign Task"),
                      _subItem("Task Board"),
                      _subItem("Task History"),
                    ],
                  ),

                  _expandableCard(
                    icon: Icons.event_note,
                    title: "Leave Management",
                    children: [
                      _subItem("Create / Apply Leave"),
                      _subItem("Leave Balance"),
                      _subItem("Leave Calendar"),
                      _subItem("My Approvals"),
                      _subItem("Holiday Calendar"),
                    ],
                  ),

                  _expandableCard(
                    icon: Icons.payments,
                    title: "Salary",
                    children: [
                      _subItem("Create Payslips"),
                      _subItem("Salary Revision"),
                    ],
                  ),

                  _simpleCard(Icons.trending_up, "Performance"),
                  _simpleCard(Icons.group_add, "Recruiting"),
                  _simpleCard(Icons.settings_suggest, "Configuration"),
                  _simpleCard(Icons.bar_chart, "Reports"),
                  _simpleCard(Icons.analytics, "Analytics"),
                  _simpleCard(Icons.lock_outline, "Access Management"),
                  _simpleCard(Icons.settings, "Settings"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// ================= LOGOUT =================
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= EXPANDABLE CARD =================
  Widget _expandableCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: const Color(0xFF0AA6B7)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: children,
      ),
    );
  }

  /// ================= SUB MENU ITEM (NO ARROW) =================
  Widget _subItem(String title) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      title: Text(title),
      onTap: () {
      },
    );
  }

  /// ================= SIMPLE CARD (NO ARROW) =================
  Widget _simpleCard(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0AA6B7)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onTap: () {
        },
      ),
    );
  }
}
