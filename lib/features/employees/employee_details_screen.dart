import 'package:flutter/material.dart';
import '../../common/widgets/hrms_app_bar.dart';
import '../../services/employee_service.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final String employeeId;

  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  bool isLoading = true;
  bool isEditMode = false;

  Map<String, dynamic>? employee;
  final Map<String, dynamic> payload = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadEmployee();
  }

  Future<void> _loadEmployee() async {
    try {
      final data =
          await EmployeeService.fetchEmployeeById(widget.employeeId);
      setState(() {
        employee = data;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await EmployeeService.updateEmployee(
        widget.employeeId,
        payload,
      );

      setState(() {
        isEditMode = false;
        payload.clear();
      });

      _loadEmployee();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee updated successfully")),
      );
    } catch (_) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: const HrmsAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : employee == null
              ? const Center(child: Text("Employee not found"))
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _editControls(),
                        _headerCard(),
                        _personalDetails(),
                        _jobDetails(),
                        _familyDetails(),
                      ],
                    ),
                  ),
                ),
    );
  }

  // ================= EDIT CONTROLS =================
  Widget _editControls() {
    return Align(
      alignment: Alignment.centerRight,
      child: isEditMode
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isEditMode = false;
                      payload.clear();
                    });
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text("Save"),
                ),
              ],
            )
          : TextButton.icon(
              onPressed: () {
                setState(() => isEditMode = true);
              },
              icon: const Icon(Icons.edit, color: Colors.deepPurple),
              label: const Text(
                "Edit Details",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  // ================= HEADER =================
  Widget _headerCard() {
    return _card(
      color: const Color(0xFFF3EDFF),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.deepPurple,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${employee!['first_name']} ${employee!['last_name']}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  employee!['role_id'] == 2 ? "Employee" : "Other",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            "₹ ${employee!['ctc'] ?? 0}",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ================= PERSONAL =================
  Widget _personalDetails() {
    return _section(
      title: "Personal Details",
      color: const Color(0xFFF8F4FF),
      children: [
        _field("Email", "email", employee!['email']),
        _field("Phone", "mobile", employee!['mobile']),
        _field("Date of Birth", "date_of_birth", employee!['date_of_birth']),
        _field("Gender", "gender_id", _gender()),
        _field("Marital Status", "marital_status_id", _marital()),
        _field("Blood Group", "blood_group_id", employee!['blood_group_id']),
        _field("Present Address", "present_address",
            employee!['present_address']),
        _field("Permanent Address", "permanent_address",
            employee!['permanent_address']),
      ],
    );
  }

  // ================= JOB =================
  Widget _jobDetails() {
    return _section(
      title: "Job Details",
      color: const Color(0xFFEFF6FF),
      children: [
        _field("Employee ID", "emp_code", employee!['emp_code']),
        _field("Department", "department_id", employee!['department_id']),
        _field("Designation", "designation_id", employee!['designation_id']),
        _field(
          "Employee Type",
          "employee_type_id",
          employee!['employee_type_id'] == 2 ? "Contract" : "Regular",
        ),
        _field("Work Location", "work_location_id",
            employee!['work_location_id']),
        _field("Shift", "shift_id",
            employee!['shift_id'] == 1 ? "Day" : "Night"),
        _field("Reporting Manager", "manager_id", employee!['manager_id']),
        _field("Join Date", "join_date", employee!['join_date']),
        _field("Probation End", "probation_end_date",
            employee!['probation_end_date']),
        _field("Status", "is_active",
            employee!['is_active'] == true ? "Active" : "Inactive"),
        _field("UAN", "uan", employee!['uan']),
        _field("PAN", "pan", employee!['pan']),
        _field("Bank Account", "bank_ac_no", employee!['bank_ac_no']),
        _field("Aadhaar", "aadhaar", employee!['aadhaar']),
        _field("IFSC Code", "ifsc_code", employee!['ifsc_code']),
      ],
    );
  }

  // ================= FAMILY =================
  Widget _familyDetails() {
    final List<dynamic> family = employee!['family_members'] ?? [];

    return _section(
      title: "Family Details",
      color: const Color(0xFFFFF4EC),
      children: family.isEmpty
          ? [const Text("No family details available")]
          : family.asMap().entries.expand((entry) {
              final fm = entry.value;
              return [
                _field("Relation", null, fm['relation_id'], editable: false),
                _field(
                    "Name",
                    null,
                    "${fm['first_name']} ${fm['last_name']}",
                    editable: false),
                _field("Date of Birth", null, fm['date_of_birth'],
                    editable: false),
                _field("Occupation", null, fm['occupation_id'],
                    editable: false),
                _field("Phone", null, fm['phone'], editable: false),
                _field("Email", null, fm['email'], editable: false),
                _field("Bank Account", null, fm['bank_account'],
                    editable: false),
                _field("IFSC", null, fm['ifsc_code'], editable: false),
                _field("PAN", null, fm['pan'], editable: false),
                _field("Aadhaar", null, fm['aadhar'], editable: false),
                _field("Present Address", null, fm['present_address'],
                    editable: false),
                _field("Permanent Address", null, fm['permanent_address'],
                    editable: false),
                const Divider(height: 32),
              ];
            }).toList(),
    );
  }

  // ================= HELPERS =================
  Widget _card({required Widget child, required Color color}) {
    return Card(
      color: color,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Widget _section({
    required String title,
    required List<Widget> children,
    required Color color,
  }) {
    return _card(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _field(
    String label,
    String? keyName,
    dynamic value, {
    bool editable = true,
  }) {
    if (!isEditMode || !editable) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 6),
            Text(
              value?.toString() ?? "-",
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        initialValue: value?.toString(),
        decoration: InputDecoration(labelText: label),
        onChanged: (v) {
          if (keyName != null) payload[keyName] = v;
        },
      ),
    );
  }

  String _gender() {
    switch (employee!['gender_id']) {
      case 1:
        return "Male";
      case 2:
        return "Female";
      default:
        return "Other";
    }
  }

  String _marital() {
    switch (employee!['marital_status_id']) {
      case 1:
        return "Single";
      case 2:
        return "Married";
      default:
        return "Other";
    }
  }
}
