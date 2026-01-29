import 'package:flutter/material.dart';
import '../../../common/widgets/section_title.dart';

class EmployeeContactDetails extends StatelessWidget {
  final Map<String, dynamic> formData;

  const EmployeeContactDetails({super.key, required this.formData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Contact Info"),

        TextFormField(
          decoration: const InputDecoration(labelText: "Phone Number"),
          keyboardType: TextInputType.phone,
          validator: (v) =>
              v!.length == 10 ? null : "Enter 10-digit phone",
          onSaved: (v) => formData["mobile"] = v,
        ),

        const SizedBox(height: 12),

        TextFormField(
          decoration: const InputDecoration(labelText: "Emergency Mobile"),
          keyboardType: TextInputType.phone,
          validator: (v) =>
              v!.length == 10 ? null : "Enter 10-digit number",
          onSaved: (v) => formData["emergency_mobile"] = v,
        ),
      ],
    );
  }
}
