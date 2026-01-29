import 'package:flutter/material.dart';

class AccessManagementScreen extends StatelessWidget {
  const AccessManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Access Management'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            icon: Icons.admin_panel_settings,
            title: 'User Roles',
            subtitle: 'Manage user roles and permissions',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.security,
            title: 'Permissions',
            subtitle: 'Configure access permissions',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.group,
            title: 'User Groups',
            subtitle: 'Create and manage user groups',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.lock,
            title: 'Access Control',
            subtitle: 'Control module access',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.history,
            title: 'Access Logs',
            subtitle: 'View access history',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.vpn_key,
            title: 'Password Policy',
            subtitle: 'Configure password requirements',
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