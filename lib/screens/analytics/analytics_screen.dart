import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            icon: Icons.people_alt,
            title: 'Employee Analytics',
            subtitle: 'Workforce insights and trends',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.show_chart,
            title: 'Attendance Analytics',
            subtitle: 'Attendance patterns and insights',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.trending_up,
            title: 'Performance Analytics',
            subtitle: 'Performance trends and metrics',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.attach_money,
            title: 'Payroll Analytics',
            subtitle: 'Salary trends and distributions',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.hourglass_empty,
            title: 'Leave Analytics',
            subtitle: 'Leave patterns and utilization',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.business_center,
            title: 'Recruitment Analytics',
            subtitle: 'Hiring metrics and insights',
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
            color: const Color(0xFF0AA6B7).withValues(alpha: 0.1),
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