import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/section_title.dart';

class EmployeePersonalDetails extends StatefulWidget {
  final Map<String, dynamic> formData;

  const EmployeePersonalDetails({
    super.key,
    required this.formData,
  });

  @override
  State<EmployeePersonalDetails> createState() =>
      EmployeePersonalDetailsState();
}

class EmployeePersonalDetailsState extends State<EmployeePersonalDetails>{
  final TextEditingController _dobController = TextEditingController();
  // DateTime? _selectedDob;
  String? _serverEmailError;
  // String? _serverPanError;
  // String? _serverAadhaarError;
  // String? _serverBankError;

  // String? _panError;
  // String? _aadhaarError;
  // String? _phoneError;
  // String? _empIdError;
  // String? _uanError;




  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  final TextEditingController _emailController = TextEditingController();
  // String? _emailError;

      void setServerEmailError(String? message) {
        setState(() {
          _serverEmailError = message;
        });
      }
      

      // String? _serverEmpIdError;

      // void setServerEmpIdError(String? message) {
      //   setState(() {
      //     _serverEmpIdError = message;
      //   });
      // }

      // String? _serverPhoneError;

      // void setServerPhoneError(String? message) {
      //   setState(() {
      //     _serverPhoneError = message;
      //   });
      // }


  // void setServerEmailError(String? message) {
  //     setState(() => _serverEmailError = message);
  //   }

    // void setServerBankError(String? message) {
    //   setState(() => _serverBankError = message);
    // }


    // void setServerPanError(String message) {
    //   setState(() =>  _serverPanError = message);
    // }

    // void setServerAadhaarError(String message) {
    //   setState(() => _serverAadhaarError= message);
    // }

    // void setServerPhoneError(String message) {
    //   setState(() => _phoneError = message);
    // }

    // void setServerEmpIdError(String message) {
    //   setState(() => _empIdError = message);
    // }

    // void setServerUanError(String message) {
    //   setState(() => _uanError = message);
    // }





  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
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

    // if (date != null) 
    // {
    //   setState(() {
    //     _selectedDob = date;
    //     final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    //     _dobController.text = formattedDate;
    //     widget.formData["date_of_birth"] = formattedDate;
    //   });
    // }


    if (date != null) {
        final formattedDate = DateFormat('yyyy-MM-dd').format(date);
        _dobController.text = formattedDate;
        widget.formData["date_of_birth"] = formattedDate;
      }


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Personal Details"),
        const SizedBox(height: 16),

        /// Date of Birth
        TextFormField(
          controller: _dobController,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: "Date of Birth *",
            suffixIcon: Icon(Icons.calendar_today),
          ),
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          onTap: () => _pickDate(context),
        ),

        const SizedBox(height: 16),

        /// Gender
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: "Gender *"),
          items: const [
            DropdownMenuItem(value: 1, child: Text("Male")),
            DropdownMenuItem(value: 2, child: Text("Female")),
            DropdownMenuItem(value: 3, child: Text("Other")),
          ],
          validator: (v) => v == null ? "Required" : null,
          onChanged: (v) => widget.formData["gender_id"] = v,
          onSaved: (v) => widget.formData["gender_id"] = v,
        ),

        const SizedBox(height: 16),

        /// Marital Status
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: "Marital Status *"),
          items: const [
            DropdownMenuItem(value: 1, child: Text("Single")),
            DropdownMenuItem(value: 2, child: Text("Married")),
            DropdownMenuItem(value: 3, child: Text("Other")),
            // DropdownMenuItem(value: 3, child: Text("Divorced")),
            // DropdownMenuItem(value: 4, child: Text("Widowed")),
          ],
          validator: (v) => v == null ? "Required" : null,
          onChanged: (v) => widget.formData["marital_status_id"] = v,
          onSaved: (v) => widget.formData["marital_status_id"] = v,
        ),

        const SizedBox(height: 16),

        /// Email
        // TextFormField
        // (
        //   decoration: const InputDecoration(
        //     labelText: "Email *",
        //     hintText: "example@gmail.com",
        //   ),
        //   keyboardType: TextInputType.emailAddress,
        //   validator: (v) {
        //     if (v == null || v.isEmpty) return "Required";
        //     if (!v.contains("@")) return "Enter valid email";
        //     return null;
        //   },
        //   onSaved: (v) => widget.formData["email"] = v,
        // ),

        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email *",
            hintText: "example@gmail.com",
            errorText: _serverEmailError,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.isEmpty) return "Required";
            if (!v.contains("@")) return "Enter valid email";
            return null;
          },
          // onSaved: (v) => widget.formData["email"] = v,
          // onChanged: (v) {
          //   _serverEmailError = null;
          // },

          onChanged: (v) {
            setState(() {
              _serverEmailError = null;
            });
          },

          onSaved: (v) => widget.formData["email"] = v,

        ),


        

        // String get email => _emailController.text.trim();

        const SizedBox(height: 16),

        /// Present Address
        TextFormField(
          maxLines: 3,
          decoration: const InputDecoration(labelText: "Present Address *"),
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          onSaved: (v) => widget.formData["present_address"] = v,
        ),

        const SizedBox(height: 16),

        /// Permanent Address
        TextFormField(
          maxLines: 3,
          decoration: const InputDecoration(labelText: "Permanent Address *"),
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          onSaved: (v) => widget.formData["permanent_address"] = v,
        ),
      ],
    );
  }
}
