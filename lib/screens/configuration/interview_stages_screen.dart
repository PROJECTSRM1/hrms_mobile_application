import 'package:flutter/material.dart';
import '../../services/interview_stage_service.dart';

class InterviewStagesScreen extends StatefulWidget {
  const InterviewStagesScreen({super.key});

  @override
  State<InterviewStagesScreen> createState() =>
      _InterviewStagesScreenState();
}

class _InterviewStagesScreenState extends State<InterviewStagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController stageCtrl = TextEditingController();

  bool isLoading = true;
  List<dynamic> active = [];
  List<dynamic> inactive = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadStages();
  }

  Future<void> _loadStages() async {
    setState(() => isLoading = true);
    try {
      final data = await InterviewStageService.fetchStages();
      active = data.where((e) => e['is_active'] == true).toList();
      inactive = data.where((e) => e['is_active'] == false).toList();
    } catch (_) {}
    setState(() => isLoading = false);
  }

  Future<void> _addStage() async {
    if (stageCtrl.text.trim().isEmpty) return;

    await InterviewStageService.createStage(stageCtrl.text.trim());
    stageCtrl.clear();
    _loadStages();
  }

  Future<void> _toggleStatus(int id, bool makeActive) async {
    await InterviewStageService.updateStageStatus(id, makeActive);
    _loadStages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: _gradientAppBar("Interview Stages"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _addStageCard(),
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
      elevation: 1,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F4C5C), Color(0xFF0AA6B7)],
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
    );
  }

  // ================= ADD STAGE =================
  Widget _addStageCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Stage",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: stageCtrl,
              decoration: const InputDecoration(
                labelText: "Stage *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _addStage,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
            d['stage_name'],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: IconButton(
            icon: Icon(
              isActiveTab ? Icons.check_circle : Icons.cancel,
              color: isActiveTab ? Colors.green : Colors.red,
            ),
            onPressed: () =>
                _toggleStatus(d['id'], !isActiveTab),
          ),
        );
      },
    );
  }
}
