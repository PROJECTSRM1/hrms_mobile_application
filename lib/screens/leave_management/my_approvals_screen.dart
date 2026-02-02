import 'package:flutter/material.dart';
import '../../common/widgets/hrms_app_bar.dart';

class MyApprovalsScreen extends StatefulWidget {
  const MyApprovalsScreen({super.key});

  @override
  State<MyApprovalsScreen> createState() => _MyApprovalsScreenState();
}

class _MyApprovalsScreenState extends State<MyApprovalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// 🔹 Replace with backend response
  final List<Map<String, dynamic>> pendingApprovals = [];
  final List<Map<String, dynamic>> historyApprovals = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // TODO: fetch approvals from backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: const HrmsAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'My Approvals',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          /// ===== Tabs =====
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF0AA6B7),
            unselectedLabelColor: Colors.black54,
            indicatorColor: const Color(0xFF0AA6B7),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'History'),
            ],
          ),

          const SizedBox(height: 16),

          /// ===== Content =====
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _tableView(
                  isPending: true,
                  data: pendingApprovals,
                ),
                _tableView(
                  isPending: false,
                  data: historyApprovals,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= TABLE VIEW =================

  Widget _tableView({
    required bool isPending,
    required List<Map<String, dynamic>> data,
  }) {
    if (data.isEmpty) {
      return _emptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _tableHeader(isPending),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: data.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _tableRow(data[index], isPending);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(bool isPending) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _headerCell('Employee Name', 2),
          _headerCell('Leave Type', 2),
          _headerCell('From', 1),
          _headerCell('To', 1),
          _headerCell('Days', 1),
          _headerCell(isPending ? 'Reason' : 'Status', 2),
          if (isPending) _headerCell('Actions', 2),
        ],
      ),
    );
  }

  Widget _tableRow(Map<String, dynamic> row, bool isPending) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        children: [
          _cell(row['employee'] ?? '-', 2),
          _cell(row['leaveType'] ?? '-', 2),
          _cell(row['from'] ?? '-', 1),
          _cell(row['to'] ?? '-', 1),
          _cell('${row['days'] ?? '-'}', 1),
          _cell(
            isPending ? row['reason'] ?? '-' : row['status'] ?? '-',
            2,
          ),
          if (isPending)
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => _approveReject(row, false),
                    child: const Text(
                      'Reject',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _approveReject(row, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Approve'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// ================= HELPERS =================

  Widget _headerCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _cell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.folder_open, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No data',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// ================= API ACTION =================

  Future<void> _approveReject(
    Map<String, dynamic> row,
    bool approve,
  ) async {
    // TODO:
    // POST /leave/approve-reject
    // body:
    // {
    //   "leave_id": row["id"],
    //   "action": approve ? "approve" : "reject",
    //   "approver_id": loggedInUserId,
    //   "remarks": ""
    // }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          approve ? 'Leave Approved' : 'Leave Rejected',
        ),
      ),
    );
  }
}
