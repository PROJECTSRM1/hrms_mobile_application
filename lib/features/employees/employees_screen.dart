import 'package:flutter/material.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String selectedFilter = "All";
  bool isGridView = false; // toggle

  /// ================= STATIC DATA =================
  final List<Employee> employees = [
    Employee("Ramudu P", "EMP001", "Non-IT", "Other", "8765432123", true),
    Employee("Burra Pavan", "EMP111", "Non-IT", "Employee", "1234567890", true),
    Employee("Mahesh Kesani", "EMP105", "IT", "Employee", "9870543210", true),
    Employee("Radha Sharma", "EMP041", "IT", "Employee", "9988776655", false),
    Employee("Ramesh", "EMP003", "IT", "Other", "8765430123", true),
    Employee("Virat Kohli", "EMP101", "IT", "Employee", "1234537890", false),
    Employee("Hardik Pandya", "EMP135", "IT", "Employee", "9870513210", true),
    Employee("Abhishek Sharma", "EMP024", "IT", "Employee", "998872355", false),
  ];

  /// ================= FILTER =================
  List<Employee> get filteredEmployees {
    return employees.where((emp) {
      final matchesSearch = emp.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      final matchesFilter = selectedFilter == "All"
          ? true
          : selectedFilter == "Active"
              ? emp.isActive
              : !emp.isActive;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Employee Directory",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [
          _buildSearchBar(),
          _buildControlsRow(),

          Expanded(
            child: isGridView ? _buildTableView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  /// ================= SEARCH BAR =================
  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: "Search employee",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFFF1F3F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// ================= CONTROLS =================
  Widget _buildControlsRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          DropdownButton<String>(
            value: selectedFilter,
            items: const [
              DropdownMenuItem(value: "All", child: Text("All")),
              DropdownMenuItem(value: "Active", child: Text("Active")),
              DropdownMenuItem(value: "Inactive", child: Text("Inactive")),
            ],
            onChanged: (v) => setState(() => selectedFilter = v!),
          ),

          const Spacer(),

          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Add Employee"),
          ),

          const SizedBox(width: 10),

          OutlinedButton(
            onPressed: () => setState(() => isGridView = !isGridView),
            child: Text(isGridView ? "Card View" : "Grid View"),
          ),
        ],
      ),
    );
  }

  /// ================= LIST VIEW (CARDS) =================
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredEmployees.length,
      itemBuilder: (_, index) {
        return EmployeeCard(employee: filteredEmployees[index]);
      },
    );
  }

  /// ================= GRID VIEW (TABLE LIKE WEB) =================
  Widget _buildTableView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 30,
        headingRowColor:
            MaterialStateProperty.all(const Color(0xFFF3F4F6)),
        columns: const [
          DataColumn(label: Text("EMP ID")),
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Department")),
          DataColumn(label: Text("Role")),
          DataColumn(label: Text("Phone")),
          DataColumn(label: Text("Status")),
        ],
        rows: filteredEmployees
            .map(
              (e) => DataRow(cells: [
                DataCell(Text(e.empId)),
                DataCell(Text(e.name)),
                DataCell(Text(e.department)),
                DataCell(Text(e.role)),
                DataCell(Text(e.phone)),
                DataCell(
                  Text(
                    e.isActive ? "Active" : "Inactive",
                    style: TextStyle(
                      color: e.isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
            )
            .toList(),
      ),
    );
  }
}

/// ================= MODEL =================
class Employee {
  final String name;
  final String empId;
  final String department;
  final String role;
  final String phone;
  final bool isActive;

  Employee(this.name, this.empId, this.department, this.role, this.phone,
      this.isActive);
}

/// ================= CARD =================
class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(employee.name),
        subtitle: Text("EMP ID: ${employee.empId}"),
        trailing: Text(
          employee.isActive ? "Active" : "Inactive",
          style: TextStyle(
              color: employee.isActive ? Colors.green : Colors.red),
        ),
      ),
    );
  }
}
