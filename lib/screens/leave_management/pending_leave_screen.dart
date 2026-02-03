import 'package:flutter/material.dart';
import 'leave_api_service.dart';

class PendingLeaveScreen extends StatelessWidget {
  const PendingLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Leaves"),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF6F8FB),
      body: FutureBuilder(
        future: LeaveApiService.getPendingLeaves(1),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final leaves = snapshot.data as List;

          if (leaves.isEmpty) {
            return const Center(child: Text("No pending leaves"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: leaves.length,
            itemBuilder: (_, i) {
              final l = leaves[i];
              return _card(
                title: l['leave_type'],
                subtitle: "${l['start_date']} → ${l['end_date']}",
                status: l['status_name'],
              );
            },
          );
        },
      ),
    );
  }

  Widget _card({required String title, required String subtitle, required String status}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle),
          const SizedBox(height: 6),
          Chip(label: Text(status), backgroundColor: Colors.orange.shade100),
        ],
      ),
    );
  }
}
