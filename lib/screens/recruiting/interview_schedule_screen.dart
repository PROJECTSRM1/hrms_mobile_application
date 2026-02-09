// lib/screens/recruiting/interview_schedule_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../models/interview_schedule_model.dart';
import '../../models/candidate_model.dart';
import '../../models/designation_model.dart';
import '../../models/interview_stage_model.dart';

class InterviewScheduleScreen extends StatefulWidget {
  const InterviewScheduleScreen({super.key});

  @override
  State<InterviewScheduleScreen> createState() =>
      _InterviewScheduleScreenState();
}

class _InterviewScheduleScreenState extends State<InterviewScheduleScreen> {
  final ApiService _apiService = ApiService();
  List<InterviewSchedule> _interviews = [];
  List<Candidate> _candidates = [];
  List<Designation> _designations = [];
  List<InterviewStage> _stages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

Future<void> _loadData() async {
  setState(() => _isLoading = true);

  try {
    final interviews = await _apiService.getInterviewSchedules();
    final candidates = await _apiService.getCandidates();
    final designations = await _apiService.getDesignations();
    final stages = await _apiService.getInterviewStages();

    if (!mounted) return;

    setState(() {
      _interviews = interviews;
      _candidates = candidates;
      _designations = designations;
      _stages = stages;
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


  String _getCandidateName(int candidateId) {
    try {
      return _candidates
          .firstWhere((c) => c.id == candidateId)
          .candidateName;
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

  String _getStageName(int stageId) {
    try {
      return _stages.firstWhere((s) => s.id == stageId).stageName;
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getStatusText(int statusId) {
    switch (statusId) {
      case 1:
        return 'In Progress';
      case 2:
        return 'Selected';
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

  void _showScheduleInterviewDialog() {

    // final parentContext = context; 

    int? selectedCandidateId;
    int? selectedDesigId;
    int? selectedStageId;
    int selectedStatusId = 1; // Default to In Progress
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Schedule Interview'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('* Candidate',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      hintText: 'Select Candidate',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    initialValue: selectedCandidateId,
                    items: _candidates.map((candidate) {
                      return DropdownMenuItem(
                        value: candidate.id,
                        child: Text(candidate.candidateName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedCandidateId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('* Role',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      hintText: 'Select Role',
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
                  ),
                  const SizedBox(height: 16),
                  const Text('* Date',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)),
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
                  const Text('* Stage',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      hintText: 'Select Stage',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    initialValue: selectedStageId,
                    items: _stages.map((stage) {
                      return DropdownMenuItem(
                        value: stage.id,
                        child: Text(stage.stageName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedStageId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('* Status',
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
                      DropdownMenuItem(value: 1, child: Text('In Progress')),
                      DropdownMenuItem(value: 2, child: Text('Selected')),
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
                onPressed: selectedCandidateId == null ||
                        selectedDesigId == null ||
                        selectedStageId == null ||
                        selectedDate == null
                    ? null
                    : () async {
                        try {
                          await _apiService.scheduleInterview(
                            ScheduleInterviewRequest(
                              candidateId: selectedCandidateId!,
                              designationId: selectedDesigId!,
                              statusId: selectedStatusId,
                              stageId: selectedStageId!,
                              interviewDate: DateFormat('yyyy-MM-dd')
                                  .format(selectedDate!),
                            ),
                          );
                          if (!mounted) return;

                          Navigator.of(this.context).pop();

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(content: Text('Interview scheduled successfully')),
                          );

                          _loadData();

                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
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

  void _showEditInterviewDialog(InterviewSchedule interview) 
  {
    // final parentContext = context;
    int selectedCandidateId = interview.candidateId;
    int selectedDesigId = interview.designationId;
    int selectedStageId = interview.stageId;
    int selectedStatusId = interview.statusId;
    DateTime selectedDate = interview.interviewDate;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Interview'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('* Candidate',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    initialValue: selectedCandidateId,
                    items: _candidates.map((candidate) {
                      return DropdownMenuItem(
                        value: candidate.id,
                        child: Text(candidate.candidateName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedCandidateId = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('* Role',
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
                  const Text('* Date',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)),
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
                  const Text('* Stage',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    initialValue: selectedStageId,
                    items: _stages.map((stage) {
                      return DropdownMenuItem(
                        value: stage.id,
                        child: Text(stage.stageName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedStageId = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('* Status',
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
                      DropdownMenuItem(value: 1, child: Text('In Progress')),
                      DropdownMenuItem(value: 2, child: Text('Selected')),
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
                      await _apiService.updateInterviewSchedule(
                        interview.id,
                        UpdateInterviewScheduleRequest(
                          candidateId: selectedCandidateId,
                          designationId: selectedDesigId,
                          statusId: selectedStatusId,
                          stageId: selectedStageId,
                          interviewDate:
                              DateFormat('yyyy-MM-dd').format(selectedDate),
                          createdBy: 1,
                        ),
                      );

                      if (!mounted) return;

                      Navigator.of(this.context).pop();

                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(content: Text('Interview updated successfully')),
                      );

                      _loadData();
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                  ,

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
        title: const Text('Scheduled Interviews'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Scheduled Interviews',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Table Header
                
        Expanded(
  child: _interviews.isEmpty
      ? const Center(child: Text('No interviews scheduled'))
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
                      SizedBox(width: 150, child: Center(child: Text('Role', style: TextStyle(fontWeight: FontWeight.bold)))),
                      SizedBox(width: 120, child: Center(child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)))),
                      SizedBox(width: 120, child: Center(child: Text('Stage', style: TextStyle(fontWeight: FontWeight.bold)))),
                      SizedBox(width: 120, child: Center(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)))),
                      SizedBox(width: 160, child: Center(child: Text('Feedback', style: TextStyle(fontWeight: FontWeight.bold)))),
                      SizedBox(width: 80, child: Center(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
                ),

                /// ===== ROWS =====
                ..._interviews.map((i) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [

                        SizedBox(width: 150, child: Center(child: Text(_getCandidateName(i.candidateId)))),
                        SizedBox(width: 150, child: Center(child: Text(_getDesignationName(i.designationId)))),
                        SizedBox(width: 120, child: Center(child: Text(DateFormat('yyyy-MM-dd').format(i.interviewDate)))),
                        SizedBox(width: 120, child: Center(child: Text(_getStageName(i.stageId)))),

                        SizedBox(
                          width: 120,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(i.statusId).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _getStatusText(i.statusId),
                                style: TextStyle(color: _getStatusColor(i.statusId)),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 160, child: Center(child: Text(i.feedback ?? 'No feedback'))),

                        SizedBox(
                          width: 80,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditInterviewDialog(i),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showScheduleInterviewDialog,
        backgroundColor: const Color(0xFF0AA6B7),
        icon: const Icon(Icons.add),
        label: const Text('Schedule Interview'),
      ),
    );
  }
}

