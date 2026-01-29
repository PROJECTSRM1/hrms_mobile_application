import 'package:flutter/material.dart';

class SalaryRevisionScreen extends StatefulWidget {
  const SalaryRevisionScreen({super.key});

  @override
  State<SalaryRevisionScreen> createState() => _SalaryRevisionScreenState();
}

class _SalaryRevisionScreenState extends State<SalaryRevisionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEmployee;
  final _currentSalaryController = TextEditingController(text: '50,000');
  final _revisedSalaryController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime _effectiveDate = DateTime.now();

  final List<String> _employees = [
    'John Doe',
    'Jane Smith',
    'Bob Wilson',
    'Alice Brown',
  ];

  @override
  void dispose() {
    _currentSalaryController.dispose();
    _revisedSalaryController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  double? get _increasePercentage {
    final current = double.tryParse(_currentSalaryController.text.replaceAll(',', ''));
    final revised = double.tryParse(_revisedSalaryController.text.replaceAll(',', ''));
    if (current != null && revised != null && current > 0) {
      return ((revised - current) / current) * 100;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Salary Revision'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Employee Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedEmployee,
                      decoration: const InputDecoration(
                        labelText: 'Select Employee',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: _employees
                          .map((employee) => DropdownMenuItem(
                                value: employee,
                                child: Text(employee),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEmployee = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an employee';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Salary Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _currentSalaryController,
                      decoration: const InputDecoration(
                        labelText: 'Current Salary (₹)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _revisedSalaryController,
                      decoration: const InputDecoration(
                        labelText: 'Revised Salary (₹)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter revised salary';
                        }
                        return null;
                      },
                    ),
                    if (_increasePercentage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _increasePercentage! >= 0
                              ? Colors.green.withValues(alpha: 0.5)
                              : Colors.red.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _increasePercentage! >= 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: _increasePercentage! >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_increasePercentage!.toStringAsFixed(2)}% ${_increasePercentage! >= 0 ? 'increase' : 'decrease'}',
                              style: TextStyle(
                                color: _increasePercentage! >= 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today, color: Color(0xFF0AA6B7)),
                      title: const Text('Effective Date'),
                      subtitle: Text(
                        '${_effectiveDate.day}/${_effectiveDate.month}/${_effectiveDate.year}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _effectiveDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025),
                        );
                        if (picked != null) {
                          setState(() {
                            _effectiveDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Reason for Revision',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter reason for revision';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Salary revision submitted successfully!'),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0AA6B7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Revision',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}