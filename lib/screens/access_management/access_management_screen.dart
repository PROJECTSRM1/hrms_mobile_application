import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AccessManagementScreen extends StatelessWidget {
  const AccessManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Access Management"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AccessRoleCard(role: "Admin"),
          AccessRoleCard(role: "System Administrator"),
          AccessRoleCard(role: "Payroll Officer"),
          AccessRoleCard(role: "Manager / Supervisor"),
          AccessRoleCard(role: "Employee"),
          AccessRoleCard(role: "HR Admin"),
          SizedBox(height: 16),
          UpdateAllButton(),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// ROLE CARD
////////////////////////////////////////////////////////////
class AccessRoleCard extends StatelessWidget {
  final String role;

  const AccessRoleCard({super.key, required this.role});

  static const List<String> moduleList = [
    "ALL",
    "Dashboard",
    "Employees",
    "Attendance Management",
    "Task Management",
    "Leave Management",
    "Payroll Management",
    "Salary",
    "Performance",
    "Recruitment",
  ];

  static const List<String> subModuleList = [
    "ALL",
    "Create",
    "View",
    "Update",
    "Delete",
    "Approve",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ROLE NAME
          Text(
            role,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          /// MODULES
          _label("Modules"),
          MultiSelectDropdown(
            items: moduleList,
            selectedItems: const ["ALL"],
          ),

          const SizedBox(height: 12),

          /// SUB MODULES
          _label("Sub Modules"),
          MultiSelectDropdown(
            items: subModuleList,
            selectedItems: const ["ALL"],
          ),

          const Divider(height: 28),

          /// PERMISSIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              PermissionIcon(label: "View", enabled: true),
              PermissionIcon(label: "Delete", enabled: false),
              PermissionIcon(label: "Update", enabled: true),
            ],
          ),

          const SizedBox(height: 16),

          /// UPDATE BUTTON
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Update"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// MULTI SELECT DROPDOWN (100% v5 SAFE)
////////////////////////////////////////////////////////////
class MultiSelectDropdown extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;

  const MultiSelectDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>.multiSelection(
      items: items,
      selectedItems: selectedItems,
      onChanged: (List<String> values) {},
    );
  }
}

////////////////////////////////////////////////////////////
/// PERMISSION ICON
////////////////////////////////////////////////////////////
class PermissionIcon extends StatelessWidget {
  final String label;
  final bool enabled;

  const PermissionIcon({
    super.key,
    required this.label,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        Icon(
          enabled ? Icons.check_box : Icons.check_box_outline_blank,
          color: enabled ? Colors.blue : Colors.grey,
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// UPDATE ALL BUTTON
////////////////////////////////////////////////////////////
class UpdateAllButton extends StatelessWidget {
  const UpdateAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: const Text("Update All"),
      ),
    );
  }
}
