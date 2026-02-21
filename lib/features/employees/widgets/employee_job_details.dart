import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/section_title.dart';
import '../../../services/employee_service.dart';
import '../../../models/employee_model.dart';


class EmployeeJobDetails extends StatefulWidget {
  final Map<String, dynamic> formData;

  const EmployeeJobDetails({
    super.key,
    required this.formData,
  });

  @override
  State<EmployeeJobDetails> createState() => EmployeeJobDetailsState();
}

class EmployeeJobDetailsState extends State<EmployeeJobDetails> {
  final TextEditingController _joinDateController = TextEditingController();
  final TextEditingController _probationEndController = TextEditingController();
  final TextEditingController _hiredDateController = TextEditingController();

  DateTime? _selectedJoinDate;
  // DateTime? _selectedProbationEnd;
  // DateTime? _selectedHiredDate;

  List<Employee> _employees = [];
  bool _loadingEmployees = true;



    String? _serverPanError;
    String? _serverAadhaarError;
    String? _serverBankError;
    String? _serverUanError;

    void setServerPanError(String? message) {
      setState(() {
        _serverPanError = message;
      });
    }

    void setServerAadhaarError(String? message) {
      setState(() {
        _serverAadhaarError = message;
      });
    }

    void setServerBankError(String? message) {
      setState(() {
        _serverBankError = message;
      });
    }

    void setServerUanError(String? message) {
      setState(() {
        _serverUanError = message;
      });
    }


  
  @override
void initState() {
  super.initState();
  _loadEmployees();
}


// Future<void> _loadEmployees() async 
// {
//   try {
//     final data = await EmployeeService.fetchEmployees();
//     setState(() {
//       _employees = data;
//       _loadingEmployees = false;
//     });
//   } catch (e) {
//     setState(() {
//       _loadingEmployees = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Failed to load managers")),
//     );
//   }
// }



Future<void> _loadEmployees() async {
  try {
    final data = await EmployeeService.fetchEmployees();

    if (!mounted) return;

    setState(() {
      _employees = data;
      _loadingEmployees = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _loadingEmployees = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to load managers")),
    );
  }
}


  @override
  void dispose() {
    _joinDateController.dispose();
    _probationEndController.dispose();
    _hiredDateController.dispose();
    super.dispose();
  }

  Future<void> _pickHiredDate(BuildContext context) async {
  final date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1990),
    lastDate: DateTime(2100),
  );

