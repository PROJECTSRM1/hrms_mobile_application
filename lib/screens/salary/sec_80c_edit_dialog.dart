import 'package:flutter/material.dart';

class Sec80CEditDialog extends StatefulWidget {
  final Map<String, double> initialValues;

  const Sec80CEditDialog({
    super.key,
    required this.initialValues,
  });

  @override
  State<Sec80CEditDialog> createState() =>
      _Sec80CEditDialogState();
}

class _Sec80CEditDialogState extends State<Sec80CEditDialog> {

  /// 🔥 LABEL MAP (Readable names)
  final Map<String, String> labelMap = {
    "fd": "5 Years Fixed Deposit",
    "tuition": "Children Tuition Fees",
    "pension": "Contribution to Pension Fund",
    "nsc": "Deposit in NSC",
    "nss": "Deposit in NSS",
    "postOffice": "Post Office Savings Schemes",
    "elss": "Equity Linked Savings Scheme (ELSS)",
    "nscInterest": "Interest on NSC Reinvested",
    "insurance": "Life Insurance Premium",
    "infraBonds": "Long Term Infrastructure Bonds",
    "mutualFunds": "Mutual Funds",
    "nabard": "NABARD Rural Bonds",
    "nps": "National Pension Scheme",
    "nhb": "NHB Scheme",
    "timeDeposit": "Post Office Time Deposit (5 Years)",
    "pmInsurance": "Pradhan Mantri Suraksha Bima Yojana",
    "ppf": "Public Provident Fund",
    "housingLoan": "Housing Loan Principal",
  };

  final Map<String, TextEditingController> controllers = {
    "fd": TextEditingController(),
    "tuition": TextEditingController(),
    "pension": TextEditingController(),
    "nsc": TextEditingController(),
    "nss": TextEditingController(),
    "postOffice": TextEditingController(),
    "elss": TextEditingController(),
    "nscInterest": TextEditingController(),
    "insurance": TextEditingController(),
    "infraBonds": TextEditingController(),
    "mutualFunds": TextEditingController(),
    "nabard": TextEditingController(),
    "nps": TextEditingController(),
    "nhb": TextEditingController(),
    "timeDeposit": TextEditingController(),
    "pmInsurance": TextEditingController(),
    "ppf": TextEditingController(),
    "housingLoan": TextEditingController(),
  };

  @override
  void initState() {
    super.initState();

    /// Prefill previous values
    controllers.forEach((key, controller) {
      if (widget.initialValues.containsKey(key)) {
        controller.text =
            widget.initialValues[key]!.toString();
      }
    });
  }

  Map<String, double> _getValues() {
    final Map<String, double> values = {};
    for (final entry in controllers.entries) {
      values[entry.key] =
          double.tryParse(entry.value.text) ?? 0;
    }
    return values;
  }

  double _calculateTotal() {
    double total = 0;
    for (final c in controllers.values) {
      total += double.tryParse(c.text) ?? 0;
    }
    return total;
  }

  void _clearForm() {
    for (final c in controllers.values) {
      c.clear();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 700,
        child: Column(
          children: [

            /// HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sec 80C",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        Navigator.pop(context),
                  )
                ],
              ),
            ),

            const Divider(height: 1),

            /// BODY
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: labelMap.entries.map((entry) {
                    return _AmountField(
                      label: entry.value,
                      controller: controllers[entry.key]!,
                    );
                  }).toList(),
                ),
              ),
            ),

            const Divider(height: 1),

            /// FOOTER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _clearForm,
                    child: const Text("Clear Form"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final values = _getValues();
                      final total = _calculateTotal();

                      Navigator.pop(context, {
                        "values": values,
                        "total": total,
                      });
                    },
                    child: const Text("Update"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _AmountField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixText: "₹ ",
              hintText: "Enter Amount",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
