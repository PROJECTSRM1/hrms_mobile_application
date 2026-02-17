// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/leave_api_service.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();

  final reasonCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();

  DateTime? fromDate;
  DateTime? toDate;

  String? leaveType;
  String? fromSession;
  String? toSession;
  String? reportingManager;
  String? ccEmployee;

  File? selectedFile;
  bool loading = false;

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Apply Leave'),
        backgroundColor: const Color(0xFF0AA6B7),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: _card(
            Column(
              children: [
                _dropdown(
                  "Leave Type *",
                  ["Sick Leave", "Casual Leave"],
                  (v) => leaveType = v,
                ),
                _gap(),

                _dropdown(
                  "Reporting Manager *",
                  ["Manager A", "Manager B"],
                  (v) => reportingManager = v,
                ),
                _gap(),

                _datePicker("From Date *", fromDate,
                    (d) => setState(() => fromDate = d)),
                _gap(),

                _dropdown(
                  "From Session *",
                  ["Morning", "Afternoon"],
                  (v) => fromSession = v,
                ),
                _gap(),

                _datePicker("To Date *", toDate,
                    (d) => setState(() => toDate = d)),
                _gap(),

                _dropdown(
                  "To Session *",
                  ["Morning", "Afternoon"],
                  (v) => toSession = v,
                ),
                _gap(),

                _dropdown(
                  "CC",
                  ["Employee A", "Employee B"],
                  (v) => ccEmployee = v,
                ),
                _gap(),

                _mobileField(),
                _gap(),

                _uploadButton(),
                _gap(),

                _reasonField(),
                _gap(height: 24),

                _actionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- UI HELPERS --------------------

  Widget _dropdown(
      String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: _inputDecoration(label),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: label.contains('*')
          ? (v) => v == null ? "Required" : null
          : null,
    );
  }

  Widget _datePicker(
      String label, DateTime? value, Function(DateTime) onPick) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        if (picked != null) onPick(picked);
      },
      child: InputDecorator(
        decoration: _inputDecoration(label),
        child: Text(
          value == null
              ? "Select date"
              : value.toIso8601String().split('T')[0],
        ),
      ),
    );
  }

  Widget _mobileField() {
    return TextFormField(
      controller: mobileCtrl,
      keyboardType: TextInputType.phone,
      decoration:
          _inputDecoration("Mobile Number *").copyWith(prefixText: "+91 "),
      validator: (v) =>
          v == null || v.length < 10 ? "Invalid mobile number" : null,
    );
  }

  Widget _uploadButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: Text(
        selectedFile == null
            ? "Upload File"
            : selectedFile!.path.split('/').last,
      ),
      onPressed: () async {
        final image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() => selectedFile = File(image.path));
        }
      },
    );
  }

  Widget _reasonField() {
    return TextFormField(
      controller: reasonCtrl,
      maxLines: 4,
      decoration: _inputDecoration("Reason *"),
      validator: (v) => v == null || v.isEmpty ? "Enter reason" : null,
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0AA6B7),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: loading ? null : _submit,
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Apply"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ),
      ],
    );
  }

  // -------------------- SUBMIT --------------------

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final success = await LeaveApiService.applyLeave(
      leaveTypeId: leaveType == "Sick Leave" ? 1 : 2,
      startDate: fromDate!.toIso8601String().split('T')[0],
      endDate: toDate!.toIso8601String().split('T')[0],
      fromSession: fromSession == "Morning" ? "FN" : "AN",
      toSession: toSession == "Morning" ? "FN" : "AN",
      reason: reasonCtrl.text,
      mobile: mobileCtrl.text,
      reportingManagerId: 1,
      file: selectedFile,
    );

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            success ? "Leave applied successfully" : "Failed to apply leave"),
      ),
    );

    if (success) Navigator.pop(context);
  }

  // -------------------- COMMON --------------------

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _gap({double height = 16}) => SizedBox(height: height);

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
