
import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  List<Task> _allTasks = [];
  bool _isLoading = false;

  // Status mapping (adjust these IDs based on your actual status IDs)
  final Map<String, int> _statusIds = {
    'To Do': 1,
    'In Progress': 2,
    'Review': 3,
    'Done': 4,
  };

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = await TaskService.getTasks();
      setState(() {
        _allTasks = tasks;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load tasks: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Task> _getTasksByStatus(String status) {
    final statusId = _statusIds[status];
    return _allTasks.where((task) => task.statusId == statusId).toList();
  }

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
            isScrollable: false,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'TO-DO'),
              Tab(text: 'In Progress'),
              Tab(text: 'Review'),
              Tab(text: 'Done'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadTasks,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildStatusColumn('To Do', Colors.blue),
                  _buildStatusColumn('In Progress', Colors.green),
                  _buildStatusColumn('Review', Colors.orange),
                  _buildStatusColumn('Done', Colors.purple),
                ],
              ),
      ),
    );
  }

  Widget _buildStatusColumn(String status, Color color) {
    final tasks = _getTasksByStatus(status);
    final count = tasks.length;

    return Container(
      color: const Color(0xFFF6F8FB),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(color: color, width: 4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      count.toString(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // View tasks functionality
                  },
                  child: Text(
                    'View Tasks',
                    style: TextStyle(color: color),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks in $status',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskCard(tasks[index], color);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: accentColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          task.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            if (task.dueDate != null)
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    task.dueDate!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            if (task.effortsInDays != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.timer, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${task.effortsInDays} days',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'move') {
              _showMoveTaskDialog(task);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'move',
              child: Row(
                children: [
                  Icon(Icons.move_up, size: 18),
                  SizedBox(width: 8),
                  Text('Move to...'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoveTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Move Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _statusIds.keys.map((status) {
              return ListTile(
                title: Text(status),
                onTap: () async {
                  Navigator.pop(context);
                  await _moveTask(task, status);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _moveTask(Task task, String newStatus) async {
  final statusId = _statusIds[newStatus];
  if (statusId == null || task.id == null) return;

  try {
    final updatedTask = task.copyWith(statusId: statusId);

    await TaskService.updateTask(task.id!, updatedTask);

    if (!mounted) return; 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task moved to $newStatus')),
    );

    await _loadTasks();
  } catch (e) {
    if (!mounted) return; 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to move task: $e')),
    );
  }
}


}