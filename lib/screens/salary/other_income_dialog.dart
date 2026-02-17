import 'package:flutter/material.dart';

class OtherIncomeDialog extends StatefulWidget {
  final Map<String, dynamic> initialValues;

  const OtherIncomeDialog({
    super.key,
    required this.initialValues,
  });

  @override
  State<OtherIncomeDialog> createState() =>
      _OtherIncomeDialogState();
}

class _OtherIncomeDialogState
    extends State<OtherIncomeDialog> {

  final TextEditingController particulars1Controller =
      TextEditingController();
  final TextEditingController amount1Controller =
      TextEditingController();

  final TextEditingController particulars2Controller =
      TextEditingController();
  final TextEditingController amount2Controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    particulars1Controller.text =
        widget.initialValues["particular1"] ?? "";
    amount1Controller.text =
        widget.initialValues["amount1"]?.toString() ?? "";

    particulars2Controller.text =
        widget.initialValues["particular2"] ?? "";
    amount2Controller.text =
        widget.initialValues["amount2"]?.toString() ?? "";
  }

  double _calculateTotal() {
    double amt1 =
        double.tryParse(amount1Controller.text) ?? 0;
    double amt2 =
        double.tryParse(amount2Controller.text) ?? 0;

    return amt1 + amt2;
  }

  void _clearForm() {
    particulars1Controller.clear();
    amount1Controller.clear();
    particulars2Controller.clear();
    amount2Controller.clear();
    setState(() {});
  }

  Widget _incomeCard({
    required String title,
    required TextEditingController particulars,
    required TextEditingController amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          Row(
            children: [

              /// Particulars
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text("Particulars"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: particulars,
                      decoration:
                          const InputDecoration(
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              /// Amount
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text("Declared Amount"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: amount,
                      keyboardType:
                          TextInputType.number,
                      decoration:
                          const InputDecoration(
                        prefixText: "₹ ",
                        border:
                            OutlineInputBorder(),
                      ),
                      onChanged: (_) =>
                          setState(() {}),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
          const EdgeInsets.all(16),
      child: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// HEADER
            Padding(
              padding:
                  const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  const Text(
                    "Other Income",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.close),
                    onPressed: () =>
                        Navigator.pop(
                            context),
                  )
                ],
              ),
            ),

            const Divider(height: 1),

            /// BODY
            Padding(
              padding:
                  const EdgeInsets.all(16),
              child: Column(
                children: [

                  _incomeCard(
                    title: "Other Income 1",
                    particulars:
                        particulars1Controller,
                    amount: amount1Controller,
                  ),

                  _incomeCard(
                    title: "Other Income 2",
                    particulars:
                        particulars2Controller,
                    amount: amount2Controller,
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment:
                        Alignment.centerRight,
                    child: Text(
                      "Total: ₹${_calculateTotal().toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight:
                              FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),

            const Divider(height: 1),

            /// FOOTER
            Padding(
              padding:
                  const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [

                  OutlinedButton(
                    onPressed: _clearForm,
                    child:
                        const Text("Clear Form"),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        "values": {
                          "particular1":
                              particulars1Controller
                                  .text,
                          "amount1":
                              double.tryParse(
                                      amount1Controller
                                          .text) ??
                                  0,
                          "particular2":
                              particulars2Controller
                                  .text,
                          "amount2":
                              double.tryParse(
                                      amount2Controller
                                          .text) ??
                                  0,
                        },
                        "total":
                            _calculateTotal(),
                      });
                    },
                    child: const Text("Save"),
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
