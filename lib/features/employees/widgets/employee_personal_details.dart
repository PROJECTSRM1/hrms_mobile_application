import 'package:flutter/material.dart';
import '../../../common/widgets/section_title.dart';

class EmployeePersonalDetails extends StatelessWidget {
  final Map<String, dynamic> formData;

  const EmployeePersonalDetails({
    super.key,
    required this.formData,
  });

  Future<void> _pickDate(
    BuildContext context,
    Function(String) onSelected,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      onSelected(date.toIso8601String().split("T").first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Personal Details"),
        const SizedBox(height: 16),

        /// Date of Birth
        TextFormField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: "Date of Birth *",
            suffixIcon: Icon(Icons.calendar_today),
          ),
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          onTap: () => _pickDate(
            context,
            (v) => formData["date_of_birth"] = v,
          ),
        ),

        const SizedBox(height: 16),

        /// Gender
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: "Gender *"),
          items: const [
            DropdownMenuItem(value: 1, child: Text("Male")),
            DropdownMenuItem(value: 2, child: Text("Female")),
            DropdownMenuItem(value: 3, child: Text("Other")),
          ],
          validator: (v) => v == null ? "Required" : null,
          onChanged: (_) {},
          onSaved: (v) => formData["gender_id"] = v,
        ),

        const SizedBox(height: 16),

        /// Marital Status
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: "Marital Status *"),
          items: const [
            DropdownMenuItem(value: 1, child: Text("Single")),
            DropdownMenuItem(value: 2, child: Text("Married")),
            DropdownMenuItem(value: 3, child: Text("Other")),
          ],
          validator: (v) => v == null ? "Required" : null,
          onChanged: (_) {},
          onSaved: (v) => formData["marital_status_id"] = v,
        ),

        const SizedBox(height: 16),

        /// Email
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Email *",
            hintText: "example@gmail.com",
          ),
          validator: (v) =>
              v != null && v.contains("@") ? null : "Enter valid email",
          onSaved: (v) => formData["email"] = v,
        ),

        const SizedBox(height: 16),

        /// Present Address
        TextFormField(
          maxLines: 3,
          decoration: const InputDecoration(labelText: "Present Address *"),
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          onSaved: (v) => formData["present_address"] = v,
        ),

        const SizedBox(height: 16),

        /// Permanent Address
        TextFormField(
          maxLines: 3,
          decoration: const InputDecoration(labelText: "Permanent Address *"),
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          onSaved: (v) => formData["permanent_address"] = v,
        ),
      ],
    );
  }
}
