// lib/screens/recruiting/job_listings_screen.dart

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/job_opening_model.dart';
import '../../models/department_model.dart';
import '../../models/designation_model.dart';

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({super.key});

  @override
  State<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
  final ApiService _apiService = ApiService();
  List<JobOpening> _jobOpenings = [];
  List<Department> _departments = [];
  List<Designation> _designations = [];
  bool _isLoading = true;
  String _filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final jobOpenings = await _apiService.getJobOpenings();
      final departments = await _apiService.getDepartments();
      final designations = await _apiService.getDesignations();

      setState(() {
        _jobOpenings = jobOpenings;
        _departments = departments;
        _designations = designations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  String _getDepartmentName(int deptId) {
    try {
      return _departments.firstWhere((d) => d.id == deptId).department;
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getDesignationName(int desigId) {
    try {
      return _designations.firstWhere((d) => d.id == desigId).designationName;
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getStatusText(int statusId) {
    switch (statusId) {
      case 1:
        return 'Open';
      case 2:
        return 'In Progress';
      case 3:
        return 'Closed';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int statusId) {
    switch (statusId) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<JobOpening> _getFilteredJobs() {
    if (_filterStatus == 'All') {
      return _jobOpenings;
    }
    int statusId;
    switch (_filterStatus) {
      case 'Open':
        statusId = 1;
        break;
      case 'In Progress':
        statusId = 2;
        break;
      case 'Closed':
        statusId = 3;
        break;
      default:
        return _jobOpenings;
    }
    return _jobOpenings.where((job) => job.statusId == statusId).toList();
  }

  void _showAddJobDialog() {
    int? selectedDeptId;
    int? selectedDesigId;
    int selectedStatusId = 1; // Default to Open
    List<Designation> filteredDesignations = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Job Opening'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '* Department',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      hintText: 'Select Department',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    initialValue: selectedDeptId,
                    items: _departments.map((dept) {
                      return DropdownMenuItem(
                        value: dept.id,
                        child: Text(dept.department),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedDeptId = value;
                        selectedDesigId = null;
                        filteredDesignations = _designations
                            .where((d) => d.deptId == value)
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '* Designation',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      hintText: 'Select Designation',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    initialValue: selectedDesigId,
                    items: filteredDesignations.map((desig) {
                      return DropdownMenuItem(
                        value: desig.id,
                        child: Text(desig.designationName),
                      );
                    }).toList(),
                    onChanged: selectedDeptId == null
                        ? null
                        : (value) {
                            setDialogState(() {
                              selectedDesigId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    initialValue: selectedStatusId,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Open')),
                      DropdownMenuItem(value: 2, child: Text('In Progress')),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedStatusId = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0AA6B7),
                  foregroundColor: Colors.white,
                ),
                onPressed: selectedDeptId == null || selectedDesigId == null
                    ? null
                    : () async {
                        try {
                          await _apiService.createJobOpening(
                            CreateJobOpeningRequest(
                              designationId: selectedDesigId!,
                              departmentId: selectedDeptId!,
                              statusId: selectedStatusId,
                            ),
                          );
                          if (mounted) {
                            Navigator.pop(this.context);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                  content: Text('Job added successfully')),
                            );
                            _loadData();
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                child: const Text('OK'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditJobDialog(JobOpening job) {
    int selectedDeptId = job.departmentId;
    int selectedDesigId = job.designationId;
    int selectedStatusId = job.statusId;
    List<Designation> filteredDesignations =
        _designations.where((d) => d.deptId == selectedDeptId).toList();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Job Opening'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '* Department',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    initialValue: selectedDeptId,
                    items: _departments.map((dept) {
                      return DropdownMenuItem(
                        value: dept.id,
                        child: Text(dept.department),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedDeptId = value!;
                        filteredDesignations = _designations
                            .where((d) => d.deptId == value)
                            .toList();
                        if (!filteredDesignations
                            .any((d) => d.id == selectedDesigId)) {
                          selectedDesigId = filteredDesignations.first.id;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '* Designation',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    initialValue: selectedDesigId,
                    items: filteredDesignations.map((desig) {
                      return DropdownMenuItem(
                        value: desig.id,
                        child: Text(desig.designationName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedDesigId = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    initialValue: selectedStatusId,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Open')),
                      DropdownMenuItem(value: 2, child: Text('In Progress')),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedStatusId = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0AA6B7),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  try {
                    await _apiService.updateJobOpening(
                      job.id,
                      UpdateJobOpeningRequest(
                        designationId: selectedDesigId,
                        departmentId: selectedDeptId,
                        statusId: selectedStatusId,
                        isActive: job.isActive,
                      ),
                    );
                    if (mounted) {
                      Navigator.pop(this.context);
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                            content: Text('Job updated successfully')),
                      );
                      _loadData();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredJobs = _getFilteredJobs();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Recruitment Center'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Job Listings Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Job Listings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: _filterStatus,
                                underline: Container(),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'All', child: Text('Filter Jobs')),
                                  DropdownMenuItem(
                                      value: 'Open', child: Text('Open')),
                                  DropdownMenuItem(
                                      value: 'In Progress',
                                      child: Text('In Progress')),
                                  DropdownMenuItem(
                                      value: 'Closed', child: Text('Closed')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _filterStatus = value!;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: _showAddJobDialog,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add Job'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0AA6B7),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Table Header


                    ],
                  ),
                ),
                // Job Listings Table
                
// ================= JOB LIST TABLE =================
                Expanded
                (
                  child: filteredJobs.isEmpty
                      ? const Center(child: Text('No job listings found'))
                      : Column(
                          children: [

                            /// ===== STATIC HEADER (NOT SCROLLING) =====
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: Text('Department',
                                              style: TextStyle(fontWeight: FontWeight.bold)))),
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: Text('Designation',
                                              style: TextStyle(fontWeight: FontWeight.bold)))),
                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                          child: Text('Status',
                                              style: TextStyle(fontWeight: FontWeight.bold)))),
                                  SizedBox(
                                      width: 60,
                                      child: Center(
                                          child: Text('Actions',
                                              style: TextStyle(fontWeight: FontWeight.bold)))),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            /// ===== SCROLLABLE LIST =====
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 12),
                                itemCount: filteredJobs.length,
                                itemBuilder: (context, index) {
                                  final job = filteredJobs[index];

                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Row(
                                      children: [

                                        /// Department
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: Text(
                                                _getDepartmentName(job.departmentId)),
                                          ),
                                        ),

                                        /// Designation
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: Text(
                                                _getDesignationName(job.designationId)),
                                          ),
                                        ),

                                        /// Status
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(job.statusId)
                                                    .withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                _getStatusText(job.statusId),
                                                style: TextStyle(
                                                    color: _getStatusColor(job.statusId)),
                                              ),
                                            ),
                                          ),
                                        ),

                                        /// Actions
                                        SizedBox(
                                          width: 60,
                                          child: IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () =>
                                                _showEditJobDialog(job),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                ),



              ],
            ),
    );
  }
}

