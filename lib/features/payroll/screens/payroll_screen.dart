import 'package:flutter/material.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}

/// =======================================================
/// Static Payroll Card (Exact Mobile Version of Web Table)
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Employee Row
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey,
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
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 24),

            _salaryRow("Basic", basic),
            _salaryRow("HRA", hra),
            _salaryRow("Special Allowance", allowance),

            const Divider(height: 24),

            /// Net Salary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Net Salary",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹$netSalary",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Button (same as web)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Generate Payslip"),
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
