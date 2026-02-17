import 'package:flutter/material.dart';

class OtherDeductionsDialog extends StatefulWidget {
  final Map<String, double> initialValues;

  const OtherDeductionsDialog({
    super.key,
    required this.initialValues,
  });

  @override
  State<OtherDeductionsDialog> createState() =>
      _OtherDeductionsDialogState();
}

class _OtherDeductionsDialogState
    extends State<OtherDeductionsDialog> {

  /// 🔥 ALL FIELDS FROM YOUR WEB SCREEN
  final Map<String, String> labelMap = {

    // Housing Loan
    "80EE": "80EE Additional Interest on Housing Loan (1 Apr 2016)",
    "80EEA": "80EEA Additional Interest on Housing Loan (1 Apr 2019)",

    // Donations
    "80GGC": "80GGC Donations to Political Party / Electoral Trust",
    "80GGA": "80GGA Donation for Scientific Research / Rural Development",

    // NPS
    "80CCD1": "80CCD(1) Employee Contribution to NPS",
    "80CCD1B": "80CCD(1B) Contribution to NPS 2015",

    // EV Loan
    "80EEB": "80EEB Interest on Electric Vehicle Loan",

    // Retrenchment
    "10(10B)": "10(10B) Retrenchment Compensation",

    // Interest
    "80TTB": "80TTB Interest (Senior Citizen)",
    "80TTA": "80TTA Interest on Savings Account",

    // Donations 80G
    "80G100": "80G Donation – 100% Exemption",
    "80G50": "80G Donation – 50% Exemption",
    "80GChildren": "80G Donation – Children Education",
    "80GPolitical": "80G Donation – Political Parties",
  };

  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();

    controllers = {
      for (var key in labelMap.keys)
        key: TextEditingController(
          text: widget.initialValues[key]?.toString() ?? "",
        )
    };
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
        width: 1000,
        child: Column(
          children: [

            /// HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Other Chapter VI-A Deductions",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  spacing: 24,
                  runSpacing: 20,
                  children: labelMap.entries.map((entry) {
                    return SizedBox(
                      width: 420,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.value,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller:
                                controllers[entry.key],
                            decoration:
                                const InputDecoration(
                              prefixText: "₹ ",
                              hintText: "Enter Amount",
                              border:
                                  OutlineInputBorder(),
                            ),
                            keyboardType:
                                TextInputType.number,
                          ),
                        ],
                      ),
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
                mainAxisAlignment:
                    MainAxisAlignment.end,
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
