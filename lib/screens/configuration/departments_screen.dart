import 'package:flutter/material.dart';
import '../../services/department_service.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isLoading = true;
  List<dynamic> active = [];
  List<dynamic> inactive = [];

  final TextEditingController departmentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() => isLoading = true);
    try {
      final data = await DepartmentService.fetchDepartments();
      active = data.where((e) => e['is_active'] == true).toList();
      inactive = data.where((e) => e['is_active'] == false).toList();
    } catch (_) {}
    setState(() => isLoading = false);
  }

  Future<void> _addDepartment() async {
    if (departmentCtrl.text.trim().isEmpty) return;

    await DepartmentService.createDepartment(
      name: departmentCtrl.text.trim(),
    );

    departmentCtrl.clear();
    _loadDepartments();
  }

  Future<void> _toggleStatus(int id, bool makeActive) async {
    await DepartmentService.updateDepartmentStatus(
      deptId: id,
      isActive: makeActive,
    );
    _loadDepartments();
  }

  void _editDepartment(dynamic dept) {
    final ctrl = TextEditingController(text: dept['department']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Department"),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            labelText: "Department Name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await DepartmentService.updateDepartment(
                deptId: dept['id'],
                name: ctrl.text.trim(),
              );
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              _loadDepartments();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Departments"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F4C5C),
                Color(0xFF0AA6B7),
              ],
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Active"),
            Tab(text: "Inactive"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _addDepartmentCard(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _list(active, true),
                        _list(inactive, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _addDepartmentCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: departmentCtrl,
                decoration: const InputDecoration(
                  hintText: "Add Department",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _addDepartment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0AA6B7),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(List data, bool isActive) {
    if (data.isEmpty) {
      return const Center(child: Text("No records found"));
    }

    return ListView.separated(
      itemCount: data.length,
      // ignore: unnecessary_underscores
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, i) {
        final d = data[i];
        return ListTile(
          title: Text(
            d['department'],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _editDepartment(d),
              ),
              IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: isActive ? Colors.red : Colors.green,
                ),
                onPressed: () =>
                    _toggleStatus(d['id'], !isActive),
              ),
            ],
          ),
        );
      },
    );
  }
}
