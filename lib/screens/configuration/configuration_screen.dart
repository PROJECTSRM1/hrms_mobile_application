import 'package:flutter/material.dart';
import 'departments_screen.dart';
import 'designations_screen.dart';
import 'roles_screen.dart';
import 'interview_stages_screen.dart';
import 'projects_screen.dart';
import 'project_modules_screen.dart'; // ✅ NEW

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Config"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 1,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F4C5C),
                Color(0xFF0AA6B7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            icon: Icons.apartment,
            title: 'Departments',
            subtitle: 'Create and manage departments',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DepartmentsScreen(),
                ),
              );
            },
          ),
          _buildCard(
            icon: Icons.badge,
            title: 'Designations',
            subtitle: 'Manage job designations',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DesignationsScreen(),
                ),
              );
            },
          ),
          _buildCard(
            icon: Icons.people_outline,
            title: 'Roles',
            subtitle: 'Configure system roles & permissions',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RolesScreen(),
                ),
              );
            },
          ),
          _buildCard(
            icon: Icons.layers_outlined,
            title: 'Interview Stages',
            subtitle: 'Define interview workflow stages',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InterviewStagesScreen(),
                ),
              );
            },
          ),
          _buildCard(
            icon: Icons.assignment_outlined,
            title: 'Projects',
            subtitle: 'Manage company projects',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProjectsScreen(),
                ),
              );
            },
          ),

          /// ✅ NEW: PROJECT MODULES
          _buildCard(
            icon: Icons.view_module_outlined,
            title: 'Project Modules',
            subtitle: 'Configure modules under projects',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProjectModulesScreen(),
                ),
              );
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
          child: Icon(
            icon,
            color: const Color(0xFF0AA6B7),
          ),
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
