import 'package:flutter/material.dart';

class ProofOfInvestmentScreen extends StatefulWidget {
  const ProofOfInvestmentScreen({super.key});

  @override
  State<ProofOfInvestmentScreen> createState() =>
      _ProofOfInvestmentScreenState();
}

class _ProofOfInvestmentScreenState extends State<ProofOfInvestmentScreen> {
  int selectedIndex = 0;

  final List<String> components = [
    "Section 80C",
    "Other Chapter VI-A Deductions",
    "House Rent Allowance",
    "Medical (Sec 80D)",
    "Income/Loss from House Property",
    "TCS/TDS Deduction",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Proof of Investment"),
      ),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: Row(
              children: [
                _leftMenu(),
                Expanded(child: _rightContent()),
              ],
            ),
          ),
          _submitButton(),
        ],
      ),
    );
  }

  /// ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "POI Status 2025–2026 : OPEN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "POI window is open till 09 Feb 2026",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= LEFT MENU =================
  Widget _leftMenu() {
    return Container(
      width: 140,
      color: Colors.white,
      child: ListView.builder(
        itemCount: components.length,
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;
          return InkWell(
            onTap: () {
              setState(() => selectedIndex = index);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                components[index],
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ================= RIGHT CONTENT =================
  Widget _rightContent() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _sectionTitle("Section 80C"),
        _poiCard(
          title: "80CCD(1) Employee Contribution to NPS",
          maxLimit: "1,50,000",
          declared: "1,50,000",
        ),
        _poiCard(
          title: "80C Public Provident Fund",
          maxLimit: "1,50,000",
          declared: "60,000",
        ),
        _poiCard(
          title: "80C Investment of Housing Loan Principal",
          maxLimit: "1,50,000",
          declared: "1,25,127",
        ),

        _sectionTitle("Medical (Sec 80D)"),
        _poiCard(
          title: "80D Medical Insurance Premium",
          maxLimit: "25,000",
          declared: "25,000",
        ),
      ],
    );
  }

  /// ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  /// ================= POI CARD =================
  Widget _poiCard({
    required String title,
    required String maxLimit,
    required String declared,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoText("Max Limit", maxLimit),
              _infoText("Declared", declared),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// ================= SUBMIT BUTTON =================
  Widget _submitButton() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("Submit POI"),
        ),
      ),
    );
  }
}
