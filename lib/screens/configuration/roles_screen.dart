import 'package:flutter/material.dart';
import '../../services/roles_service.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController roleCtrl = TextEditingController();

  bool isLoading = true;
  List<dynamic> active = [];
  List<dynamic> inactive = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    setState(() => isLoading = true);
    try {
      final data = await RolesService.fetchRoles();
      active = data.where((e) => e['is_active'] == true).toList();
      inactive = data.where((e) => e['is_active'] == false).toList();
    } catch (_) {}
    setState(() => isLoading = false);
  }

  Future<void> _addRole() async {
    if (roleCtrl.text.trim().isEmpty) return;

    await RolesService.createRole(roleCtrl.text.trim());
    roleCtrl.clear();
    _loadRoles();
  }

  Future<void> _toggleStatus(int id, bool makeActive) async {
    await RolesService.updateRoleStatus(id, makeActive);
    _loadRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: _gradientAppBar("Roles"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _addCard("Add Role", "Role *", roleCtrl, _addRole),
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

  PreferredSizeWidget _gradientAppBar(String title) {
    return AppBar(
      title: Text(title),
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F4C5C), Color(0xFF0AA6B7)],
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
    );
  }

  Widget _addCard(
    String title,
    String label,
    TextEditingController controller,
    VoidCallback onSave,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.add, color: Colors.white),
                label:
                    const Text("Save", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
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
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final r = data[i];
        return ListTile(
          title: Text(
            r['role_name'],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: IconButton(
            icon: Icon(
              isActive ? Icons.check_circle : Icons.cancel,
              color: isActive ? Colors.green : Colors.red,
            ),
            onPressed: () =>
                _toggleStatus(r['id'], !isActive),
          ),
        );
      },
    );
  }
}
