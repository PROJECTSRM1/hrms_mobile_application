import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  /* ================= LOAD EMPLOYEE ID ================= */

  Future<void> _loadEmployeeId() async {
    final id = await AuthService.getEmployeeId();
    setState(() => employeeId = id);
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
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "accept": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          payslip = jsonDecode(response.body);
        });
      } else {
        setState(() {
          error = "No payslip found";
        });
      }
    } catch (_) {
      setState(() {
        error = "Something went wrong";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  /* ================= DOWNLOAD ================= */

  void downloadPayslip() {
    if (payslip == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payslip download started")),
    );

    // Later:
    // - Generate PDF
    // - Or call backend download API
  }

  /* ================= UI ================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D9488),
        title: const Text("Payslip"),
      ),
      body: employeeId == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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

  /* ================= FILTERS + DOWNLOAD ================= */

  Widget _filters() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// DOWNLOAD BUTTON (LIKE WEB)
        SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: payslip == null ? null : downloadPayslip,
            icon: const Icon(Icons.download, size: 18),
            label: const Text("Download"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        /// MONTH
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: "Month",
              border: OutlineInputBorder(),
            ),
            items: months.entries
                .map(
                  (e) =>
                      DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (v) {
              selectedMonth = v;
              fetchPayslip();
            },
          ),
        ),

        const SizedBox(width: 12),

        /// YEAR
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: "Year",
              border: OutlineInputBorder(),
            ),
            items: years.entries
                .map(
                  (e) =>
                      DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
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
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Text(
          error!,
          style: const TextStyle(color: Colors.red, fontSize: 15),
        ),
      );
    }

    if (payslip == null) {
      return const Center(child: Text("Select month & year"));
    }

    return _payslipDetails();
  }

  /* ================= PAYSLIP DETAILS ================= */

  Widget _payslipDetails() {
    final employee = payslip!["employee"] ?? {};
    final earnings = payslip!["earnings"] ?? {};
    final deductions = payslip!["deductions"] ?? {};
    final attendance = payslip!["attendance"] ?? {};

    return SingleChildScrollView(
      child: Column(
        children: [
          _employeeDetailsCard(employee),

          _sectionCard("Earnings", {
            "Basic": earnings["basic"],
            "HRA": earnings["hra"],
            "Medical Allowance": earnings["medical_allowance"],
            "Special Allowance": earnings["special_allowance"],
            "Arrears": earnings["arrears"],
            "Gross After LOP": earnings["gross_after_lop"],
          }),

          _sectionCard("Deductions", {
            "PF": deductions["pf"],
            "ESIC": deductions["esic"],
            "PT": deductions["pt"],
            "TDS": deductions["tds"],
            "Other": deductions["other_deductions"],
            "Total Deductions": deductions["total_deductions"],
          }),

          _sectionCard("Attendance", {
            "Total Days": attendance["total_days"],
            "Paid Days": attendance["paid_days"],
            "LOP Days": attendance["lop_days"],
          }),

          _netPayCard(),
        ],
      ),
    );
  }

  /* ================= EMPLOYEE DETAILS ================= */

  Widget _employeeDetailsCard(Map<String, dynamic> employee) {
    return Card(
      color: const Color(0xFFFFF7D6),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Employee Details",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const Divider(),
            _row("Name",
                "${employee["first_name"] ?? ""} ${employee["last_name"] ?? ""}"),
            _row("Designation", employee["designation_name"]),
            _row("Work Location", employee["work_location"]),
            _row("Joining Date", employee["join_date"]),
            _row("Bank Name", employee["bank_name"]),
            _row("Account No", employee["bank_account_no"]),
            _row("IFSC Code", employee["ifsc_code"]),
            _row("PAN", employee["pan"]),
            _row("UAN", employee["uan"]),
            _row("PF Account", employee["pf_ac_no"]),
          ],
        ),
      ),
    );
  }

  /* ================= COMMON ================= */

  Widget _sectionCard(String title, Map<String, dynamic> rows) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const Divider(),
            ...rows.entries.map(
              (e) => _row(e.key, "₹${e.value ?? 0}"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _netPayCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Net Pay",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              "₹${payslip!["net_salary"]}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value?.toString() ?? "-",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