  if (date != null) {
    final formatted = DateFormat('yyyy-MM-dd').format(date);
    setState(() {
      // _selectedHiredDate = date;
      _hiredDateController.text = formatted;
      widget.formData["hired_date"] = formatted;
    });
  }
}


  Future<void> _pickJoinDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedJoinDate = date;
        final formattedDate = DateFormat('yyyy-MM-dd').format(date);
        _joinDateController.text = formattedDate;
        widget.formData["join_date"] = formattedDate;

        // Auto-calculate probation end date (90 days)
        final probationEnd = date.add(const Duration(days: 90));
        // _selectedProbationEnd = probationEnd;
        final formattedProbation = DateFormat('yyyy-MM-dd').format(probationEnd);
        _probationEndController.text = formattedProbation;
        widget.formData["probation_end_date"] = formattedProbation;
      });
    }
  }

  Future<void> _pickProbationDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedJoinDate?.add(const Duration(days: 90)) ??
          DateTime.now(),
      firstDate: _selectedJoinDate ?? DateTime(1990),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        // _selectedProbationEnd = date;
        final formattedDate = DateFormat('yyyy-MM-dd').format(date);
        _probationEndController.text = formattedDate;
        widget.formData["probation_end_date"] = formattedDate;
      });
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
          onSaved: (v) => widget.formData["role_id"] = v,
        ),

        _space(),

        _dropdown(
          label: "Department *",
        items: const {
          1: "Business & Operations",
          2: "Media & Communication",
          3: "People & Support",
          4: "Legal, Risk & Compliance",
          5: "Supply Chain & Procurement",
          6: "Management & Strategy",
          7: "Technology & Engineering",
          8: "Information Technology",
          9: "Software Development",
          10: "DevOps & Cloud",
          11: "Quality Assurance",
          12: "Cyber Security",
          13: "Data & Analytics",
        },
          onSaved: (v) => widget.formData["department_id"] = v,
        ),

        _space(),

       _dropdown(
            label: "Designation *",
            items: const {
              32: "HR",
              2: "Business Analyst",
              1: "Operations Manager",
              3: "Content Manager",
              4: "Digital Marketing Executive",
              5: "HR Executive",
              6: "Talent Acquisition Specialist",
              7: "Legal Officer",
              8: "Compliance Manager",
              9: "Procurement Executive",
              10: "Logistics Coordinator",
              11: "Project Manager",
              12: "Strategy Analyst",
              13: "Technology Lead",
              14: "IT Support Engineer",
              15: "Software Engineer",
              16: "DevOps Engineer",
              17: "QA Engineer",
              18: "Security Analyst",
              19: "Data Analyst",
              34: "Support Care",
              35: "PowerBI",
            },
            onSaved: (v) => widget.formData["designation_id"] = v,
          ),


        _space(),

        _dropdown(
          label: "Employee Type *",
          items: const {
            1: "Regular",
            2: "Contract",
            3: "Intern",
          },
          onSaved: (v) => widget.formData["employee_type_id"] = v,
        ),

        _space(),

        _dropdown(
          label: "Work Location *",
          items: const {
            1: "Hyderabad",
            2: "Bangalore",
            3: "Chennai",
            4: "Mumbai",
            5: "Delhi",
          },
          onSaved: (v) => widget.formData["work_location_id"] = v,
        ),

        _space(),

        _dropdown(
          label: "Shift *",
          items: const {
            1: "Day",
            2: "Night",
            3: "Flexible",
          },
          onSaved: (v) => widget.formData["shift_id"] = v,
        ),

        _space(),

      
