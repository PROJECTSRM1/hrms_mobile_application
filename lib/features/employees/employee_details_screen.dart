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
  Map<String, dynamic>? employee;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: const HrmsAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : employee == null
              ? const Center(child: Text("Employee not found"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _editButton(),
                      _headerCard(),
                      _personalDetails(),
                      _jobDetails(),
                      _familyDetails(),
                    ],
                  ),
                ),
    );
  }

  // ================= EDIT =================
  Widget _editButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () {},
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
          const CircleAvatar(radius: 26, backgroundColor: Colors.deepPurple),
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
        _field("Email", employee!['email']),
        _field("Phone", employee!['mobile']),
        _field("Date of Birth", employee!['date_of_birth']),
        _field("Gender", _gender()),
        _field("Marital Status", _marital()),
        _field("Blood Group", employee!['blood_group_id']),
        _field("Present Address", employee!['present_address']),
        _field("Permanent Address", employee!['permanent_address']),
      ],
    );
  }

  // ================= JOB =================
  Widget _jobDetails() {
    return _section(
      title: "Job Details",
      color: const Color(0xFFEFF6FF),
      children: [
        _field("Employee ID", employee!['emp_code']),
        _field("Department", employee!['department_id']),
        _field("Designation", employee!['designation_id']),
        _field(
          "Employee Type",
          employee!['employee_type_id'] == 2 ? "Contract" : "Regular",
        ),
        _field("Work Location", employee!['work_location_id']),
        _field("Shift", employee!['shift_id'] == 1 ? "Day" : "Night"),
        _field("Reporting Manager", employee!['manager_id']),
        _field("Join Date", employee!['join_date']),
        _field("Probation End", employee!['probation_end_date']),
        _field(
          "Status",
          employee!['is_active'] == true ? "Active" : "Inactive",
        ),
        _field("UAN", employee!['uan']),
        _field("PAN", employee!['pan']),
        _field("Bank Account", employee!['bank_ac_no']),
        _field("Aadhaar", employee!['aadhaar']),
        _field("IFSC Code", employee!['ifsc_code']),
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
              final i = entry.key + 1;
              final fm = entry.value;

              return [
                Text(
                  "Member $i",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                _field("Relation", fm['relation_id']),
                _field(
                    "Name",
                    "${fm['first_name']} ${fm['last_name']}"),
                _field("Date of Birth", fm['date_of_birth']),
                _field("Occupation", fm['occupation_id']),
                _field("Phone", fm['phone']),
                _field("Email", fm['email']),
                _field("Bank Account", fm['bank_account']),
                _field("IFSC", fm['ifsc_code']),
                _field("PAN", fm['pan']),
                _field("Aadhaar", fm['aadhar']),
                _field("Present Address", fm['present_address']),
                _field("Permanent Address", fm['permanent_address']),
                if (i != family.length)
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
          Text(
            title,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _field(String label, dynamic value) {
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
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
