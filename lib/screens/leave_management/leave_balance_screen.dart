import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../common/widgets/hrms_app_bar.dart';

class LeaveBalanceScreen extends StatefulWidget {
  const LeaveBalanceScreen({super.key});

  @override
  State<LeaveBalanceScreen> createState() => _LeaveBalanceScreenState();
}

class _LeaveBalanceScreenState extends State<LeaveBalanceScreen> {
  late Future<LeaveBalanceResponse> future;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    future = _fetchLeaveBalance();
  }

  // ================= API =================

  Future<LeaveBalanceResponse> _fetchLeaveBalance() async {
    final uri = Uri.parse(
      'https://hrms-be-ppze.onrender.com/leave/balance'
      '?emp_id=1&year=$selectedYear&limit=50&offset=0',
    );

    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return LeaveBalanceResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load leave balance');
    }
  }

  // ================= PDF EXPORT =================

  Future<void> _exportPdf(LeaveBalanceResponse data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Leave Balance – $selectedYear',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 16),
            ...data.leaves.map(
              (l) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Text(
                  '${l.leaveType}: Balance ${l.balance}, '
                  'Consumed ${l.consumed}, Granted ${l.granted}',
                ),
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),

      /// ✅ HRMS THEMED APP BAR
      appBar: const HrmsAppBar(),

      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => future = _fetchLeaveBalance());
          await future;
        },
        child: FutureBuilder<LeaveBalanceResponse>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final data = snapshot.data!;
            final totalBalance =
                data.leaves.fold<int>(0, (s, e) => s + e.balance);
            final totalGranted =
                data.leaves.fold<int>(0, (s, e) => s + e.granted);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _topFilters(),
                const SizedBox(height: 16),
                _summaryCard(totalBalance, totalGranted),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: data.leaves.map(_leaveCard).toList(),
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF'),
                  onPressed: () => _exportPdf(data),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget _topFilters() {
    final years = List.generate(5, (i) => DateTime.now().year - i);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedYear,
                isExpanded: true,
                items: years
                    .map(
                      (y) => DropdownMenuItem(
                        value: y,
                        child: Text(y.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => selectedYear = v);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0AA6B7),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          onPressed: () {
            setState(() => future = _fetchLeaveBalance());
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _summaryCard(int balance, int granted) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0AA6B7), Color(0xFF0891A1)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Total Available Leaves',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            balance.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'out of $granted days',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _leaveCard(LeaveBalance leave) {
    final percent = leave.granted == 0
        ? 0.0
        : (leave.balance / leave.granted).clamp(0.0, 1.0);

    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            leave.leaveType,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            'Balance: ${leave.balance}',
            style: const TextStyle(
              color: Color(0xFF0AA6B7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor:
                const AlwaysStoppedAnimation(Color(0xFF0AA6B7)),
          ),
          const SizedBox(height: 8),
          Text(
            'Consumed: ${leave.consumed} / Granted: ${leave.granted}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

/* ================= MODELS ================= */

class LeaveBalanceResponse {
  final int empId;
  final int year;
  final List<LeaveBalance> leaves;

  LeaveBalanceResponse({
    required this.empId,
    required this.year,
    required this.leaves,
  });

  factory LeaveBalanceResponse.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceResponse(
      empId: (json['emp_id'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      leaves: (json['leaves'] as List)
          .map((e) => LeaveBalance.fromJson(e))
          .toList(),
    );
  }
}

class LeaveBalance {
  final int leaveTypeId;
  final String leaveType;
  final int granted;
  final int consumed;
  final int balance;

  LeaveBalance({
    required this.leaveTypeId,
    required this.leaveType,
    required this.granted,
    required this.consumed,
    required this.balance,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      leaveTypeId: (json['leave_type_id'] as num).toInt(),
      leaveType: json['leave_type'] ?? '',
      granted: (json['granted'] as num).toInt(),
      consumed: (json['consumed'] as num).toInt(),
      balance: (json['balance'] as num).toInt(),
    );
  }
}
