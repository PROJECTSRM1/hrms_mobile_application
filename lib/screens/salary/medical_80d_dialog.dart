import 'package:flutter/material.dart';

class Medical80DDialog extends StatefulWidget {
  final Map<String, double> initialValues;

  const Medical80DDialog({
    super.key,
    required this.initialValues,
  });

  @override
  State<Medical80DDialog> createState() =>
      _Medical80DDialogState();
}

class _Medical80DDialogState
    extends State<Medical80DDialog> {

  final Map<String, TextEditingController> controllers = {};

  String selfAge = "Below 60";
  String parentAge = "Below 60";

  final List<String> ageOptions = [
    "Below 60",
    "60 & Above"
  ];

  /// Section Limits
  final Map<String, double> limits = {
    "preventiveSelf": 5000,
    "medicalBillsSenior": 50000,
    "insuranceSelf": 25000,
    "insuranceParents": 25000,
    "preventiveParents": 5000,
  };

  @override
  void initState() {
    super.initState();

    for (var key in limits.keys) {
      controllers[key] = TextEditingController(
        text: widget.initialValues[key]?.toString() ?? "",
      );
    }
  }

  double _getValue(String key) {
    return double.tryParse(
            controllers[key]?.text ?? "0") ??
        0;
  }

  double _calculateTotal() {
    double total = 0;
    for (var key in limits.keys) {
      total += _getValue(key);
    }
    return total;
  }

  void _clearForm() {
    for (var c in controllers.values) {
      c.clear();
    }
    setState(() {});
  }

  bool _validateLimits() {
    for (var key in limits.keys) {
      if (_getValue(key) > limits[key]!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Amount exceeds limit ₹${limits[key]}"),
          ),
        );
        return false;
      }
    }
    return true;
  }

  Widget _amountField(
      String key, String title) {
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
          const SizedBox(height: 8),
          TextField(
            controller: controllers[key],
            keyboardType:
                TextInputType.number,
            decoration: const InputDecoration(
              prefixText: "₹ ",
              border: OutlineInputBorder(),
            ),
            onChanged: (_) =>
                setState(() {}),
          ),
          const SizedBox(height: 6),
          Text(
            "Max limit in ₹ : ${limits[key]!.toStringAsFixed(2)}",
            style: const TextStyle(
                fontSize: 12,
                color: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget _insuranceSection(
      {required String title,
      required String ageKey,
      required String amountKey}) {
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
          Text(title,
              style: const TextStyle(
                  fontWeight:
                      FontWeight.w600)),
          const SizedBox(height: 12),

          /// Age
          const Text("Age"),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: ageKey == "self"
                ? selfAge
                : parentAge,
            items: ageOptions
                .map((e) =>
                    DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                if (ageKey == "self") {
                  selfAge = val!;
                } else {
                  parentAge = val!;
                }
              });
            },
            decoration:
                const InputDecoration(
              border:
                  OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          /// Amount
          const Text("Declared Amount"),
          const SizedBox(height: 6),
          TextField(
            controller:
                controllers[amountKey],
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
          const SizedBox(height: 6),
          Text(
            "Max limit in ₹ : ${limits[amountKey]!.toStringAsFixed(2)}",
            style: const TextStyle(
                fontSize: 12,
                color: Colors.grey),
          )
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
        width: 900,
        child: Column(
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
                    "Medical (Sec 80D)",
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
            Expanded(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets.all(
                        16),
                child: Column(
                  children: [

                    /// TOTAL
                    Container(
                      padding:
                          const EdgeInsets
                              .all(16),
                      margin:
                          const EdgeInsets
                              .only(
                                  bottom: 16),
                      decoration:
                          BoxDecoration(
                        color: Colors
                            .grey.shade100,
                        borderRadius:
                            BorderRadius
                                .circular(
                                    8),
                      ),
                      child: Align(
                        alignment: Alignment
                            .centerLeft,
                        child: Text(
                          "Total declared in ₹ ${_calculateTotal().toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w600),
                        ),
                      ),
                    ),

                    _amountField(
                        "preventiveParents",
                        "80D Preventive Health Checkup - Dependant Parents"),

                    _amountField(
                        "medicalBillsSenior",
                        "80D Medical Bills - Senior Citizen (>60)"),

                    _insuranceSection(
                        title:
                            "80D Medical Insurance Premium",
                        ageKey: "self",
                        amountKey:
                            "insuranceSelf"),

                    _insuranceSection(
                        title:
                            "80D Medical Insurance Premium - Dependant Parents",
                        ageKey: "parent",
                        amountKey:
                            "insuranceParents"),

                    _amountField(
                        "preventiveSelf",
                        "80D Preventive Health Check-up"),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            /// FOOTER
            Padding(
              padding:
                  const EdgeInsets.all(
                      16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .end,
                children: [

                  OutlinedButton(
                    onPressed:
                        _clearForm,
                    child: const Text(
                        "Clear Form"),
                  ),

                  const SizedBox(
                      width: 12),

                  ElevatedButton(
                    onPressed: () {
                      if (!_validateLimits())
                        return;

                      final values = {
                        for (var key
                            in limits
                                .keys)
                          key:
                              _getValue(
                                  key)
                      };

                      Navigator.pop(
                          context, {
                        "values":
                            values,
                        "total":
                            _calculateTotal(),
                      });
                    },
                    child:
                        const Text("Update"),
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
