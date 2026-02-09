import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../services/auth_service.dart';

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key});

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  int? employeeId;
  int? selectedMonth;
  int? selectedYear;

  bool loading = false;
  String? error;
  Map<String, dynamic>? payslip;

  final months = const {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec",
  };

  final years = const {
    4: "2024",
    5: "2025",
    6: "2026",
  };

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
  }

  Future<void> _loadEmployeeId() async {
    employeeId = await AuthService.getEmployeeId();

    /// ✅ Default latest month & year
    final now = DateTime.now();
    selectedMonth ??= now.month;
    selectedYear ??= now.year;

    setState(() {});
    await fetchPayslip();
  }

  /* ================= FETCH PAYSLIP ================= */

  Future<void> fetchPayslip() async {
    if (employeeId == null || selectedMonth == null || selectedYear == null) {
      return;
    }

    setState(() {
      loading = true;
      error = null;
      payslip = null;
    });

    final token = await AuthService.getToken();
    final url =
        "https://hrms-be-ppze.onrender.com/payroll/calculate/$employeeId"
        "?month_id=$selectedMonth&year_id=$selectedYear";

    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {
          "accept": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        payslip = jsonDecode(res.body);
      } else {
        error = "No payslip found";
      }
    } catch (_) {
      error = "Something went wrong";
    } finally {
      loading = false;
      setState(() {});
    }
  }

  /* ================= DOWNLOAD PDF (MATCH UI EXACTLY) ================= */

  Future<void> downloadPayslip() async {
    if (payslip == null) return;

    final pdf = pw.Document();

    final e = payslip!["employee"];
    final earn = payslip!["earnings"];
    final ded = payslip!["deductions"];
    final att = payslip!["attendance"];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            /// ===== HEADER =====
            pw.Center(
              child: pw.Text(
               "Payslip for the month of ${months[selectedMonth]} ${years[selectedYear]}",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 16),

            /// ===== EMPLOYEE DETAILS (YELLOW BLOCK) =====
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.yellow100,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Employee details",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),

                  _pdfTwoCol("Name", "${e["first_name"]} ${e["last_name"]}",
                      "Designation", e["designation_name"]),
                  _pdfTwoCol("Work Location", e["work_location"],
                      "Joining Date", e["join_date"]),
                  _pdfTwoCol("Bank Name", e["bank_name"],
                      "Bank Account No", e["bank_account_no"]),
                  _pdfTwoCol("PAN", e["pan"], "UAN", e["uan"]),
                  _pdfTwoCol("PF Account No", e["pf_ac_no"],
                      "Paid Days", att["paid_days"]),
                  _pdfTwoCol("LOP Days", att["lop_days"], "", ""),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            /// ===== EARNINGS + DEDUCTIONS (SIDE BY SIDE) =====
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(child: _pdfAmountCard("Details", earn)),
                pw.SizedBox(width: 12),
                pw.Expanded(child: _pdfAmountCard("Details", ded)),
              ],
            ),

            pw.SizedBox(height: 20),

            /// ===== NET PAY (BLUE CARD) =====
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.lightBlue100,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Net Pay",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    "₹${payslip!["net_salary"]}",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    /// ===== SAVE TO ANDROID DOWNLOADS =====
    final dir = Directory('/storage/emulated/0/Download');
    final fileName =
        "Payslip_${e["first_name"]}_${months[selectedMonth]}_$selectedYear.pdf";
    final file = File("${dir.path}/$fileName");

    await file.writeAsBytes(await pdf.save(), flush: true);

    /// Force refresh Downloads
    await const MethodChannel('media_scanner')
        .invokeMethod('scanFile', {'path': file.path});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Successfully downloaded"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /* ================= PDF HELPERS ================= */

  pw.Widget _pdfTwoCol(
      String l1, dynamic v1, String l2, dynamic v2) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text("$l1: ${v1 ?? '-'}")),
          pw.Expanded(child: pw.Text("$l2: ${v2 ?? '-'}")),
        ],
      ),
    );
  }

  pw.Widget _pdfAmountCard(String title, Map<String, dynamic> data) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Details",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("Amount (₹)"),
            ],
          ),
          pw.Divider(),
          ...data.entries.map(
            (e) => pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(e.key),
                pw.Text("₹${e.value ?? 0}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* ================= UI (UNCHANGED) ================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payslip")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _filters(),
            const SizedBox(height: 16),
            Expanded(child: _content()),
          ],
        ),
      ),
    );
  }

  Widget _filters() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: payslip == null ? null : downloadPayslip,
          icon: const Icon(Icons.download),
          label: const Text("Download"),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: "Month"),
            value: selectedMonth,
            items: months.entries
                .map((e) =>
                    DropdownMenuItem(value: e.key, child: Text(e.value)))
                .toList(),
            onChanged: (v) {
              selectedMonth = v;
              fetchPayslip();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: "Year"),
            value: selectedYear,
            items: years.entries
                .map((e) =>
                    DropdownMenuItem(value: e.key, child: Text(e.value)))
                .toList(),
            onChanged: (v) {
              selectedYear = v;
              fetchPayslip();
            },
          ),
        ),
      ],
    );
  }

  Widget _content() {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) {
      return Center(
          child: Text(error!, style: const TextStyle(color: Colors.red)));
    }
    if (payslip == null) {
      return const Center(child: Text("Select month & year"));
    }

    final e = payslip!["employee"];
    final earn = payslip!["earnings"];
    final ded = payslip!["deductions"];
    final att = payslip!["attendance"];

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Payslip for the month of ${months[selectedMonth]} $selectedYear",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _employeeDetailsCard(e, att),
          const SizedBox(height: 12),

          /// ✅ EARNINGS (ROW 1)
          _amountCard("Earnings", earn),

          const SizedBox(height: 12),

          /// ✅ DEDUCTIONS (ROW 2)
          _amountCard("Deductions", ded),

          const SizedBox(height: 16),

          _netPayCard(),
        ],
      ),
    );
  }
  Widget _employeeDetailsCard(Map<String, dynamic> e, Map<String, dynamic> att) {
    return Card(
      color: const Color(0xFFFFF7D6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Employee details",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            _twoCol("Name", e["first_name"], "Designation", e["designation_name"]),
            _twoCol("Work Location", e["work_location"],
                "Joining Date", e["join_date"]),
            _twoCol("Bank Name", e["bank_name"],
                "Bank Account No", e["bank_account_no"]),
            _twoCol("PAN", e["pan"], "UAN", e["uan"]),
            _twoCol("PF Account No", e["pf_ac_no"],
                "Paid Days", att["paid_days"]),
            _twoCol("LOP Days", att["lop_days"], "", ""),
          ],
        ),
      ),
    );
  }

  Widget _twoCol(String l1, dynamic v1, String l2, dynamic v2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: _labelValue(l1, v1)),
          Expanded(child: _labelValue(l2, v2)),
        ],
      ),
    );
  }

  Widget _labelValue(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.black54, fontSize: 12)),
        Text(value?.toString() ?? "-",
            style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _amountCard(String title, Map<String, dynamic> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Details", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Amount (₹)"),
              ],
            ),
            const Divider(),
            ...data.entries.map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key),
                  Text("₹${e.value ?? 0}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _netPayCard() {
  return SizedBox(
    width: double.infinity, // ✅ FULL WIDTH
    child: Card(
      color: const Color(0xFFE6F6FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, // ✅ RIGHT ALIGN
          children: [
            const Text(
              "Net Pay",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "₹${payslip!["net_salary"]}",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "(Rupees Only)",
              style: TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }}