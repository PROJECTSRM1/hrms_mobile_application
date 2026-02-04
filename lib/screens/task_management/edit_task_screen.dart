import 'package:flutter/material.dart';
import '../../services/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  final Map<String, dynamic> taskData;

  const EditTaskScreen({super.key, required this.taskData});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _effortsController;
  
  int? _selectedEmployeeId;
  int? _selectedProjectId;
  int? _selectedStatusId;
  DateTime? _dueDate;
  
  bool _isLoading = false;
  bool _isInitialLoading = true;
  
  List<Map<String, dynamic>> _employees = [];
  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _statuses = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing data
    _titleController = TextEditingController(text: widget.taskData['taskTitle'] ?? '');
    _descriptionController = TextEditingController(text: widget.taskData['taskDescription'] ?? '');
    _effortsController = TextEditingController(
      text: widget.taskData['effortsInDays']?.toString() ?? '0',
    );
    
    // Parse due date
    if (widget.taskData['dueDate'] != null) {
      try {
        _dueDate = DateTime.parse(widget.taskData['dueDate']);
      } catch (e) {
        _dueDate = null;
      }
    }
    
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isInitialLoading = true;
    });

    try {
      await Future.wait([
        _loadEmployees(),
        _loadProjects(),
        _loadStatuses(),
      ]);
      
      // Set initial selections after data is loaded
      _setInitialSelections();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  void _setInitialSelections() {
    // Find and set employee ID
    if (widget.taskData['employeeName'] != null) {
      final employee = _employees.firstWhere(
        (e) => e['name'] == widget.taskData['employeeName'],
        orElse: () => {},
      );
      if (employee.isNotEmpty) {
        _selectedEmployeeId = employee['id'];
      }
    }
    
    // Find and set project ID
    if (widget.taskData['projectName'] != null) {
      final project = _projects.firstWhere(
        (p) => p['name'] == widget.taskData['projectName'],
        orElse: () => {},
      );
      if (project.isNotEmpty) {
        _selectedProjectId = project['id'];
      }
    }
    
    // Find and set status ID
    if (widget.taskData['taskStatus'] != null) {
      final status = _statuses.firstWhere(
        (s) => s['name'] == widget.taskData['taskStatus'],
        orElse: () => {},
      );
      if (status.isNotEmpty) {
        _selectedStatusId = status['id'];
      }
    }
    
    setState(() {});
  }

  Future<void> _loadEmployees() async {
    try {
      final employees = await TaskService.getEmployees();
      setState(() {
        _employees = employees;
      });
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<void> _loadProjects() async {
    try {
      final projects = await TaskService.getProjects();
      setState(() {
        _projects = projects;
      });
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  Future<void> _loadStatuses() async {
    // Hardcoded statuses - replace with API call if available
    setState(() {
      _statuses = [
        {'id': 1, 'name': 'Pending'},
        {'id': 2, 'name': 'In Progress'},
        {'id': 3, 'name': 'Completed'},
        {'id': 4, 'name': 'Rejected'},
        {'id': 5, 'name': 'Active'},
        {'id': 6, 'name': 'QA'},
        {'id': 7, 'name': 'Review'},
        {'id': 13, 'name': 'Cancelled'},
      ];
    });
  }

  Future<void> _updateTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedEmployeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an employee')),
      );
      return;
    }

    if (_selectedProjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a project')),
      );
      return;
    }

    if (_selectedStatusId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a status')),
      );
      return;
    }

    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a due date')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final taskId = widget.taskData['taskId'];
      if (taskId == null) {
        throw Exception('Task ID is missing');
      }

      final updateData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'emp_id': _selectedEmployeeId,
        'project_id': _selectedProjectId,
        'status_id': _selectedStatusId,
        'due_date': _dueDate!.toIso8601String().split('T')[0],
        'efforts_in_days': int.tryParse(_effortsController.text) ?? 0,
      };

      await TaskService.updateTaskById(taskId, updateData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update task: $e'),
            backgroundColor: Colors.red,
          ),
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _effortsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: _isInitialLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0AA6B7)),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Employee
                    const Text(
                      '* Employee',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedEmployeeId,
                      decoration: InputDecoration(
                        hintText: 'Select employee',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      items: _employees
                          .map((employee) => DropdownMenuItem(
                                value: employee['id'] as int,
                                child: Text(employee['name'] as String),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEmployeeId = value;
                        });
                      },
                      isExpanded: true,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select employee';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Project Name
                    const Text(
                      '* Project Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedProjectId,
                      decoration: InputDecoration(
                        hintText: 'Select project',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      items: _projects
                          .map((project) => DropdownMenuItem(
                                value: project['id'] as int,
                                child: Text(project['name'] as String),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProjectId = value;
                        });
                      },
                      isExpanded: true,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select project';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Title
                    const Text(
                      '* Title',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter task title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Description
                    const Text(
                      '* Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter task description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Efforts (Days)
                    const Text(
                      '* Efforts (Days)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _effortsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter number of days',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter efforts';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Task Status
                    const Text(
                      '* Task Status',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedStatusId,
                      decoration: InputDecoration(
                        hintText: 'Select status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      items: _statuses
                          .map((status) => DropdownMenuItem(
                                value: status['id'] as int,
                                child: Text(status['name'] as String),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatusId = value;
                        });
                      },
                      isExpanded: true,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select status';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Due Date
                    const Text(
                      '* Due Date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _dueDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF0AA6B7),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _dueDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dueDate == null
                                  ? 'Select date'
                                  : '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: _dueDate == null
                                    ? Colors.grey[400]
                                    : Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading
                                ? null
                                : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _updateTask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007BFF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Update',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}