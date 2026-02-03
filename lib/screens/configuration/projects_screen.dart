import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../../services/project_service.dart';


class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController projectCtrl = TextEditingController();

  List<Project> active = [];
  List<Project> inactive = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final data = await ProjectService.getProjects();
    setState(() {
      active = data.where((e) => e.isActive).toList();
      inactive = data.where((e) => !e.isActive).toList();
      loading = false;
    });
  }

  Future<void> _add() async {
    if (projectCtrl.text.trim().isEmpty) return;
    await ProjectService.createProject(projectCtrl.text.trim());
    projectCtrl.clear();
    _load();
  }

  Future<void> _toggle(Project p) async {
    await ProjectService.updateStatus(p.id, !p.isActive);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Projects"),
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
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Active"),
            Tab(text: "Inactive"),
          ],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _addCard(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _list(active),
                        _list(inactive),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _addCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: projectCtrl,
                decoration: const InputDecoration(
                  hintText: "Add Project",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _add,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }

  Widget _list(List<Project> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, i) {
        return ListTile(
          title: Text(data[i].projectName,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: IconButton(
            icon: Icon(
              data[i].isActive ? Icons.check_circle : Icons.cancel,
              color: data[i].isActive ? Colors.green : Colors.red,
            ),
            onPressed: () => _toggle(data[i]),
          ),
        );
      },
    );
  }
}
