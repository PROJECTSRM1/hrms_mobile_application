import 'package:flutter/material.dart';

class HolidayCalendarScreen extends StatelessWidget {
  const HolidayCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final holidays = [
      {'name': 'Republic Day', 'date': 'Jan 26, 2024', 'day': 'Friday'},
      {'name': 'Holi', 'date': 'Mar 25, 2024', 'day': 'Monday'},
      {'name': 'Good Friday', 'date': 'Mar 29, 2024', 'day': 'Friday'},
      {'name': 'Independence Day', 'date': 'Aug 15, 2024', 'day': 'Thursday'},
      {'name': 'Gandhi Jayanti', 'date': 'Oct 2, 2024', 'day': 'Wednesday'},
      {'name': 'Diwali', 'date': 'Nov 1, 2024', 'day': 'Friday'},
      {'name': 'Christmas', 'date': 'Dec 25, 2024', 'day': 'Wednesday'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Holiday Calendar'),
        backgroundColor: const Color(0xFF0AA6B7),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0AA6B7), Color(0xFF0891A1)],
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Total Holidays',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${holidays.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'in 2024',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: holidays.length,
              itemBuilder: (context, index) {
                final holiday = holidays[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0AA6B7).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.celebration,
                        color: Color(0xFF0AA6B7),
                      ),
                    ),
                    title: Text(
                      holiday['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          holiday['date']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          holiday['day']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}