import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tax_declaration_model.dart';
import 'sec_80c_edit_dialog.dart';

class TaxPlannerCardsScreen extends StatefulWidget {
  const TaxPlannerCardsScreen({super.key});

  @override
  State<TaxPlannerCardsScreen> createState() =>
      _TaxPlannerCardsScreenState();
}

class _TaxPlannerCardsScreenState
    extends State<TaxPlannerCardsScreen> {
  String selectedYear = "2025 - 2026";

  @override
  Widget build(BuildContext context) {
    final tax = context.watch<TaxDeclarationModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF008C8C),
        title: const Text(
          "IT Declaration",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 TOP ROW (Back + Year Dropdown)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text("Back to IT Declaration"),
                ),

                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedYear,
                      items: const [
                        DropdownMenuItem(
                          value: "2025 - 2026",
                          child: Text("2025 - 2026"),
                        ),
                        DropdownMenuItem(
                          value: "2024 - 2025",
                          child: Text("2024 - 2025"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 CARDS GRID
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [

                /// ✅ SEC 80C (PROVIDER BASED)
                _TaxCard(
                  title: "Sec 80C",
                  value:
                      "Declared: ₹${tax.sec80c.toStringAsFixed(0)} / 150000",
                  onEdit: () async {
                    final result = await showDialog<double>(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Sec80CEditDialog(),
                    );

                    if (result != null) {
                      context
                          .read<TaxDeclarationModel>()
                          .updateSec80C(result);
                    }
                  },
                ),

                _TaxCard(
                  title: "Other Deductions",
                  value: "Declared: ₹${tax.otherDeductions}",
                ),

                _TaxCard(
                  title: "House Rent Allowance",
                  value: "Declared: ₹${tax.hra}",
                ),

                _TaxCard(
                  title: "Medical (80D)",
                  value: "Declared: ₹${tax.medical80d}",
                ),

                _TaxCard(
                  title: "Income / Loss",
                  value: "Declared: ₹${tax.incomeLoss}",
                ),

                const _DashedTaxCard(title: "Other Income"),
                const _DashedTaxCard(title: "TCS / TDS Deduction"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// SOLID CARD
/// =======================
class _TaxCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onEdit;

  const _TaxCard({
    required this.title,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: onEdit,
              child: Text(
                "Edit",
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// DASHED CARD
/// =======================
class _DashedTaxCard extends StatelessWidget {
  final String title;

  const _DashedTaxCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              "Edit",
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Declared: ₹0",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
