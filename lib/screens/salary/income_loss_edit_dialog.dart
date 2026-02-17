import 'package:flutter/material.dart';

class IncomeLossEditDialog extends StatefulWidget {
  final Map<String, dynamic> initialValues;

  const IncomeLossEditDialog({
    super.key,
    required this.initialValues,
  });

  @override
  State<IncomeLossEditDialog> createState() =>
      _IncomeLossEditDialogState();
}

class _IncomeLossEditDialogState
    extends State<IncomeLossEditDialog> {

  final TextEditingController interestController =
      TextEditingController();

  final TextEditingController lenderNameController =
      TextEditingController();

  final TextEditingController lenderPanController =
      TextEditingController();

  final TextEditingController annualRentController =
      TextEditingController();

  final TextEditingController municipalTaxController =
      TextEditingController();

  final TextEditingController unrealizedRentController =
      TextEditingController();

  final TextEditingController netValueController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    /// 🔥 PREFILL PREVIOUS VALUES
    interestController.text =
        widget.initialValues["interest"]?.toString() ?? "";

    lenderNameController.text =
        widget.initialValues["lenderName"] ?? "";

    lenderPanController.text =
        widget.initialValues["lenderPan"] ?? "";

    annualRentController.text =
        widget.initialValues["annualRent"]?.toString() ?? "";

    municipalTaxController.text =
        widget.initialValues["municipalTax"]?.toString() ?? "";

    unrealizedRentController.text =
        widget.initialValues["unrealizedRent"]?.toString() ?? "";

    netValueController.text =
        widget.initialValues["netValue"]?.toString() ?? "";
  }

  double _calculateTotal() {
    double total = 0;

    total += double.tryParse(interestController.text) ?? 0;
    total += double.tryParse(netValueController.text) ?? 0;

    return total;
  }

  void _clearForm() {
    interestController.clear();
    lenderNameController.clear();
    lenderPanController.clear();
    annualRentController.clear();
    municipalTaxController.clear();
    unrealizedRentController.clear();
    netValueController.clear();
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
        width: 900,
        child: Column(
          children: [

            /// ================= HEADER =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Income / Loss from House Property",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            /// ================= BODY =================
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    /// SELF OCCUPIED
                    const Text(
                      "a. Income from Self-Occupied Property",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    _moneyField(
                        "Interest on Housing Loan (Self Occupied)",
                        interestController),

                    const SizedBox(height: 12),

                    _textField(
                        "Lender's Name",
                        lenderNameController),

                    const SizedBox(height: 12),

                    _textField(
                        "Lender's PAN",
                        lenderPanController),

                    const SizedBox(height: 24),

                    /// LET OUT
                    const Text(
                      "b. Income from Let-out Property",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    _moneyField(
                        "Annual Rent Received",
                        annualRentController),

                    const SizedBox(height: 12),

                    _moneyField(
                        "Municipal Taxes Paid",
                        municipalTaxController),

                    const SizedBox(height: 12),

                    _moneyField(
                        "Unrealized Rent",
                        unrealizedRentController),

                    const SizedBox(height: 12),

                    _moneyField(
                        "Net Value",
                        netValueController),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            /// ================= FOOTER =================
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
                      final values = {
                        "interest":
                            double.tryParse(
                                    interestController.text) ??
                                0,
                        "lenderName":
                            lenderNameController.text,
                        "lenderPan":
                            lenderPanController.text,
                        "annualRent":
                            double.tryParse(
                                    annualRentController.text) ??
                                0,
                        "municipalTax":
                            double.tryParse(
                                    municipalTaxController.text) ??
                                0,
                        "unrealizedRent":
                            double.tryParse(
                                    unrealizedRentController.text) ??
                                0,
                        "netValue":
                            double.tryParse(
                                    netValueController.text) ??
                                0,
                      };

                      Navigator.pop(context, {
                        "values": values,
                        "total": _calculateTotal(),
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

  /// ================= MONEY FIELD =================
  Widget _moneyField(
      String label,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType:
              TextInputType.number,
          decoration: InputDecoration(
            prefixText: "₹ ",
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }

  /// ================= TEXT FIELD =================
  Widget _textField(
      String label,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }
}
