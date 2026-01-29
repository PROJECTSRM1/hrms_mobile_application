import 'package:flutter/material.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Configuration'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            icon: Icons.business,
            title: 'Company Settings',
            subtitle: 'Configure company information',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.account_tree,
            title: 'Department Management',
            subtitle: 'Manage departments and hierarchy',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.work_outline,
            title: 'Designation Setup',
            subtitle: 'Configure job designations',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.schedule,
            title: 'Work Schedules',
            subtitle: 'Set up work shifts and timings',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.category,
            title: 'Leave Types',
            subtitle: 'Configure leave categories',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.currency_rupee,
            title: 'Salary Components',
            subtitle: 'Define salary structure',
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