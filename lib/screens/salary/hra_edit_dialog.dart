import 'package:flutter/material.dart';

class HRAEditDialog extends StatefulWidget {
  final Map<String, dynamic> initialValues;

  const HRAEditDialog({
    super.key,
    required this.initialValues,
  });

  @override
  State<HRAEditDialog> createState() =>
      _HRAEditDialogState();
}

class _HRAEditDialogState extends State<HRAEditDialog> {

  final TextEditingController monthlyRentController =
      TextEditingController();
  final TextEditingController houseNoController =
      TextEditingController();
  final TextEditingController streetController =
      TextEditingController();
  final TextEditingController cityController =
      TextEditingController();
  final TextEditingController pincodeController =
      TextEditingController();
  final TextEditingController landlordNameController =
      TextEditingController();
  final TextEditingController landlordPanController =
      TextEditingController();

  String fromMonth = "Apr 2025";
  String toMonth = "Mar 2026";
  String hasPan = "Yes";

  @override
  void initState() {
    super.initState();

    monthlyRentController.text =
        widget.initialValues["monthlyRent"]?.toString() ?? "";

    houseNoController.text =
        widget.initialValues["houseNo"] ?? "";
    streetController.text =
        widget.initialValues["street"] ?? "";
    cityController.text =
        widget.initialValues["city"] ?? "";
    pincodeController.text =
        widget.initialValues["pincode"] ?? "";
    landlordNameController.text =
        widget.initialValues["landlordName"] ?? "";
    landlordPanController.text =
        widget.initialValues["landlordPan"] ?? "";

    hasPan = widget.initialValues["hasPan"] ?? "Yes";
    fromMonth = widget.initialValues["from"] ?? fromMonth;
    toMonth = widget.initialValues["to"] ?? toMonth;
  }

  double _calculateAnnualRent() {
    final rent =
        double.tryParse(monthlyRentController.text) ?? 0;
    return rent * 12;
  }

  void _clearForm() {
    monthlyRentController.clear();
    houseNoController.clear();
    streetController.clear();
    cityController.clear();
    pincodeController.clear();
    landlordNameController.clear();
    landlordPanController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final annualRent = _calculateAnnualRent();

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 950,
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
                    "House Rent Allowance",
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    /// TOTAL
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                            BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Total Declared in ₹ ${annualRent.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight:
                                FontWeight.w500),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text("House 1"),

                    const SizedBox(height: 16),

                    /// FROM - TO
                    Row(
                      children: [
                        Expanded(
                          child: _dropdownField(
                              "From *",
                              fromMonth,
                              (val) {
                            setState(() {
                              fromMonth = val!;
                            });
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _dropdownField(
                              "To *",
                              toMonth,
                              (val) {
                            setState(() {
                              toMonth = val!;
                            });
                          }),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// MONTHLY RENT
                    _textField(
                        "Monthly Rent Amount *",
                        monthlyRentController,
                        isAmount: true),

                    const SizedBox(height: 12),

                    Text(
                      "ANNUAL RENT AMOUNT ₹ : ${annualRent.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight:
                              FontWeight.w500),
                    ),

                    const SizedBox(height: 24),

                    const Text("Full Address"),

                    const SizedBox(height: 12),

                    /// HOUSE + STREET
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                              "House Name / Number",
                              houseNoController),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _textField(
                              "Street / Area / Locality",
                              streetController),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// CITY + PINCODE
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                              "Town / City",
                              cityController),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _textField(
                              "Pincode *",
                              pincodeController),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                        "Does your landlord have a PAN?"),

                    Row(
                      children: [
                        Radio(
                          value: "Yes",
                          groupValue: hasPan,
                          onChanged: (val) {
                            setState(() {
                              hasPan = val!;
                            });
                          },
                        ),
                        const Text("Yes"),
                        Radio(
                          value: "No",
                          groupValue: hasPan,
                          onChanged: (val) {
                            setState(() {
                              hasPan = val!;
                            });
                          },
                        ),
                        const Text("No"),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _textField("Landlord's Name *",
                        landlordNameController),

                    const SizedBox(height: 16),

                    _textField("Landlord's PAN *",
                        landlordPanController),
                  ],
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
                    child:
                        const Text("Clear Form"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {

                      Navigator.pop(context, {
                        "values": {
                          "monthlyRent":
                              monthlyRentController
                                  .text,
                          "houseNo":
                              houseNoController.text,
                          "street":
                              streetController.text,
                          "city":
                              cityController.text,
                          "pincode":
                              pincodeController.text,
                          "landlordName":
                              landlordNameController
                                  .text,
                          "landlordPan":
                              landlordPanController
                                  .text,
                          "hasPan": hasPan,
                          "from": fromMonth,
                          "to": toMonth,
                        },
                        "total": annualRent,
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

  Widget _textField(
      String label,
      TextEditingController controller,
      {bool isAmount = false}) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isAmount
              ? TextInputType.number
              : TextInputType.text,
          decoration: InputDecoration(
            prefixText:
                isAmount ? "₹ " : null,
            border:
                const OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _dropdownField(String label,
      String value,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: const [
            DropdownMenuItem(
                value: "Apr 2025",
                child: Text("Apr 2025")),
            DropdownMenuItem(
                value: "Mar 2026",
                child: Text("Mar 2026")),
          ],
          onChanged: onChanged,
          decoration:
              const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
