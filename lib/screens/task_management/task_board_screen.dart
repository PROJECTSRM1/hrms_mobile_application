import 'package:flutter/material.dart';

class TaskBoardScreen extends StatelessWidget {
  const TaskBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FB),
        appBar: AppBar(
          title: const Text('Task Board'),
          backgroundColor: const Color(0xFF0AA6B7),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'To Do'),
              Tab(text: 'In Progress'),
              Tab(text: 'Review'),
              Tab(text: 'Done'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList('To Do', Colors.orange),
            _buildTaskList('In Progress', Colors.blue),
            _buildTaskList('Review', Colors.purple),
            _buildTaskList('Done', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(String status, Color color) {
    final tasks = [
      {'title': 'Complete Project Documentation', 'assignee': 'John Doe', 'priority': 'High'},
      {'title': 'Review Code Changes', 'assignee': 'Jane Smith', 'priority': 'Medium'},
      {'title': 'Prepare Presentation', 'assignee': 'Bob Wilson', 'priority': 'Low'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: color, width: 4),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              task['title']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(task['assignee']!),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(task['priority']!).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task['priority']!,
                    style: TextStyle(
                      color: _getPriorityColor(task['priority']!),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}