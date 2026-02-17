import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tax_declaration_model.dart';
import 'my_tax_planner_screen.dart';

class ITDeclarationScreen extends StatefulWidget {
  const ITDeclarationScreen({super.key});

  @override
  State<ITDeclarationScreen> createState() =>
      _ITDeclarationScreenState();
}

class _ITDeclarationScreenState extends State<ITDeclarationScreen> {
  String selectedYear = "2025 - 2026";

  @override
  Widget build(BuildContext context) {
    final tax = context.watch<TaxDeclarationModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF008C8C),
        elevation: 0,
        title: const Text("IT Declaration"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyTaxPlannerScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1677FF),
                  ),
                  child: const Text("My Tax Planner"),
                ),

                DropdownButton<String>(
                  value: selectedYear,
                  items: const [
                    DropdownMenuItem(
                      value: "2025 - 2026",
                      child: Text("2025 - 2026"),
                    ),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔒 STATUS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Declaration Status : Locked",
                style: TextStyle(color: Colors.red),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Apr 2025",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// =========================
            /// ALL VALUES FROM PROVIDER
            /// =========================

            _card(
              "Section 80C (max limit 1.5 lakh)",
              "Declared: ₹${tax.sec80c.toStringAsFixed(0)} / 150000",
            ),

            _card(
              "Other Chapter VI-A Deductions",
              "Declared amount ₹ ${tax.otherDeductions.toStringAsFixed(0)}",
            ),

            _card(
              "House Rent Allowance",
              "Declared amount ₹ ${tax.hra.toStringAsFixed(0)}",
            ),

            _card(
              "Medical (Sec 80D)",
              "Declared amount ₹ ${tax.medical80d.toStringAsFixed(0)}",
            ),

            _card(
              "Income / Loss from House Property",
              "Declared amount ₹ ${tax.incomeLoss.toStringAsFixed(0)}",
            ),

            _card(
              "Other Income",
              "Declared amount ₹ ${tax.otherIncome.toStringAsFixed(0)}",
            ),

            _card(
              "TCS / TDS Deduction",
              "Declared amount ₹ ${tax.tcsTds.toStringAsFixed(0)}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
