import 'package:flutter/material.dart';

class CreatePayslipsScreen extends StatefulWidget {
  const CreatePayslipsScreen({super.key});

  @override
  State<CreatePayslipsScreen> createState() => _CreatePayslipsScreenState();
}

class _CreatePayslipsScreenState extends State<CreatePayslipsScreen> {
  String? _selectedEmployee;
  String _selectedMonth = 'January';
  String _selectedYear = '2024';

  final List<String> _employees = [
    'John Doe',
    'Jane Smith',
    'Bob Wilson',
    'Alice Brown',
  ];

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Create Payslips'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payslip Details',
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
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue:_selectedMonth,
                          decoration: const InputDecoration(
                            labelText: 'Month',
                            border: OutlineInputBorder(),
                          ),
                          items: _months
                              .map((month) => DropdownMenuItem(
                                    value: month,
                                    child: Text(month),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMonth = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedYear,
                          decoration: const InputDecoration(
                            labelText: 'Year',
                            border: OutlineInputBorder(),
                          ),
                          items: ['2024', '2023', '2022']
                              .map((year) => DropdownMenuItem(
                                    value: year,
                                    child: Text(year),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedYear = value!;
                            });
                          },
                        ),
                      ),
                    ],
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
                    'Salary Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSalaryRow('Basic Salary', '₹30,000'),
                  _buildSalaryRow('HRA', '₹12,000'),
                  _buildSalaryRow('Allowances', '₹8,000'),
                  const Divider(height: 24),
                  _buildSalaryRow('Gross Salary', '₹50,000', isBold: true),
                  const SizedBox(height: 16),
                  const Text(
                    'Deductions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSalaryRow('Tax', '₹5,000', isDeduction: true),
                  _buildSalaryRow('PF', '₹1,800', isDeduction: true),
                  const Divider(height: 24),
                  _buildSalaryRow(
                    'Net Salary',
                    '₹43,200',
                    isBold: true,
                    color: const Color(0xFF0AA6B7),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedEmployee != null
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payslip generated successfully!'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0AA6B7),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Generate Payslip',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
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

  Widget _buildSalaryRow(
    String label,
    String amount, {
    bool isBold = false,
    bool isDeduction = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? (isDeduction ? Colors.red : Colors.black),
            ),
          ),
          Text(
            isDeduction ? '-$amount' : amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? (isDeduction ? Colors.red : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}