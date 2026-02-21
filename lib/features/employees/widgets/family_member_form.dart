// import 'package:flutter/material.dart';
// import '../../../common/widgets/section_title.dart';

// class FamilyMemberForm extends StatefulWidget {
//   final Map<String, dynamic> formData;

//   const FamilyMemberForm({
//     super.key,
//     required this.formData,
//   });

//   @override
//   State<FamilyMemberForm> createState() => _FamilyMemberFormState();
// }

// class _FamilyMemberFormState extends State<FamilyMemberForm> {
//   final List<Map<String, dynamic>> members = [];

//   void _addMember() => setState(() => members.add({}));

//   void _removeMember(int index) =>
//       setState(() => members.removeAt(index));

//   Future<void> _pickDate(
//     BuildContext context,
//     Function(String) onSelected,
//   ) async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1950),
//       lastDate: DateTime(2100),
//     );

//     if (date != null) {
//       onSelected(date.toIso8601String().split("T").first);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     widget.formData["family_members"] = members;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle("Family Members"),
//         const SizedBox(height: 16),

//         ...members.asMap().entries.map((entry) {
//           final index = entry.key;
//           final member = entry.value;

//           return Card(
//             margin: const EdgeInsets.only(bottom: 20),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   /// Relation
//                   DropdownButtonFormField<int>(
//                     decoration:
//                         const InputDecoration(labelText: "Relation *"),
//                     items: const [
//                       DropdownMenuItem(value: 1, child: Text("Father")),
//                       DropdownMenuItem(value: 2, child: Text("Mother")),
//                       DropdownMenuItem(value: 3, child: Text("Spouse")),
//                       DropdownMenuItem(value: 4, child: Text("Child")),
//                     ],
//                     validator: (v) => v == null ? "Required" : null,
//                     onChanged: (_) {},
//                     onSaved: (v) => member["relation_id"] = v,
//                   ),

//                   const SizedBox(height: 16),

//                   /// First Name
//                   TextFormField(
//                     decoration:
//                         const InputDecoration(labelText: "First Name *"),
//                     validator: (v) =>
//                         v == null || v.isEmpty ? "Required" : null,
//                     onSaved: (v) => member["first_name"] = v,
//                   ),

//                   const SizedBox(height: 16),

//                   /// Last Name
//                   TextFormField(
//                     decoration:
//                         const InputDecoration(labelText: "Last Name *"),
//                     validator: (v) =>
//                         v == null || v.isEmpty ? "Required" : null,
//                     onSaved: (v) => member["last_name"] = v,
//                   ),

//                   const SizedBox(height: 16),

//                   /// Date of Birth
//                   TextFormField(
//                     readOnly: true,
//                     decoration: const InputDecoration(
//                       labelText: "Date of Birth *",
//                       suffixIcon: Icon(Icons.calendar_today),
//                     ),
//                     validator: (v) =>
//                         v == null || v.isEmpty ? "Required" : null,
//                     onTap: () => _pickDate(
//                       context,
//                       (v) => member["date_of_birth"] = v,
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   /// Occupation
//                   DropdownButtonFormField<int>(
//                     decoration:
//                         const InputDecoration(labelText: "Occupation *"),
//                     items: const [
//                       DropdownMenuItem(value: 1, child: Text("Private")),
//                       DropdownMenuItem(value: 2, child: Text("Government")),
//                       DropdownMenuItem(value: 3, child: Text("Business")),
//                       DropdownMenuItem(value: 4, child: Text("Student")),
//                     ],
//                     validator: (v) => v == null ? "Required" : null,
//                     onChanged: (_) {},
//                     onSaved: (v) => member["occupation_id"] = v,
//                   ),

//                   const SizedBox(height: 16),

//                   /// Phone
//                   TextFormField(
//                     decoration:
//                         const InputDecoration(labelText: "Phone Number"),
//                     keyboardType: TextInputType.phone,
//                     onSaved: (v) => member["phone"] = v,
//                   ),

//                   const SizedBox(height: 16),

