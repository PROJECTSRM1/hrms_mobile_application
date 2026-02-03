import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/widgets/hrms_app_bar.dart';
import '../../models/holiday_model.dart';
import '../../services/holiday_service.dart';

class HolidayCalendarScreen extends StatefulWidget {
  const HolidayCalendarScreen({super.key});

  @override
  State<HolidayCalendarScreen> createState() =>
      _HolidayCalendarScreenState();
}

class _HolidayCalendarScreenState
    extends State<HolidayCalendarScreen> {
  late Future<List<Holiday>> future;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    future = HolidayService.fetchHolidays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: const HrmsAppBar(),
      body: FutureBuilder<List<Holiday>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style:
                    const TextStyle(color: Colors.red),
              ),
            );
          }

          final holidays = snapshot.data!
              .where((h) => h.date.year == selectedYear)
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _header(),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final monthHolidays = holidays
                      .where(
                          (h) => h.date.month == month)
                      .toList();

                  return _monthCard(month, monthHolidays);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Holiday Calendar',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedYear,
              items: List.generate(
                5,
                (i) => DateTime.now().year - i,
              )
                  .map(
                    (y) => DropdownMenuItem(
                      value: y,
                      child: Text(y.toString()),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() => selectedYear = v!);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ================= MONTH CARD =================

  Widget _monthCard(int month, List<Holiday> holidays) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${DateFormat.MMM().format(DateTime(0, month))} $selectedYear',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const Divider(height: 20),
          if (holidays.isEmpty)
            const Text(
              'No Holidays',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            )
          else
            ...holidays.map(
              (h) => Padding(
                padding:
                    const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd')
                          .format(h.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        h.name,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
