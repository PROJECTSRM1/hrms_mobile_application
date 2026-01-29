import 'package:flutter/material.dart';
import '../../common/widgets/hrms_app_bar.dart';
import '../../models/employee_model.dart';
import '../../services/employee_service.dart';
import 'add_employee_screen.dart';
import 'employee_details_screen.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String selectedFilter = "All";
  bool isGridView = false;
  bool isLoading = true;

  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      final data = await EmployeeService.fetchEmployees();
      setState(() {
        employees = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Employee Load Error: $e");
      setState(() => isLoading = false);
    }
  }

  /// ================= FILTER =================
  List<Employee> get filteredEmployees {
    return employees.where((emp) {
      final matchesSearch =
          emp.name.toLowerCase().contains(_searchController.text.toLowerCase());

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
      appBar: const HrmsAppBar(),
      body: Column(
        children: [
          _buildControlsRow(),
          _buildSearchBar(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : isGridView
                    ? _buildTableView()
                    : _buildListView(),
          ),
        ],
      ),
    );
  }

  /// ================= CONTROLS ROW =================
  Widget _buildControlsRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: DropdownButtonFormField<String>(
              initialValue: selectedFilter,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: const Color(0xFFF1F3F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: "All", child: Text("All")),
                DropdownMenuItem(value: "Active", child: Text("Active")),
                DropdownMenuItem(value: "Inactive", child: Text("Inactive")),
              ],
              onChanged: (v) => setState(() => selectedFilter = v!),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEmployeeScreen(),
                ),
              );

              if (result == true) {
                setState(() => isLoading = true);
                loadEmployees();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Employee"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEDE7F6),
              foregroundColor: Colors.deepPurple,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () => setState(() => isGridView = !isGridView),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(isGridView ? "Card View" : "Grid View"),
          ),
        ],
      ),
    );
  }

  /// ================= SEARCH BAR =================
  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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

  /// ================= LIST VIEW =================
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredEmployees.length,
      itemBuilder: (_, index) {
        final emp = filteredEmployees[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    EmployeeDetailsScreen(employeeId: emp.id)
              ),
            );
          },
          child: EmployeeCard(employee: emp),
        );
      },
    );
  }

  /// ================= GRID (TABLE) VIEW =================
  Widget _buildTableView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 28,
        headingRowColor:
            WidgetStateProperty.all(const Color(0xFFF3F4F6)),
        columns: const [
          DataColumn(label: Text("EMP ID")),
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Department")),
          DataColumn(label: Text("Role")),
          DataColumn(label: Text("Phone")),
          DataColumn(label: Text("Status")),
        ],
        rows: filteredEmployees.map((e) {
          return DataRow(
            onSelectChanged: (_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EmployeeDetailsScreen(employeeId: e.empId),
                ),
              );
            },
            cells: [
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
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// ================= CARD =================
class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE7E3FF),
          child: Icon(Icons.person, color: Colors.deepPurple),
        ),
        title: Text(employee.name),
        subtitle: Text("EMP ID: ${employee.empId}"),
        trailing: Text(
          employee.isActive ? "Active" : "Inactive",
          style: TextStyle(
            color: employee.isActive ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
