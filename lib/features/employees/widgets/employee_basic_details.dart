import 'package:flutter/material.dart';
import '../../../common/widgets/section_title.dart';

class EmployeeBasicDetails extends StatefulWidget {
  final Map<String, dynamic> formData;

  const EmployeeBasicDetails({
    super.key,
    required this.formData,
  });

  @override
  State<EmployeeBasicDetails> createState() => _EmployeeBasicDetailsState();
}

class _EmployeeBasicDetailsState extends State<EmployeeBasicDetails> {
  String? _selectedBloodGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Basic Details"),
        const SizedBox(height: 16),

        /// ================= PROFILE PHOTO =================
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: Color(0xFF8BCF6A),
                child: Text(
                  "U",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                },
                icon: const Icon(Icons.upload),
                label: const Text("Upload Photo"),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        /// ================= EMPLOYEE ID =================
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Employee ID *",
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "Employee ID required" : null,
          onSaved: (v) => widget.formData["emp_code"] = v,
        ),

        const SizedBox(height: 16),

        /// ================= FIRST NAME =================
        TextFormField(
          decoration: const InputDecoration(
            labelText: "First Name *",
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "First name required" : null,
          onSaved: (v) => widget.formData["first_name"] = v,
        ),

        const SizedBox(height: 16),

        /// ================= LAST NAME =================
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Last Name *",
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "Last name required" : null,
          onSaved: (v) => widget.formData["last_name"] = v,
        ),

        const SizedBox(height: 16),

        /// ================= FATHER NAME =================
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Father Name *",
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "Father name required" : null,
          onSaved: (v) => widget.formData["father_name"] = v,
        ),

        const SizedBox(height: 16),

        /// ================= BLOOD GROUP =================
        DropdownButtonFormField<String>(
          initialValue: _selectedBloodGroup,
          decoration: const InputDecoration(
            labelText: "Blood Group *",
          ),
          items: const [
            DropdownMenuItem(value: "A+", child: Text("A+")),
            DropdownMenuItem(value: "A-", child: Text("A-")),
            DropdownMenuItem(value: "B+", child: Text("B+")),
            DropdownMenuItem(value: "B-", child: Text("B-")),
            DropdownMenuItem(value: "AB+", child: Text("AB+")),
            DropdownMenuItem(value: "AB-", child: Text("AB-")),
            DropdownMenuItem(value: "O+", child: Text("O+")),
          ],
          validator: (v) => v == null ? "Blood group required" : null,
          onChanged: (v) {
            setState(() {
              _selectedBloodGroup = v;
            });
          },
          onSaved: (v) {
            widget.formData["blood_group"] = v;
          },
        ),
      ],
    );
  }
}
