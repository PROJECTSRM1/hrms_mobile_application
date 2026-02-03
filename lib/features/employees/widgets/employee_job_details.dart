import 'package:flutter/material.dart';
import '../../../common/widgets/section_title.dart';

class EmployeeJobDetails extends StatelessWidget {
  final Map<String, dynamic> formData;

  const EmployeeJobDetails({
    super.key,
    required this.formData,
  });

  Future<void> _pickDate(
    BuildContext context,
    Function(String) onSelected,
  ) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
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
        const SectionTitle("Job Details"),
        const SizedBox(height: 16),

        _dropdown(
          label: "Role *",
          items: const {
            1: "HR Admin",
            2: "Employee",
            3: "Manager",
          },
          onSaved: (v) => formData["role_id"] = v,
        ),

        _space(),

        _dropdown(
          label: "Department *",
          items: const {
            1: "IT",
            2: "HR",
            3: "Finance",
          },
          onSaved: (v) => formData["department_id"] = v,
        ),

        _space(),

        _dropdown(
          label: "Designation *",
          items: const {
            1: "Developer",
            2: "Tester",
            3: "Manager",
          },
          onSaved: (v) => formData["designation_id"] = v,
        ),

        _space(),

        _dropdown(
          label: "Employee Type *",
          items: const {
            1: "Regular",
            2: "Contract",
            3: "Intern",
          },
          onSaved: (v) => formData["employee_type_id"] = v,
        ),

        _space(),

        _dropdown(
          label: "Work Location *",
          items: const {
            1: "Hyderabad",
            2: "Bangalore",
            3: "Chennai",
          },
          onSaved: (v) => formData["work_location_id"] = v,
        ),

        _space(),

        _dropdown(
          label: "Shift *",
          items: const {
            1: "Day",
            2: "Night",
            3: "Flexible",
          },
          onSaved: (v) => formData["shift_id"] = v,
        ),

        _space(),

        _dropdown(
          label: "Reporting Manager *",
          items: const {
            1: "EMP001",
            2: "EMP002",
          },
          onSaved: (v) => formData["manager_id"] = v,
        ),

        _space(),

        _dateField(
          context,
          label: "Joining Date *",
          onSaved: (v) => formData["join_date"] = v,
        ),

        _space(),

        _dateField(
          context,
          label: "Probation End Date",
          required: false,
          onSaved: (v) => formData["probation_end_date"] = v,
        ),

        _space(),

        _dropdown(
          label: "Status *",
          items: const {
            1: "Active",
            0: "Inactive",
          },
          onSaved: (v) => formData["is_active"] = v == 1,
        ),

        _space(),

        _textField(
          label: "UAN",
          hint: "Enter 12-digit UAN",
          onSaved: (v) => formData["uan"] = v,
        ),

        _space(),

        _textField(
          label: "PAN *",
          hint: "ABCDE1234F",
          required: true,
          onSaved: (v) => formData["pan"] = v,
        ),

        _space(),

        _textField(
          label: "Aadhaar *",
          hint: "Enter 12-digit Aadhaar",
          required: true,
          keyboard: TextInputType.number,
          onSaved: (v) => formData["aadhaar"] = v,
        ),

        _space(),

        _textField(
          label: "CTC *",
          required: true,
          keyboard: TextInputType.number,
          onSaved: (v) => formData["ctc"] = int.parse(v!),
        ),

        _space(),

        _textField(
          label: "Bank Account *",
          required: true,
          keyboard: TextInputType.number,
          onSaved: (v) => formData["bank_ac_no"] = v,
        ),

        _space(),

        _textField(
          label: "IFSC *",
          hint: "HDFC0001234",
          required: true,
          onSaved: (v) => formData["ifsc_code"] = v,
        ),
      ],
    );
  }

  /// ================= HELPERS =================
  Widget _space() => const SizedBox(height: 16);

  Widget _dropdown({
    required String label,
    required Map<int, String> items,
    required Function(int?) onSaved,
  }) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(labelText: label),
      items: items.entries
          .map(
            (e) => DropdownMenuItem(
              value: e.key,
              child: Text(e.value),
            ),
          )
          .toList(),
      validator: (v) => v == null ? "Required" : null,
      onChanged: (_) {},
      onSaved: onSaved,
    );
  }

  Widget _textField({
    required String label,
    String? hint,
    bool required = false,
    TextInputType keyboard = TextInputType.text,
    required Function(String?) onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, hintText: hint),
      keyboardType: keyboard,
      validator:
          required ? (v) => v == null || v.isEmpty ? "Required" : null : null,
      onSaved: onSaved,
    );
  }

  Widget _dateField(
    BuildContext context, {
    required String label,
    bool required = true,
    required Function(String) onSaved,
  }) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      validator: required ? (v) => v!.isEmpty ? "Required" : null : null,
      onTap: () => _pickDate(context, onSaved),
    );
  }
}
