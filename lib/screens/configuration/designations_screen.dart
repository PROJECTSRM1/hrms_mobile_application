import 'package:flutter/material.dart';
import '../../services/designation_service.dart';

class DesignationsScreen extends StatefulWidget {
  const DesignationsScreen({super.key});

  @override
  State<DesignationsScreen> createState() => _DesignationsScreenState();
}

class _DesignationsScreenState extends State<DesignationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isLoading = true;
  List<dynamic> active = [];
  List<dynamic> inactive = [];

  int? selectedDeptId;
  final TextEditingController designationCtrl = TextEditingController();

  final Map<int, String> departments = {
    1: "Business & Operations",
    2: "Media & Communication",
    3: "People & Support",
    4: "Legal, Risk & Compliance",
    5: "Supply Chain & Procurement",
    6: "Management & Strategy",
    7: "Technology & Engineering",
    8: "Information Technology",
    9: "Software Development",
    10: "DevOps & Cloud",
    11: "Quality Assurance",
    12: "Cyber Security",
    13: "Data & Analytics",
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDesignations();
  }

  Future<void> _loadDesignations() async {
    setState(() => isLoading = true);
    try {
      final data = await DesignationService.fetchDesignations();
      active = data.where((e) => e['is_active'] == true).toList();
      inactive = data.where((e) => e['is_active'] == false).toList();
    } catch (_) {}
    setState(() => isLoading = false);
  }

  Future<void> _addDesignation() async {
    if (selectedDeptId == null || designationCtrl.text.trim().isEmpty) return;

    await DesignationService.createDesignation(
      deptId: selectedDeptId!,
      name: designationCtrl.text.trim(),
    );

    designationCtrl.clear();
    setState(() => selectedDeptId = null);
    _loadDesignations();
  }

  Future<void> _toggleStatus(int id, bool makeActive) async {
    await DesignationService.updateDesignationStatus(id, makeActive);
    _loadDesignations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Designations"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 1,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F4C5C),
                Color(0xFF0AA6B7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _addDesignationCard(),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
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

  // ================= ADD DESIGNATION =================
  Widget _addDesignationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Designation",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Department dropdown
            DropdownButtonFormField<int>(
              initialValue: selectedDeptId,
              isExpanded: true,
              menuMaxHeight: 300,
              decoration: const InputDecoration(
                labelText: "Department *",
                border: OutlineInputBorder(),
              ),
              items: departments.entries
                  .map(
                    (e) => DropdownMenuItem<int>(
                      value: e.key,
                      child: Text(
                        e.value,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedDeptId = v),
            ),

            const SizedBox(height: 16),

            // Designation input
            TextFormField(
              controller: designationCtrl,
              decoration: const InputDecoration(
                labelText: "Designation *",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _addDesignation,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LIST =================
  Widget _list(List data, bool isActiveTab) {
    if (data.isEmpty) {
      return const Center(child: Text("No records found"));
    }

    return ListView.separated(
      itemCount: data.length,
      // ignore: unnecessary_underscores
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final d = data[i];
        return ListTile(
          title: Text(
            d['designation_name'],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            departments[d['dept_id']] ?? "Department",
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: IconButton(
            icon: Icon(
              isActiveTab ? Icons.check_circle : Icons.cancel,
              color: isActiveTab ? Colors.green : Colors.red,
            ),
            onPressed: () => _toggleStatus(d['id'], !isActiveTab),
          ),
        );
      },
    );
  }
}
