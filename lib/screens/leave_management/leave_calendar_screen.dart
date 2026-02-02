import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/widgets/hrms_app_bar.dart';
import '../../models/holiday_model.dart';
import '../../services/holiday_service.dart';

class LeaveCalendarScreen extends StatefulWidget {
  const LeaveCalendarScreen({super.key});

  @override
  State<LeaveCalendarScreen> createState() => _LeaveCalendarScreenState();
}

class _LeaveCalendarScreenState extends State<LeaveCalendarScreen> {
  late Future<List<Holiday>> future;

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    future = HolidayService.fetchHolidays();
  }

  Future<void> _refresh() async {
    setState(() {
      future = HolidayService.fetchHolidays();
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: const HrmsAppBar(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Holiday>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final allHolidays = snapshot.data!;
            final visibleHolidays = allHolidays.where(
              (h) =>
                  h.date.year == selectedYear &&
                  h.date.month == selectedMonth,
            );

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _topControls(),
                const SizedBox(height: 16),
                _weekHeader(),
                const SizedBox(height: 8),
                _calendarGrid(visibleHolidays.toList()),
              ],
            );
          },
        ),
      ),
    );
  }

  // ================= TOP CONTROLS =================

  Widget _topControls() {
    return Row(
      children: [
        _dropdown(
          value: selectedYear,
          items: List.generate(5, (i) => DateTime.now().year - i),
          onChanged: (v) => setState(() => selectedYear = v!),
        ),
        const SizedBox(width: 10),
        _dropdown(
          value: selectedMonth,
          items: List.generate(12, (i) => i + 1),
          display: (v) => DateFormat.MMM().format(DateTime(selectedYear, v)),
          onChanged: (v) => setState(() => selectedMonth = v!),
        ),
      ],
    );
  }

  Widget _dropdown({
    required int value,
    required List<int> items,
    String Function(int)? display,
    required Function(int?) onChanged,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: value,
            isExpanded: true,
            items: items
                .map(
                  (v) => DropdownMenuItem(
                    value: v,
                    child: Text(display != null ? display(v) : '$v'),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  // ================= CALENDAR =================

  Widget _weekHeader() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      children: days
          .map(
            (d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _calendarGrid(List<Holiday> holidays) {
    final firstDay = DateTime(selectedYear, selectedMonth, 1);
    final daysInMonth =
        DateUtils.getDaysInMonth(selectedYear, selectedMonth);
    final startOffset = firstDay.weekday % 7;
    final totalCells =
        ((startOffset + daysInMonth) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final day = index - startOffset + 1;
        if (day < 1 || day > daysInMonth) return const SizedBox();

        final date = DateTime(selectedYear, selectedMonth, day);
        final dayEvents =
            holidays.where((h) => h.date.day == day).toList();

        return _dayCell(date, dayEvents);
      },
    );
  }

  Widget _dayCell(DateTime date, List<Holiday> events) {
    final isToday = DateUtils.isSameDay(date, DateTime.now());

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: events.isEmpty ? null : () => _showEvents(date, events),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: events.isNotEmpty
              ? const Color(0xFF0AA6B7).withValues(alpha: 0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isToday
              ? Border.all(color: const Color(0xFF0AA6B7), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: events.isNotEmpty
                    ? const Color(0xFF0AA6B7)
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            ...events.take(2).map(
              (e) => Container(
                margin: const EdgeInsets.only(bottom: 2),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0AA6B7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  e.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (events.length > 2)
              Text(
                '+${events.length - 2} more',
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF0AA6B7),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ================= POPUP =================

  void _showEvents(DateTime date, List<Holiday> events) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, dd MMM yyyy').format(date),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ...events.map(
              (e) => ListTile(
                leading: const Icon(
                  Icons.celebration,
                  color: Color(0xFF0AA6B7),
                ),
                title: Text(e.name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