//                   /// Email
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: "Email",
//                       hintText: "example@gmail.com",
//                     ),
//                     onSaved: (v) => member["email"] = v,
//                   ),

//                   const SizedBox(height: 16),

//                   /// Present Address
//                   TextFormField(
//                     maxLines: 3,
//                     decoration: const InputDecoration(
//                         labelText: "Present Address *"),
//                     validator: (v) =>
//                         v == null || v.isEmpty ? "Required" : null,
//                     onSaved: (v) => member["present_address"] = v,
//                   ),

//                   const SizedBox(height: 16),

//                   /// Permanent Address
//                   TextFormField(
//                     maxLines: 3,
//                     decoration: const InputDecoration(
//                         labelText: "Permanent Address *"),
//                     validator: (v) =>
//                         v == null || v.isEmpty ? "Required" : null,
//                     onSaved: (v) => member["permanent_address"] = v,
//                   ),

//                   const SizedBox(height: 16),

//                   /// Bank Account
//                   TextFormField(
//                     decoration:
//                         const InputDecoration(labelText: "Bank Account"),
//                     onSaved: (v) => member["bank_account"] = v,
//                   ),

//                   const SizedBox(height: 16),

//                   /// IFSC
//                   TextFormField(
//                     decoration:
//                         const InputDecoration(labelText: "IFSC Code"),
//                     onSaved: (v) => member["ifsc_code"] = v,
//                   ),

//                   const SizedBox(height: 16),

//                   /// PAN
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "PAN"),
//                     onSaved: (v) => member["pan"] = v,
//                   ),

//                   const SizedBox(height: 16),

//                   /// Aadhaar
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: "Aadhaar *",
//                       hintText: "Enter 12-digit Aadhaar",
//                     ),
//                     validator: (v) =>
//                         v == null || v.isEmpty ? "Required" : null,
//                     onSaved: (v) => member["aadhar"] = v,
//                   ),

//                   const SizedBox(height: 20),

//                   /// Remove
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: OutlinedButton.icon(
//                       onPressed: () => _removeMember(index),
//                       icon:
//                           const Icon(Icons.delete, color: Colors.red),
//                       label: const Text(
//                         "Remove Member",
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),

//         /// Add Member
//         OutlinedButton.icon(
//           onPressed: _addMember,
//           icon: const Icon(Icons.add),
//           label: const Text("Add Family Member"),
//         ),
//       ],
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/section_title.dart';

class FamilyMemberForm extends StatefulWidget {
  final Map<String, dynamic> formData;

  const FamilyMemberForm({
    super.key,
    required this.formData,
  });

  @override
  State<FamilyMemberForm> createState() => _FamilyMemberFormState();
}

class _FamilyMemberFormState extends State<FamilyMemberForm> {
  final List<Map<String, dynamic>> members = [];
  final Map<int, TextEditingController> _dobControllers = {};

