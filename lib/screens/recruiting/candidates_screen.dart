// lib/screens/recruiting/candidates_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../models/candidate_model.dart';
import '../../models/designation_model.dart';

class CandidatesScreen extends StatefulWidget {
  const CandidatesScreen({super.key});

  @override
  State<CandidatesScreen> createState() => _CandidatesScreenState();
}

class _CandidatesScreenState extends State<CandidatesScreen> {
  final ApiService _apiService = ApiService();
  List<Candidate> _candidates = [];
  List<Designation> _designations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

Future<void> _loadData() async {
  setState(() => _isLoading = true);

  try {
    final candidates = await _apiService.getCandidates();
    final designations = await _apiService.getDesignations();

    if (!mounted) return;

    setState(() {
      _candidates = candidates;
      _designations = designations;
      _isLoading = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error loading data: $e')),
    );
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
        return 'In Progress';
      case 2:
        return 'Hired';
      case 3:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int statusId) {
    switch (statusId) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showAddCandidateDialog() 
  {
    final formKey = GlobalKey<FormState>();
    // final parentContext = context;
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final mobileController = TextEditingController();
    final addressController = TextEditingController();
    int? selectedDesigId;
    DateTime? selectedDate;
    int selectedStatusId = 1; // Default to In Progress
    String? resumeFilename;
    

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Candidate'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('* Full Name',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('* Designation',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        hintText: 'Select Designation',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      initialValue: selectedDesigId,
                      items: _designations.map((desig) {
                        return DropdownMenuItem(
                          value: desig.id,
                          child: Text(desig.designationName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedDesigId = value;
                        });
                      },
                      validator: (value) => value == null ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('* Email',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required';
                        if (!value!.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('* Mobile',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: mobileController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('* Date of Birth',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now()
                              .subtract(const Duration(days: 365 * 25)),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setDialogState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: Text(
                          selectedDate == null
                              ? 'Select date'
                              : DateFormat('yyyy-MM-dd').format(selectedDate!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Address',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Status',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      initialValue: selectedStatusId,
                      items: const [
                        DropdownMenuItem(
                            value: 1, child: Text('In Progress')),
                        DropdownMenuItem(value: 2, child: Text('Hired')),
                        DropdownMenuItem(value: 3, child: Text('Rejected')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedStatusId = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Resume',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'doc', 'docx'],
                        );
                        if (result != null && result.files.single.path != null) {
                          try {
                            final file = File(result.files.single.path!);

                            final filename = await _apiService.uploadResume(file);

                            if (!mounted) return;

                            setDialogState(() 
                            {
                              resumeFilename = filename;
                            });
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                  content: Text('Resume uploaded successfully')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Upload failed: $e')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.upload_file),
                      label: Text(resumeFilename ?? 'Upload Resume'),
                    ),
                  ],
                ),
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
                  if (formKey.currentState!.validate() &&
                      selectedDate != null &&
                      selectedDesigId != null) {
                    try {
                      await _apiService.createCandidate(
                        CreateCandidateRequest(
                          candidateName: nameController.text,
                          designationId: selectedDesigId!,
                          dob: DateFormat('yyyy-MM-dd').format(selectedDate!),
                          email: emailController.text,
                          mobile: mobileController.text,
                          address: addressController.text,
                          applicationStatusId: selectedStatusId,
                          uploadResume: resumeFilename ?? '',
                        ),
                      );
                      if (!mounted) return;

                      Navigator.pop(this.context);
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(content: Text('Candidate added successfully')),
                      );
                      _loadData();
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditCandidateDialog(Candidate candidate) {
    final formKey = GlobalKey<FormState>();
    // final parentContext = context;
    final nameController = TextEditingController(text: candidate.candidateName);
    final emailController = TextEditingController(text: candidate.email);
    final mobileController = TextEditingController(text: candidate.mobile);
    final addressController = TextEditingController(text: candidate.address);
    int selectedDesigId = candidate.designationId;
    DateTime selectedDate = candidate.dob;
    int selectedStatusId = candidate.applicationStatusId;
    String resumeFilename = candidate.uploadResume;
    // _showEditCandidateDialog();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Candidate'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('* Full Name',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('* Designation',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      initialValue: selectedDesigId,
                      items: _designations.map((desig) {
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
                    const Text('* Email',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required';
                        if (!value!.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('* Mobile',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: mobileController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('* Date of Birth',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setDialogState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(selectedDate),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Address',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Status',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      initialValue: selectedStatusId,
                      items: const [
                        DropdownMenuItem(
                            value: 1, child: Text('In Progress')),
                        DropdownMenuItem(value: 2, child: Text('Hired')),
                        DropdownMenuItem(value: 3, child: Text('Rejected')),
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
                  if (formKey.currentState!.validate()) {
                    try {
                      await _apiService.updateCandidate(
                        candidate.id,
                        UpdateCandidateRequest(
                          candidateName: nameController.text,
                          designationId: selectedDesigId,
                          dob: DateFormat('yyyy-MM-dd').format(selectedDate),
                          email: emailController.text,
                          mobile: mobileController.text,
                          address: addressController.text,
                          applicationStatusId: selectedStatusId,
                          uploadResume: resumeFilename,
                        ),
                      );
                      if (mounted) {
                        Navigator.pop(this.context);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                              content: Text('Candidate updated successfully')),
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
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Candidates Applied'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: 
              [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Candidates Applied',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddCandidateDialog,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Candidate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0AA6B7),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Table Header

                 Expanded(
  child: _candidates.isEmpty
      ? const Center(child: Text('No candidates found'))
      : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Column(
              children: [

                /// ===== HEADER =====
                Container(
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Row(
                    children: [
                      SizedBox(width: 150, child: Center(child: Text('Candidate', style: TextStyle(fontWeight: FontWeight.bold)))),
                      SizedBox(width: 150, child: Center(child: Text('Designation', style: TextStyle(fontWeight: FontWeight.bold)))),
                      SizedBox(width: 220, child: Center(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)))),
                      SizedBox(width: 120, child: Center(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)))),
                      SizedBox(width: 120, child: Center(child: Text('Resume', style: TextStyle(fontWeight: FontWeight.bold)))),
                      SizedBox(width: 80, child: Center(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
                ),

                /// ===== ROWS =====
                ..._candidates.map((c) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [

                        SizedBox(width: 150, child: Center(child: Text(c.candidateName))),
                        SizedBox(width: 150, child: Center(child: Text(_getDesignationName(c.designationId)))),
                        SizedBox(width: 220, child: Center(child: Text(c.email, overflow: TextOverflow.ellipsis))),

                        SizedBox(
                          width: 120,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(c.applicationStatusId).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _getStatusText(c.applicationStatusId),
                                style: TextStyle(color: _getStatusColor(c.applicationStatusId)),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 120,
                          child: Center(
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('View'),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 80,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () => _showEditCandidateDialog(c),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
)



              ],
    
            ),
    );
  }
}


