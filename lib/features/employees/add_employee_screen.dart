import 'package:flutter/material.dart';
import '../../common/widgets/hrms_app_bar.dart';
import '../../services/employee_service.dart';
import '../../models/employee_model.dart';
import 'widgets/employee_basic_details.dart';
import 'widgets/employee_personal_details.dart';
import 'widgets/employee_job_details.dart';
import 'widgets/employee_contact_details.dart';
// import 'widgets/family_member_form.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {

 final GlobalKey<EmployeeBasicDetailsState> _basicKey =
    GlobalKey<EmployeeBasicDetailsState>();

final GlobalKey<EmployeePersonalDetailsState> _personalKey =
    GlobalKey<EmployeePersonalDetailsState>();

final GlobalKey<EmployeeJobDetailsState> _jobKey =
    GlobalKey<EmployeeJobDetailsState>();

final GlobalKey<EmployeeContactDetailsState> _contactKey =
    GlobalKey<EmployeeContactDetailsState>();

  
  // final GlobalKey<EmployeePersonalDetailsState> _personalKey =
  //   GlobalKey<EmployeePersonalDetailsState>();

  String? _generalError;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  List<Employee> employees = [];
  bool _isSubmitting = false;
  
  @override
    void initState() {
      super.initState();
      _loadEmployees();
    }

   Future<void> _loadEmployees() async {
      final data = await EmployeeService.fetchEmployees();
      setState(() {
        employees = data;
      });
  }


  Future<void> _submit() async 
  {
      if (_isSubmitting) return; // 🔥 prevent double click

      if (!_formKey.currentState!.validate()) return;

      _formKey.currentState!.save();

      setState(() => _isSubmitting = true);

      try {
        await EmployeeService.createEmployee(formData);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employee added successfully")),
        );

        Navigator.pop(context, true);
      } 
      catch (e) 
      {

        final error = e.toString();
        setState(() => _generalError = null);

        if (error.contains("uk_employee_email")) {
          _personalKey.currentState
              ?.setServerEmailError("Email already exists");

        } else if (error.contains("uk_employee_pan")) {
          _jobKey.currentState
              ?.setServerPanError("PAN already exists");

        } else if (error.contains("uk_employee_aadhaar")) {
          _jobKey.currentState
              ?.setServerAadhaarError("Aadhaar already exists");

        } else if (error.contains("uk_employee_bank_ac_no")) {
          _jobKey.currentState
              ?.setServerBankError("Bank account already exists");

        } else if (error.contains("uk_employee_emp_code")) {
          _basicKey.currentState
              ?.setServerEmpIdError("Employee ID already exists");

        } else if (error.contains("uk_employee_mobile")) {
          _contactKey.currentState
              ?.setServerPhoneError("Phone already exists");

        } else if (error.contains("uk_employee_uan")) {
          _jobKey.currentState
              ?.setServerUanError("UAN already exists");

        } else {
          setState(() {
            _generalError = "Something went wrong. Please try again.";
          });
        }

      }

      finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: const HrmsAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // EmployeeBasicDetails(formData: formData),
              // EmployeePersonalDetails(formData: formData),
              // EmployeePersonalDetails(
              //   key: _personalKey,
              //   formData: formData,
              // ),

              // EmployeeJobDetails(formData: formData),
              // EmployeeContactDetails(formData: formData),
              // FamilyMemberForm(formData: formData),

              // const SizedBox(height: 24),

              EmployeeBasicDetails(
                key: _basicKey,
                formData: formData,
              ),

              EmployeePersonalDetails(
                key: _personalKey,
                formData: formData,
              ),

              EmployeeJobDetails(
                key: _jobKey,
                formData: formData,
              ),

              EmployeeContactDetails(
                key: _contactKey,
                formData: formData,
              ),



          const SizedBox(height: 16),

          if (_generalError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _generalError!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          const SizedBox(height: 8),


             Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,  // 🔥 disable when loading
                child: _isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Add Employee"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
