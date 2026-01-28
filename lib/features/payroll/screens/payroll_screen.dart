import 'package:flutter/material.dart';
import '../../../common/widgets/hrms_app_bar.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HrmsAppBar(),
      backgroundColor: const Color(0xFFF6F8FB),
      body: Column(
        children: [
          /// ================= PAGE TITLE =================
          

          /// ================= PAYROLL LIST =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                PayrollStaticCard(
                  name: "Rakesh Verma",
                  role: "Software Engineer",
                  basic: 24000,
                  hra: 12000,
                  allowance: 9000,
                  netSalary: 40800,
                ),
                PayrollStaticCard(
                  name: "Burra Pavan",
                  role: "Procurement Executive",
                  basic: 26000,
                  hra: 13000,
                  allowance: 9750,
                  netSalary: 44200,
                ),
                PayrollStaticCard(
                  name: "Rakesh Kumar",
                  role: "Software Engineer",
                  basic: 22000,
                  hra: 11000,
                  allowance: 8250,
                  netSalary: 37400,
                ),
                PayrollStaticCard(
                  name: "Roshan Karthik",
                  role: "HR Executive",
                  basic: 18000,
                  hra: 9000,
                  allowance: 6750,
                  netSalary: 30600,
                ),
                PayrollStaticCard(
                  name: "Surya Sanjay",
                  role: "Digital Marketing Executive",
                  basic: 24000,
                  hra: 12000,
                  allowance: 9000,
                  netSalary: 40800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================================================
/// PAYROLL CARD (Mobile HRMS Design)
/// =======================================================
class PayrollStaticCard extends StatelessWidget {
  final String name;
  final String role;
  final int basic;
  final int hra;
  final int allowance;
  final int netSalary;

  const PayrollStaticCard({
    super.key,
    required this.name,
    required this.role,
    required this.basic,
    required this.hra,
    required this.allowance,
    required this.netSalary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= EMPLOYEE INFO =================
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF0AA6B7),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 24),

            /// ================= SALARY DETAILS =================
            _salaryRow("Basic", basic),
            _salaryRow("HRA", hra),
            _salaryRow("Special Allowance", allowance),

            const Divider(height: 24),

            /// ================= NET SALARY =================
            const Text(
              "Net Salary",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "₹$netSalary",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0AA6B7),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= ACTION BUTTON =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Future: Generate PDF Payslip
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0AA6B7),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Generate Payslip",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _salaryRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text("₹$value"),
        ],
      ),
    );
  }
}