  @override
  void dispose() {
    for (var controller in _dobControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addMember() {
    setState(() {
      final index = members.length;
      members.add({});
      _dobControllers[index] = TextEditingController();
    });
  }

  void _removeMember(int index) {
    setState(() {
      _dobControllers[index]?.dispose();
      _dobControllers.remove(index);
      members.removeAt(index);
      
      // Rebuild controllers map with new indices
      final newControllers = <int, TextEditingController>{};
      for (int i = 0; i < members.length; i++) {
        if (i < index && _dobControllers[i] != null) {
          newControllers[i] = _dobControllers[i]!;
        } else if (i >= index && _dobControllers[i + 1] != null) {
          newControllers[i] = _dobControllers[i + 1]!;
        }
      }
      _dobControllers.clear();
      _dobControllers.addAll(newControllers);
    });
  }

  Future<void> _pickDate(
    BuildContext context,
    int index,
  ) async {
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

    if (date != null) {
      setState(() {
        final formattedDate = DateFormat('yyyy-MM-dd').format(date);
        _dobControllers[index]?.text = formattedDate;
        members[index]["date_of_birth"] = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.formData["family_members"] = members;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Family Members"),
        const SizedBox(height: 16),

        ...members.asMap().entries.map((entry) {
          final index = entry.key;
          final member = entry.value;

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Relation
                  DropdownButtonFormField<int>(
                    decoration:
                        const InputDecoration(labelText: "Relation *"),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Spouse")),
                      DropdownMenuItem(value: 2, child: Text("Father")),
                      DropdownMenuItem(value: 3, child: Text("Mother")),
                      DropdownMenuItem(value: 4, child: Text("Son")),
                      DropdownMenuItem(value: 5, child: Text("Daughter")),
                      DropdownMenuItem(value: 6, child: Text("Brother")),
                      DropdownMenuItem(value: 7, child: Text("Sister")),
                    ],
                    validator: (v) => v == null ? "Required" : null,
                    onChanged: (v) => member["relation_id"] = v,
                    onSaved: (v) => member["relation_id"] = v,
                  ),

                  const SizedBox(height: 16),

                  /// First Name
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "First Name *"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                    onSaved: (v) => member["first_name"] = v,
                  ),

                  const SizedBox(height: 16),

                  /// Last Name
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Last Name *"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                    onSaved: (v) => member["last_name"] = v,
                  ),

                  const SizedBox(height: 16),

                  /// Date of Birth
                  TextFormField(
                    controller: _dobControllers[index],
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Date of Birth *",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                    onTap: () => _pickDate(context, index),
                  ),

                  const SizedBox(height: 16),

                  /// Occupation
                  DropdownButtonFormField<int>(
                    decoration:
                        const InputDecoration(labelText: "Occupation *"),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Business")),
                      DropdownMenuItem(value: 2, child: Text("Service")),
                      DropdownMenuItem(value: 3, child: Text("Student")),
                      DropdownMenuItem(value: 4, child: Text("Homemaker")),
                      DropdownMenuItem(value: 5, child: Text("Retired")),
                    ],
                    validator: (v) => v == null ? "Required" : null,
                    onChanged: (v) => member["occupation_id"] = v,
                    onSaved: (v) => member["occupation_id"] = v,
                  ),

                  const SizedBox(height: 16),

                  /// Phone
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Phone Number"),
                    keyboardType: TextInputType.phone,
                    onSaved: (v) => member["phone"] = v ?? '',
                  ),

                  const SizedBox(height: 16),

                  /// Email
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "example@gmail.com",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (v) => member["email"] = v ?? '',
                  ),

                  const SizedBox(height: 16),

                  /// Present Address
                  TextFormField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: "Present Address *"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                    onSaved: (v) => member["present_address"] = v,
                  ),

                  const SizedBox(height: 16),

                  /// Permanent Address
                  TextFormField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: "Permanent Address *"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                    onSaved: (v) => member["permanent_address"] = v,
                  ),

                  const SizedBox(height: 16),

                  /// Bank Account
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Bank Account"),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => member["bank_account"] = v ?? '',
                  ),

                  const SizedBox(height: 16),

                  /// IFSC
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "IFSC Code"),
                    textCapitalization: TextCapitalization.characters,
                    onSaved: (v) => member["ifsc_code"] = v ?? '',
                  ),

                  const SizedBox(height: 16),

                  /// PAN
                  TextFormField(
                    decoration: const InputDecoration(labelText: "PAN"),
                    textCapitalization: TextCapitalization.characters,
                    onSaved: (v) => member["pan"] = v ?? '',
                  ),

                  const SizedBox(height: 16),

                  /// Aadhaar
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Aadhaar *",
                      hintText: "Enter 12-digit Aadhaar",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                    onSaved: (v) => member["aadhaar"] = v,
                  ),

                  const SizedBox(height: 20),

                  /// Remove
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () => _removeMember(index),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        "Remove Member",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        /// Add Member
        OutlinedButton.icon(
          onPressed: _addMember,
          icon: const Icon(Icons.add),
          label: const Text("Add Family Member"),
        ),
      ],
    );
  }
}