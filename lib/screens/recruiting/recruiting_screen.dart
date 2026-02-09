// lib/screens/recruiting/recruiting_screen.dart

import 'package:flutter/material.dart';
import 'job_listings_screen.dart';
import 'candidates_screen.dart';
import 'interview_schedule_screen.dart';

class RecruitingScreen extends StatelessWidget {
  const RecruitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Recruitment Center'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context: context,
            icon: Icons.work_outline,
            title: 'Job Listings',
            subtitle: 'Manage job openings and postings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobListingsScreen(),
                ),
              );
            },
          ),
          _buildCard(
            context: context,
            icon: Icons.person_search,
            title: 'Candidates Applied',
            subtitle: 'View and manage candidate applications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CandidatesScreen(),
                ),
              );
            },
          ),
          _buildCard(
            context: context,
            icon: Icons.event_available,
            title: 'Scheduled Interviews',
            subtitle: 'Schedule and track interview progress',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InterviewScheduleScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0AA6B7).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0AA6B7), size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF0AA6B7),
        ),
        onTap: onTap,
      ),
    );
  }
}