import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProjectModulesScreen extends StatefulWidget {
  const ProjectModulesScreen({super.key});

  @override
  State<ProjectModulesScreen> createState() => _ProjectModulesScreenState();
}

class _ProjectModulesScreenState extends State<ProjectModulesScreen>
    with SingleTickerProviderStateMixin {
  static const String baseUrl = 'https://hrms-be-ppze.onrender.com';

  late TabController _tabController;

  bool loading = true;
  bool saving = false;

  List<Map<String, dynamic>> allModules = [];
  List<Map<String, dynamic>> projects = [];

  int? selectedProjectId;
  final TextEditingController moduleCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _init();
  }

  Future<void> _init() async {
    await Future.wait([
      _fetchProjects(),
      _fetchModules(),
    ]);
  }

  /// ---------------- PROJECTS ----------------
  Future<void> _fetchProjects() async {
    // ⚠️ Replace with your real projects API if different
    final res = await http.get(
      Uri.parse('$baseUrl/projects'),
      headers: {'accept': 'application/json'},
    );

    if (res.statusCode == 200) {
      projects = List<Map<String, dynamic>>.from(jsonDecode(res.body));
    }
    setState(() {});
  }

  /// ---------------- MODULES ----------------
  Future<void> _fetchModules() async {
    setState(() => loading = true);

    final res = await http.get(
      Uri.parse('$baseUrl/master-project-module/'),
      headers: {'accept': 'application/json'},
    );

    if (res.statusCode == 200) {
      allModules = List<Map<String, dynamic>>.from(jsonDecode(res.body));
    }

    setState(() => loading = false);
  }

  /// ---------------- CREATE MODULE ----------------
  Future<void> _createModule() async {
    if (selectedProjectId == null || moduleCtrl.text.trim().isEmpty) return;

    setState(() => saving = true);

    final res = await http.post(
      Uri.parse('$baseUrl/master-project-module/'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'project_module': moduleCtrl.text.trim(),
        'project_id': selectedProjectId,
      }),
    );

    setState(() => saving = false);

    if (res.statusCode == 200 || res.statusCode == 201) {
      moduleCtrl.clear();
      await _fetchModules();
    }
  }

  /// ---------------- UPDATE STATUS (OPTIMISTIC) ----------------
  Future<void> _toggleStatus(Map<String, dynamic> module, bool activate) async {
    final int id = module['id'];

    // optimistic update
    final old = module['is_active'];
    setState(() => module['is_active'] = activate);

    final res = await http.put(
      Uri.parse(
        '$baseUrl/master-project-module/$id/status?is_active=$activate',
      ),
      headers: {'accept': 'application/json'},
    );

    if (res.statusCode != 200) {
      // rollback
      setState(() => module['is_active'] = old);
    }
  }

  /// ---------------- CONFIRM DEACTIVATE ----------------
  Future<void> _confirmDeactivate(Map<String, dynamic> module) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deactivate Module'),
        content: const Text('Are you sure you want to deactivate this module?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deactivate', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (ok == true) {
      _toggleStatus(module, false);
    }
  }

  /// ---------------- FILTERED LIST ----------------
  List<Map<String, dynamic>> _filtered(bool active) {
    return allModules.where((m) {
      if (m['is_active'] != active) return false;
      if (selectedProjectId != null && m['project_id'] != selectedProjectId) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    moduleCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Project Modules"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 1,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F4C5C), Color(0xFF0AA6B7)],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          /// -------- ADD MODULE CARD --------
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: selectedProjectId,
                        hint: const Text("Select Project"),
                        items: projects.map((p) {
                          return DropdownMenuItem<int>(
                            value: p['id'],
                            child: Text(p['project_name']),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => selectedProjectId = v),
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: moduleCtrl,
                        decoration: const InputDecoration(
                          hintText: "Add Module",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: saving ? null : _createModule,
                    child: saving ? const CircularProgressIndicator() : const Text("Save"),
                  ),
                ),
              ],
            ),
          ),

          /// -------- TABS --------
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF0AA6B7),
            indicatorColor: const Color(0xFF0AA6B7),
            tabs: const [
              Tab(text: "Active"),
              Tab(text: "Inactive"),
            ],
          ),

          /// -------- LIST --------
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(_filtered(true), active: true),
                      _buildList(_filtered(false), active: false),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> list, {required bool active}) {
    if (list.isEmpty) {
      return const Center(child: Text("No modules found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final m = list[i];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m['project_module'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text("HRMS", style: TextStyle(color: Colors.grey)),
                ],
              ),
              IconButton(
                icon: Icon(
                  active ? Icons.cancel : Icons.check_circle,
                  color: active ? Colors.red : Colors.green,
                ),
                onPressed: () {
                  if (active) {
                    _confirmDeactivate(m);
                  } else {
                    _toggleStatus(m, true);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
