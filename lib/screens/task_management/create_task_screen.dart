import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../models/task_type.dart';
import '../../services/task_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _effortsController = TextEditingController();
  final _taskManagerController = TextEditingController(text: 'Mahesh Kesani');
  
  int? _selectedTaskTypeId;
  int? _selectedStatusId;
  int? _selectedProjectId;
  DateTime? _dueDate;
  
  bool _isLoading = false;
  List<TaskType> _taskTypes = [];

  // Mock data for dropdowns
  final List<Map<String, dynamic>> _statuses = [
    {'id': 1, 'name': 'Pending'},
    {'id': 2, 'name': 'In Progress'},
    {'id': 3, 'name': 'Review'},
    {'id': 4, 'name': 'Completed'},
  ];

  final List<Map<String, dynamic>> _projects = [
    {'id': 1, 'name': 'HRMS'},
    {'id': 2, 'name': 'Swachify'},
    {'id': 3, 'name': 'RJB'},
    {'id': 4, 'name': 'INRFS'},
    {'id': 5, 'name': 'Hrms mobile'},
  ];

  @override
  void initState() {
    super.initState();
    _loadTaskTypes();
  }

  Future<void> _loadTaskTypes() async {
    try {
      final taskTypes = await TaskService.getTaskTypes();
      setState(() {
        _taskTypes = taskTypes;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load task types: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    _effortsController.dispose();
    _taskManagerController.dispose();
    super.dispose();
  }

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTaskTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a task type')),
      );
      return;
    }

    if (_selectedStatusId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a status')),
      );
      return;
    }

    if (_selectedProjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a project')),
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
      final task = Task(
        title: _taskNameController.text,
        description: _descriptionController.text,
        taskTypeId: _selectedTaskTypeId,
        projectId: _selectedProjectId,
        statusId: _selectedStatusId,
        dueDate: _dueDate!.toIso8601String().split('T')[0],
        effortsInDays: int.tryParse(_effortsController.text) ?? 0,
        isActive: true,
      );

      await TaskService.createTask(task);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create task: $e'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Task'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                color: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Task Name - Left Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '* ',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Task Name',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _taskNameController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter task name',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(color: Color(0xFF0AA6B7)),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter task name';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Task Type - Right Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '* ',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Task Type',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<int>(
                                  initialValue: _selectedTaskTypeId,
                                  decoration: InputDecoration(
                                    hintText: 'Select task type',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(color: Color(0xFF0AA6B7)),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  items: _taskTypes
                                      .map((type) => DropdownMenuItem(
                                            value: type.id,
                                            child: Text(type.name),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTaskTypeId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select task type';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          // Status - Left Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '* ',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Status',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<int>(
                                  initialValue: _selectedStatusId,
                                  decoration: InputDecoration(
                                    hintText: 'Select status',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(color: Color(0xFF0AA6B7)),
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
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select status';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Due Date - Right Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '* ',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Due Date',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _dueDate ?? DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2030),
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
                                      color: Colors.white,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Description - Full Width
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '* ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Description',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Task description',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(color: Color(0xFF0AA6B7)),
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
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          // Efforts (Days) - Left Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '* ',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Efforts (Days)',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _effortsController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Enter number of days',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(color: Color(0xFF0AA6B7)),
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
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Task Manager - Right Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Task Manager',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _taskManagerController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          // Project - Half Width
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '* ',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Project',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<int>(
                                  initialValue: _selectedProjectId,
                                  decoration: InputDecoration(
                                    hintText: 'Select project',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(color: Color(0xFF0AA6B7)),
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
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select project';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Submit Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _createTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
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
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}











// import 'package:flutter/material.dart';
// import '../../models/task.dart';
// import '../../models/task_type.dart';
// import '../../services/task_service.dart';

// class CreateTaskScreen extends StatefulWidget {
//   const CreateTaskScreen({super.key});

//   @override
//   State<CreateTaskScreen> createState() => _CreateTaskScreenState();
// }

// class _CreateTaskScreenState extends State<CreateTaskScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _taskTitleController = TextEditingController();
//   final _taskDescriptionController = TextEditingController();
//   final _effortsController = TextEditingController();
  
//   String? _selectedPriority;
//   int? _selectedTaskTypeId;
//   int? _selectedProjectId;
//   int? _selectedStatusId = 1; // Default status
//   DateTime _dueDate = DateTime.now();
  
//   bool _isLoading = false;
//   List<TaskType> _taskTypes = [];

//   final List<String> _priorities = ['Low', 'Medium', 'High', 'Critical'];
//   final List<Map<String, dynamic>> _projects = [
//     {'id': 1, 'name': 'HRMS'},
//     {'id': 2, 'name': 'Swachify'},
//     {'id': 3, 'name': 'RJB'},
//     {'id': 4, 'name': 'INRFS'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadTaskTypes();
//   }

//   Future<void> _loadTaskTypes() async {
//     try {
//       final taskTypes = await TaskService.getTaskTypes();
//       setState(() {
//         _taskTypes = taskTypes;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load task types: $e')),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _taskTitleController.dispose();
//     _taskDescriptionController.dispose();
//     _effortsController.dispose();
//     super.dispose();
//   }

//   Future<void> _createTask() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     if (_selectedTaskTypeId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a task type')),
//       );
//       return;
//     }

//     if (_selectedProjectId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a project')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final task = Task(
//         title: _taskTitleController.text,
//         description: _taskDescriptionController.text,
//         taskTypeId: _selectedTaskTypeId,
//         projectId: _selectedProjectId,
//         statusId: _selectedStatusId,
//         dueDate: _dueDate.toIso8601String().split('T')[0],
//         effortsInDays: int.tryParse(_effortsController.text) ?? 0,
//         isActive: true,
//       );

//       await TaskService.createTask(task);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Task created successfully!')),
//         );
//         Navigator.pop(context, true);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create task: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F8FB),
//       appBar: AppBar(
//         title: const Text('Create Task'),
//         backgroundColor: const Color(0xFF0AA6B7),
//         foregroundColor: Colors.white,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildCard(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Task Details',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           TextFormField(
//                             controller: _taskTitleController,
//                             decoration: const InputDecoration(
//                               labelText: 'Task Title',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.title),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter task title';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           TextFormField(
//                             controller: _taskDescriptionController,
//                             decoration: const InputDecoration(
//                               labelText: 'Task Description',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.description),
//                             ),
//                             maxLines: 4,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter task description';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           DropdownButtonFormField<int>(
//                             value: _selectedTaskTypeId,
//                             decoration: const InputDecoration(
//                               labelText: 'Task Type',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.category),
//                             ),
//                             items: _taskTypes
//                                 .map((type) => DropdownMenuItem(
//                                       value: type.id,
//                                       child: Text(type.name),
//                                     ))
//                                 .toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedTaskTypeId = value;
//                               });
//                             },
//                             validator: (value) {
//                               if (value == null) {
//                                 return 'Please select a task type';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           DropdownButtonFormField<int>(
//                             value: _selectedProjectId,
//                             decoration: const InputDecoration(
//                               labelText: 'Project',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.folder),
//                             ),
//                             items: _projects
//                                 .map((project) => DropdownMenuItem(
//                                       value: project['id'] as int,
//                                       child: Text(project['name'] as String),
//                                     ))
//                                 .toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedProjectId = value;
//                               });
//                             },
//                             validator: (value) {
//                               if (value == null) {
//                                 return 'Please select a project';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           DropdownButtonFormField<String>(
//                             value: _selectedPriority,
//                             decoration: const InputDecoration(
//                               labelText: 'Priority',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.priority_high),
//                             ),
//                             items: _priorities
//                                 .map((priority) => DropdownMenuItem(
//                                       value: priority,
//                                       child: Text(priority),
//                                     ))
//                                 .toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedPriority = value;
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           TextFormField(
//                             controller: _effortsController,
//                             decoration: const InputDecoration(
//                               labelText: 'Efforts (Days)',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.timer),
//                             ),
//                             keyboardType: TextInputType.number,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter efforts in days';
//                               }
//                               if (int.tryParse(value) == null) {
//                                 return 'Please enter a valid number';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           ListTile(
//                             contentPadding: EdgeInsets.zero,
//                             leading: const Icon(Icons.calendar_today,
//                                 color: Color(0xFF0AA6B7)),
//                             title: const Text('Due Date'),
//                             subtitle: Text(
//                               '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
//                             ),
//                             trailing:
//                                 const Icon(Icons.arrow_forward_ios, size: 16),
//                             onTap: () async {
//                               final picked = await showDatePicker(
//                                 context: context,
//                                 initialDate: _dueDate,
//                                 firstDate: DateTime.now(),
//                                 lastDate: DateTime(2030),
//                               );
//                               if (picked != null) {
//                                 setState(() {
//                                   _dueDate = picked;
//                                 });
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _createTask,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF0AA6B7),
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: _isLoading
//                             ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                             : const Text(
//                                 'Create Task',
//                                 style:
//                                     TextStyle(fontSize: 16, color: Colors.white),
//                               ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildCard({required Widget child}) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }