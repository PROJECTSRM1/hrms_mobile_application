import 'package:flutter/material.dart';
import 'designations_screen.dart';


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
            icon: Icons.apartment,
            title: 'Departments',
            subtitle: 'Create and manage departments',
            onTap: () {
              // Navigate to Departments screen
            },
          ),
          _buildCard(
            icon: Icons.badge,
            title: 'Designations',
            subtitle: 'Manage job designations',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DesignationsScreen()),
              );
            },
          ),

          _buildCard(
            icon: Icons.people_outline,
            title: 'Roles',
            subtitle: 'Configure system roles & permissions',
            onTap: () {
              // Navigate to Roles screen
            },
          ),
          _buildCard(
            icon: Icons.layers_outlined,
            title: 'Interview Stages',
            subtitle: 'Define interview workflow stages',
            onTap: () {
              // Navigate to Interview Stages screen
            },
          ),
          _buildCard(
            icon: Icons.assignment_outlined,
            title: 'Projects',
            subtitle: 'Manage company projects',
            onTap: () {
              // Navigate to Projects screen
            },
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
