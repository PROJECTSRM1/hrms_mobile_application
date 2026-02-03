import 'package:flutter/material.dart';
import '../../common/widgets/hrms_app_bar.dart';
import '../../services/employee_service.dart';

import 'widgets/employee_basic_details.dart';
import 'widgets/employee_personal_details.dart';
import 'widgets/employee_job_details.dart';
import 'widgets/employee_contact_details.dart';
import 'widgets/family_member_form.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await EmployeeService.createEmployee(formData);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employee added successfully")),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add employee")),
        );
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
              EmployeeBasicDetails(formData: formData),
              EmployeePersonalDetails(formData: formData),
              EmployeeJobDetails(formData: formData),
              EmployeeContactDetails(formData: formData),
              FamilyMemberForm(formData: formData),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text("Add Employee"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
