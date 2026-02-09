import 'package:flutter/material.dart';

class ItDeclarationScreen extends StatelessWidget {
  const ItDeclarationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "IT Declaration",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "2025 - 2026",
                style: TextStyle(color: Colors.black87),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _statusCard(),
            const SizedBox(height: 16),

            _sectionHeader("Apr 2025"),

            _declarationCard(
              title: "Section 80C (max limit 1.5 lakh)",
              rightText: "Declared: ₹0 / 150000",
            ),
            _declarationCard(title: "Other Chapter VI-A Deductions"),
            _declarationCard(title: "House Rent Allowance"),
            _declarationCard(title: "Medical (Sec 80D)"),
            _declarationCard(title: "Income / Loss from House Property"),
            _declarationCard(title: "Other Income"),
            _declarationCard(title: "TCS / TDS Deduction"),
          ],
        ),
      ),
    );
  }

  Widget _statusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6D8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: const [
          Text(
            "Declaration Status : ",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8),
          Chip(
            label: Text(
              "Locked",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _declarationCard({
    required String title,
    String rightText = "Declared amount ₹0",
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                rightText,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "No declaration added",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