_loadingEmployees
    ? const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: LinearProgressIndicator(),
      )
    : Builder(
        builder: (_) {

          // ✅ ADD THIS LINE HERE
          final managers =
              _employees.where((e) => e.roleId == 3).toList();

          return DropdownButtonFormField<int>(
            decoration:
                const InputDecoration(labelText: "Reporting Manager *"),
            items: managers
                .map(
                  (e) => DropdownMenuItem(
                    value: int.parse(e.id),
                    child: Text("${e.name} (${e.empId})"),
                  ),
                )
                .toList(),
            validator: (v) => v == null ? "Required" : null,
            onChanged: (v) => widget.formData["manager_id"] = v,
            onSaved: (v) => widget.formData["manager_id"] = v,
          );
        },
      ),



        _space(),

        _space(),

        // Join Date
       TextFormField(
            controller: _joinDateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Joining Date *",
              suffixIcon: Icon(Icons.calendar_today),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return "Required";

              final hired = widget.formData["hired_date"];

              if (hired != null && hired.toString().isNotEmpty) {
                // final joinDate = DateTime.parse(v);
                final probationDate = DateTime.parse(v);
                final hiredDate = DateTime.parse(hired);

                if (probationDate.isBefore(hiredDate)) {
                  return "Joining date cannot be before hired date";
                }
              }

              return null;
            },
            onTap: () => _pickJoinDate(context),
          ),

        

        _space(),

    _space(),

      TextFormField(
        controller: _hiredDateController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: "Hired Date",
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () => _pickHiredDate(context),
      ),


        _space(),

        // Probation End Date
        TextFormField
        (
          controller: _probationEndController,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: "Probation End Date *",
            suffixIcon: Icon(Icons.calendar_today),
          ),
          // validator: (v) => v == null || v.isEmpty ? "Required" : null,
          validator: (v) {
          if (v == null || v.isEmpty) return "Required";

          final hired = widget.formData["hired_date"];
          if (hired != null) {
            final joinDate = DateTime.parse(v);
            final hiredDate = DateTime.parse(hired);

            if (joinDate.isBefore(hiredDate)) {
              return "Joining date cannot be before hired date";
            }
          }

          return null;
        },

          onTap: () => _pickProbationDate(context),
        ),


        _space(),

        _dropdown(
          label: "Status *",
          items: const {
            1: "Active",
            2: "Inactive",
            3: "On Leave",
            4: "Resigned",
          },
          onSaved: (v) => widget.formData["status_id"] = v,
        ),


        _space(),

        _textField(
          label: "Salary *",
          required: true,
          keyboard: TextInputType.number,
          onSaved: (v) => widget.formData["salary"] =
              v != null && v.isNotEmpty ? int.tryParse(v) ?? 0 : 0,
        ),

        _space(),

        _textField(
          label: "CTC *",
          required: true,
          keyboard: TextInputType.number,
          onSaved: (v) => widget.formData["ctc"] =
              v != null && v.isNotEmpty ? int.tryParse(v) ?? 0 : 0,
        ),

        _space(),

        // _textField(
        //   label: "UAN",
        //   hint: "Enter 12-digit UAN",
        //   // onSaved: (v) => widget.formData["uan"] = v ?? '',
        //   onSaved: (v) =>
        //     widget.formData["uan"] =
        //         (v == null || v.trim().isEmpty) ? null : v,

        // ),


        TextFormField(
          decoration: InputDecoration(
            labelText: "UAN",
            hintText: "Enter 12-digit UAN",
            errorText: _serverUanError,
          ),
          onChanged: (v) {
            setState(() => _serverUanError = null);
          },
          onSaved: (v) =>
              widget.formData["uan"] =
                  (v == null || v.trim().isEmpty) ? null : v,
        ),


        _space(),

        // TextFormField(
        //   decoration: InputDecoration(
        //     labelText: "PAN *",
        //     hintText: "ABCDE1234F",
        //     errorText: "PAN alreadry exists", // we will handle from parent later
        //   ),
        //   validator: (v) => v == null || v.isEmpty ? "Required" : null,
        //   onSaved: (v) => widget.formData["pan"] = v,
        // ),


        TextFormField(
            decoration: InputDecoration(
              labelText: "PAN *",
              hintText: "ABCDE1234F",
              errorText: _serverPanError,
            ),
            validator: (v) => v == null || v.isEmpty ? "Required" : null,
            onChanged: (v) {
              setState(() => _serverPanError = null);
            },
            onSaved: (v) => widget.formData["pan"] = v,
          ),



        _space(),

      // _textField
      // (
      //   label: "Aadhaar *",
      //   hint: "Enter 12-digit Aadhaar",
      //   required: true,
      //   keyboard: TextInputType.number,
      //   onSaved: (v) => widget.formData["aadhaar"] = v,
      // ),

      TextFormField(
          decoration: InputDecoration(
            labelText: "Aadhaar *",
            hintText: "Enter 12-digit Aadhaar",
            errorText: _serverAadhaarError,
          ),
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          onChanged: (v) {
            setState(() => _serverAadhaarError = null);
          },
          onSaved: (v) => widget.formData["aadhaar"] = v,
        ),



        _space(),

        // _textField(
        //   label: "Bank Account *",
        //   required: true,
        //   keyboard: TextInputType.number,
        //   // onSaved: (v) => widget.formData["bank_ac_no"] = v ?? '',
        //   onSaved: (v) =>
        //     widget.formData["bank_ac_no"] =
        //         (v == null || v.trim().isEmpty) ? null : v,

        // ),



        TextFormField(
          decoration: InputDecoration(
            labelText: "Bank Account *",
            errorText: _serverBankError,
          ),
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          onChanged: (v) {
            setState(() => _serverBankError = null);
          },
          onSaved: (v) =>
              widget.formData["bank_ac_no"] =
                  (v == null || v.trim().isEmpty) ? null : v,
        ),




        _space(),

        _textField(
          label: "IFSC *",
          hint: "HDFC0001234",
          required: true,
          onSaved: (v) => widget.formData["ifsc_code"] = v ?? '',
        ),

        _space(),

        _textField(
          label: "ESIC",
          onSaved: (v) => widget.formData["esic"] = v ?? '',
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
      onChanged: (v) => onSaved(v),
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
}