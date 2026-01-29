import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            icon: Icons.people,
            title: 'Employee Reports',
            subtitle: 'Generate employee-related reports',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.access_time,
            title: 'Attendance Reports',
            subtitle: 'View attendance statistics',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.event_busy,
            title: 'Leave Reports',
            subtitle: 'Analyze leave patterns',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.payment,
            title: 'Payroll Reports',
            subtitle: 'Generate payroll summaries',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.task,
            title: 'Task Reports',
            subtitle: 'Track task completion',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.assessment,
            title: 'Performance Reports',
            subtitle: 'Review performance metrics',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0AA6B7).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0AA6B7)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}