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

  String? selectedDepartment;
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
    try {
      final data = await DesignationService.fetchDesignations();
      active = data.where((d) => d['is_active'] == true).toList();
      inactive = data.where((d) => d['is_active'] == false).toList();
    } catch (_) {}
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Designations"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: "Active"),
            Tab(text: "Inactive"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
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
    );
  }

  // ================= ADD DESIGNATION =================
  Widget _addDesignationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Designation",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: "Department *"),
                    items: departments.entries
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.key.toString(),
                            child: Text(e.value),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => selectedDepartment = v,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: designationCtrl,
                    decoration: const InputDecoration(
                      labelText: "Designation *",
                      hintText: "Add Designation",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // POST API here
              },
              icon: const Icon(Icons.add),
              label: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LIST =================
  Widget _list(List data, bool activeTab) {
    if (data.isEmpty) {
      return const Center(child: Text("No records found"));
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, i) {
        final d = data[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          title: Text(
            d['designation_name'],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            departments[d['dept_id']] ?? "Department",
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Icon(
            activeTab ? Icons.check_circle : Icons.cancel,
            color: activeTab ? Colors.green : Colors.red,
          ),
        );
      },
    );
  }
}
