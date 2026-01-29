import 'package:flutter/material.dart';

class RecruitingScreen extends StatelessWidget {
  const RecruitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Recruiting'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            icon: Icons.work,
            title: 'Job Postings',
            subtitle: 'Create and manage job postings',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.person_search,
            title: 'Candidates',
            subtitle: 'View and manage candidates',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.event_available,
            title: 'Interview Schedule',
            subtitle: 'Schedule and manage interviews',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.description,
            title: 'Applications',
            subtitle: 'Review job applications',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.check_circle,
            title: 'Offer Letters',
            subtitle: 'Generate and send offer letters',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.insights,
            title: 'Recruitment Analytics',
            subtitle: 'View recruitment metrics',
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