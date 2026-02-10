import 'package:flutter/material.dart';

class Sec80CEditDialog extends StatefulWidget {
  const Sec80CEditDialog({super.key});

  @override
  State<Sec80CEditDialog> createState() =>
      _Sec80CEditDialogState();
}

class _Sec80CEditDialogState extends State<Sec80CEditDialog> {
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
                    onPressed: () => Navigator.pop(context),
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
                  children: [
                    _AmountField(
                      label:
                          "5 Years of Fixed Deposit in Scheduled Bank",
                      controller: controllers["fd"]!,
                    ),
                    _AmountField(
                      label: "Children Tuition Fees",
                      controller: controllers["tuition"]!,
                    ),
                    _AmountField(
                      label: "Contribution to Pension Fund",
                      controller: controllers["pension"]!,
                    ),
                    _AmountField(
                      label: "Deposit in NSC",
                      controller: controllers["nsc"]!,
                    ),
                    _AmountField(
                      label: "Deposit in NSS",
                      controller: controllers["nss"]!,
                    ),
                    _AmountField(
                      label:
                          "Deposit in Post Office Savings Schemes",
                      controller: controllers["postOffice"]!,
                    ),
                    _AmountField(
                      label:
                          "Equity Linked Savings Scheme (ELSS)",
                      controller: controllers["elss"]!,
                    ),
                    _AmountField(
                      label: "Interest on NSC Reinvested",
                      controller: controllers["nscInterest"]!,
                    ),
                    _AmountField(
                      label: "Life Insurance Premium",
                      controller: controllers["insurance"]!,
                    ),
                    _AmountField(
                      label:
                          "Long term Infrastructure Bonds",
                      controller: controllers["infraBonds"]!,
                    ),
                    _AmountField(
                      label: "Mutual Funds",
                      controller: controllers["mutualFunds"]!,
                    ),
                    _AmountField(
                      label: "NABARD Rural Bonds",
                      controller: controllers["nabard"]!,
                    ),
                    _AmountField(
                      label: "National Pension Scheme",
                      controller: controllers["nps"]!,
                    ),
                    _AmountField(
                      label: "NHB Scheme",
                      controller: controllers["nhb"]!,
                    ),
                    _AmountField(
                      label:
                          "Post office time deposit for 5 years",
                      controller: controllers["timeDeposit"]!,
                    ),
                    _AmountField(
                      label:
                          "Pradhan Mantri Suraksha Bima Yojana",
                      controller: controllers["pmInsurance"]!,
                    ),
                    _AmountField(
                      label: "Public Provident Fund",
                      controller: controllers["ppf"]!,
                    ),
                    _AmountField(
                      label:
                          "Repayment of Housing loan (Principal amount)",
                      controller: controllers["housingLoan"]!,
                    ),
                  ],
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
                      final total = _calculateTotal();
                      Navigator.pop(context, total);
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
