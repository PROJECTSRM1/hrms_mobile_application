import 'package:flutter/material.dart';
import '../../services/task_service.dart';

class AssignTaskScreen extends StatefulWidget {
  const AssignTaskScreen({super.key});

  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  bool _isLoading = true;
  // int? _updatingTaskId;
  bool _isUpdating = false;


  List<Map<String, dynamic>> _assignedTasks = [];
  List<Map<String, dynamic>> _employees = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ================= LOAD DATA =================
  Future<void> _loadData() async {
    try {
      final tasks = await TaskService.getAssignedTasks();
      final employees = await TaskService.getEmployees();

      setState(() {
        _assignedTasks = tasks;
        _employees = employees;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // ================= AUTO ASSIGN =================
Future<void> _assignEmployee(int taskId, int empId) async {
  try {
    setState(() {
      _isUpdating = true;
    });

    final tasks = await TaskService.getTasks();
    final task = tasks.firstWhere((t) => t.id == taskId);

    final updatedTask = task.copyWith(empId: empId);

    await TaskService.updateTask(taskId, updatedTask);
    await _loadData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Updated successfully"),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    if (!mounted) return; // ✅ IMPORTANT

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed: $e")),
    );
  } 
 finally {
  if (mounted) {
    setState(() {
      _isUpdating = false;
    });
  }
}


}




  // ================= UI =================
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Task"),
        backgroundColor: const Color(0xFF0AA6B7),
      ),

      body: Stack(
  children: [

    // 🔹 Normal screen
    _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: _buildTable(),
          ),

    // 🔥 FULL SCREEN UPDATING OVERLAY
    if (_isUpdating)
      Container(
        color: Colors.black.withValues(alpha: 0.45), // fade background
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 14),
              Text(
                "Updating...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
  ],
),

    );
  }

  // ================= TABLE =================
  Widget _buildTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            WidgetStateProperty.all(const Color(0xFFF6F8FB)),
        columns: const [
          DataColumn(label: Text('Employee')),
          DataColumn(label: Text('Project')),
          DataColumn(label: Text('Manager')),
          DataColumn(label: Text('Title')),
          DataColumn(label: Text('Description')),
          DataColumn(label: Text('Efforts')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Due Date')),
          DataColumn(label: Text('Actions')),
        ],
        rows: _assignedTasks.map((task) {
          return DataRow(
            cells: [
              // 🔥 Employee Dropdown (AUTO ASSIGN)
              DataCell(
                DropdownButton<int>(
                  value: task['empId'],
                  items: _employees.map((e) {
                    return DropdownMenuItem<int>(
                      value: e['id'],
                      child: Text(e['name']),
                    );
                  }).toList(),
                  onChanged: _isUpdating
                      ? null   // disable while updating
                      : (value) {
                          if (value != null) {
                            _assignEmployee(task['taskId'], value);
                          }
                        },
                ),
              ),



              DataCell(Text(task['projectName'] ?? '')),
              DataCell(Text(task['reportingManager'] ?? '')),
              DataCell(Text(task['taskTitle'] ?? '')),
              DataCell(Text(task['taskDescription'] ?? '')),
              DataCell(Text('${task['effortsInDays']}')),
              DataCell(Text(task['taskStatus'] ?? '')),
              DataCell(Text(task['dueDate'] ?? '')),

              // Edit only (Assign button removed)
              DataCell(
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // open edit screen here
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
