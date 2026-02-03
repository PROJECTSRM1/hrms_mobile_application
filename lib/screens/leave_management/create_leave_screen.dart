// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController reasonCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  DateTime? fromDate;
  DateTime? toDate;

  String? leaveType;
  String? reportingManager;
  String? fromSession;
  String? toSession;
  String? ccEmployee;

  File? selectedFile;
  bool loading = false;

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Apply Leave"),
        backgroundColor: const Color(0xFF0AA6B7),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: _card(
            Column(
              children: [
                _dropdown("Leave Type *", ["Sick Leave", "Casual Leave"],
                    (v) => leaveType = v),
                _gap(),

                _dropdown("Reporting Manager *", ["Manager A", "Manager B"],
                    (v) => reportingManager = v),
                _gap(),

                _datePicker("From Date *", fromDate,
                    (d) => setState(() => fromDate = d)),
                _gap(),

                _dropdown("From Session *", ["Morning", "Afternoon"],
                    (v) => fromSession = v),
                _gap(),

                _datePicker("To Date *", toDate,
                    (d) => setState(() => toDate = d)),
                _gap(),

                _dropdown("To Session *", ["Morning", "Afternoon"],
                    (v) => toSession = v),
                _gap(),

                _dropdown("CC", ["Employee A", "Employee B"],
                    (v) => ccEmployee = v),
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

  // ---------------- WIDGETS ----------------

  Widget _dropdown(
      String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: _inputDecoration(label),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: label.contains("*")
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
          value == null ? "Select date" : value.toString().split(" ")[0],
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
      validator: (v) => v == null || v.length < 10 ? "Invalid number" : null,
    );
  }

  /// 📷 Image picker (Gallery)
  Widget _uploadButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: Text(
        selectedFile == null
            ? "Upload File"
            : selectedFile!.path.split('/').last,
      ),
      onPressed: () async {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image != null) {
          setState(() {
            selectedFile = File(image.path);
          });
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
            onPressed: loading ? null : _submitLeave,
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

  // ---------------- API ----------------

  Future<void> _submitLeave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("https://hrms-be-ppze.onrender.com/leave/apply"),
    );

    request.headers["Accept"] = "application/json";

    request.fields.addAll({
      "emp_id": "1",
      "leavetype_id": "1",
      "start_date": fromDate.toString().split(" ")[0],
      "end_date": toDate.toString().split(" ")[0],
      "from_date_session_id": fromSession == "Morning" ? "1" : "2",
      "to_date_session_id": toSession == "Morning" ? "1" : "2",
      "reason": reasonCtrl.text,
      "mobile": mobileCtrl.text,
      "reporting_manager_id": "1",
      "cc": "",
    });

    if (selectedFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "upload_file",
          selectedFile!.path,
        ),
      );
    }

    final response = await request.send();

    setState(() => loading = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Leave Applied Successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed (${response.statusCode})")),
      );
    }
  }

  // ---------------- HELPERS ----------------

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
