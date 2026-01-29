import 'package:flutter/material.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Performance'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            icon: Icons.assessment,
            title: 'Performance Reviews',
            subtitle: 'View and manage employee reviews',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.star_rate,
            title: 'Performance Ratings',
            subtitle: 'Rate employee performance',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.trending_up,
            title: 'Goal Tracking',
            subtitle: 'Track employee goals and objectives',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.feedback,
            title: 'Feedback Management',
            subtitle: 'Provide and view feedback',
            onTap: () {},
          ),
          _buildCard(
            icon: Icons.bar_chart,
            title: 'Performance Reports',
            subtitle: 'Generate performance reports',
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