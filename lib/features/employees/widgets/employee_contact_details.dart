
// import 'package:flutter/material.dart';
// import '../../../common/widgets/section_title.dart';

// class EmployeeContactDetails extends StatelessWidget {
//   final Map<String, dynamic> formData;

//   const EmployeeContactDetails({super.key, required this.formData});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle("Contact Info"),
//         const SizedBox(height: 16),

//         TextFormField(
//           decoration: const InputDecoration(
//             labelText: "Phone Number *",
//           ),
//           keyboardType: TextInputType.phone,
//           validator: (v) {
//             if (v == null || v.isEmpty) return "Required";
//             if (v.length != 10) return "Enter 10-digit phone";
//             return null;
//           },
//           onSaved: (v) => formData["mobile"] = v,
//         ),

//         const SizedBox(height: 16),

//        TextFormField(
//           decoration: const InputDecoration(
//             labelText: "Emergency Mobile *",
//             hintText: "Enter 10-digit emergency number",
//           ),
//           keyboardType: TextInputType.phone,
//           validator: (v) {
//             if (v == null || v.isEmpty) return "Required";
//             if (v.length != 10) return "Enter valid 10-digit number";
//             return null;
//           },
//           onSaved: (v) => formData["emergency_mobile"] = v,
//         ),


//         const SizedBox(height: 16),

//         TextFormField(
//           decoration: const InputDecoration(
//             labelText: "Reference Mobile",
//           ),
//           keyboardType: TextInputType.phone,
//           validator: (v) {
//             if (v != null && v.isNotEmpty && v.length != 10) {
//               return "Enter 10-digit number";
//             }
//             return null;
//           },
//           onSaved: (v) => formData["reference_mobile"] = v ?? '',
//         ),
//       ],
//     );
//   }
// }








import 'package:flutter/material.dart';
import '../../../common/widgets/section_title.dart';

class EmployeeContactDetails extends StatefulWidget {
  final Map<String, dynamic> formData;

  const EmployeeContactDetails({
    super.key,
    required this.formData,
  });

  @override
  State<EmployeeContactDetails> createState() =>
      EmployeeContactDetailsState();
}

class EmployeeContactDetailsState
    extends State<EmployeeContactDetails> {

  String? _serverPhoneError;

  void setServerPhoneError(String? message) {
    setState(() {
      _serverPhoneError = message;
    });
  }

  Widget _space() => const SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Contact Details"),
        _space(),

        /// ================= PHONE =================
        TextFormField(
          decoration: InputDecoration(
            labelText: "Phone Number *",
            errorText: _serverPhoneError,
          ),
          keyboardType: TextInputType.phone,
          validator: (v) {
            if (v == null || v.isEmpty) return "Required";
            if (v.length != 10) return "Enter valid 10-digit number";
            return null;
          },
          onChanged: (v) {
            setState(() => _serverPhoneError = null);
          },
          onSaved: (v) =>
              widget.formData["mobile"] = v,
        ),

        _space(),

        /// ================= EMERGENCY MOBILE =================
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Emergency Mobile *",
          ),
          keyboardType: TextInputType.phone,
          validator: (v) {
            if (v == null || v.isEmpty) return "Required";
            if (v.length != 10) return "Enter valid 10-digit number";
            return null;
          },
          onSaved: (v) =>
              widget.formData["emergency_mobile"] = v,
        ),

        _space(),

        /// ================= REFERENCE MOBILE =================
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Reference Mobile",
          ),
          keyboardType: TextInputType.phone,
          onSaved: (v) =>
              widget.formData["reference_mobile"] =
                  (v == null || v.isEmpty) ? null : v,
        ),
      ],
    );
  }
}
