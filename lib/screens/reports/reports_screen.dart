import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Reports & Analytics"),
        backgroundColor: const Color(0xFF0AA6B7),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 16),
            _summaryCards(),
            const SizedBox(height: 24),
            _reportsList(),
          ],
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Reports & Analytics",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          "Download, review, and manage all HRMS reports in one place.",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  /// ================= SUMMARY CARDS =================
  Widget _summaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _SummaryCard(title: "Attendance Reports", count: "15", icon: Icons.person),
        _SummaryCard(title: "Payroll Reports", count: "10", icon: Icons.payments),
        _SummaryCard(title: "Performance Reports", count: "8", icon: Icons.trending_up),
        _SummaryCard(title: "Recruitment Reports", count: "12", icon: Icons.description),
      ],
    );
  }

  /// ================= REPORT LIST =================
  Widget _reportsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Available Reports",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        _ReportCard(
          title: "Attendance Summary",
          category: "Attendance",
          generatedBy: "Admin",
          date: "01 Nov 2025",
        ),
        _ReportCard(
          title: "Payroll Report",
          category: "Finance",
          generatedBy: "Finance Head",
          date: "05 Nov 2025",
        ),
        _ReportCard(
          title: "Performance Overview",
          category: "HR",
          generatedBy: "HR Manager",
          date: "03 Nov 2025",
        ),
        _ReportCard(
          title: "Recruitment Summary",
          category: "Recruitment",
          generatedBy: "Recruiter",
          date: "07 Nov 2025",
        ),
      ],
    );
  }
}

/// ================= SUMMARY CARD =================
class _SummaryCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0AA6B7), Color(0xFF056B75)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= REPORT CARD =================
class _ReportCard extends StatelessWidget {
  final String title;
  final String category;
  final String generatedBy;
  final String date;

  const _ReportCard({
    required this.title,
    required this.category,
    required this.generatedBy,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          Row(
            children: [
              _chip(category),
              const Spacer(),
              Text(date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),

          const SizedBox(height: 8),
          Text("Generated by: $generatedBy",
              style: const TextStyle(color: Colors.grey)),

          const Divider(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.download, size: 18, color: Colors.blue),
              const SizedBox(width: 6),
              const Text("Export", style: TextStyle(color: Colors.blue)),
              const SizedBox(width: 20),

              /// VIEW BUTTON
              GestureDetector(
                onTap: () {
                  _showReportDetails(context);
                },
                child: Row(
                  children: const [
                   Icon(Icons.bar_chart, size: 18, color: Colors.blue),

                    Text("View", style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= POPUP DIALOG =================
  void _showReportDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Report Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                _detailRow("Name", title),
                const SizedBox(height: 10),
                _detailRow("Category", category),
                const SizedBox(height: 10),
                _detailRow("Generated By", generatedBy),
                const SizedBox(height: 10),
                _detailRow("Date", date),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.blue, fontSize: 12),
      ),
    );
  }
}
