import 'package:flutter/material.dart';

class TCSTDSDialog extends StatefulWidget {
  final Map<String, dynamic> initialValues;

  const TCSTDSDialog({
    super.key,
    required this.initialValues,
  });

  @override
  State<TCSTDSDialog> createState() =>
      _TCSTDSDialogState();
}

class _TCSTDSDialogState
    extends State<TCSTDSDialog> {

  final TextEditingController tcsController =
      TextEditingController();
  final TextEditingController tdsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    tcsController.text =
        widget.initialValues["tcs"]?.toString() ?? "";
    tdsController.text =
        widget.initialValues["tds"]?.toString() ?? "";
  }

  double _calculateTotal() {
    double tcs =
        double.tryParse(tcsController.text) ?? 0;
    double tds =
        double.tryParse(tdsController.text) ?? 0;

    return tcs + tds;
  }

  void _clearForm() {
    tcsController.clear();
    tdsController.clear();
    setState(() {});
  }

  Widget _amountField(
      String label,
      TextEditingController controller) {
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
            label,
            style: const TextStyle(
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
          const EdgeInsets.all(16),
      child: SizedBox(
        width: 700,
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
                    "TCS / TDS Deduction",
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

                  _amountField(
                      "TCS Deduction",
                      tcsController),

                  _amountField(
                      "TDS Deduction",
                      tdsController),

                  Align(
                    alignment:
                        Alignment.centerRight,
                    child: Text(
                      "Total: ₹${_calculateTotal().toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight:
                              FontWeight.w600),
                    ),
                  ),
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
                          "tcs": double.tryParse(
                                  tcsController
                                      .text) ??
                              0,
                          "tds": double.tryParse(
                                  tdsController
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
