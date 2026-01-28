import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/widgets/hrms_app_bar.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  final ScrollController _horizontalController = ScrollController();

  final List<Map<String, String>> attendanceData = [
    {
      "id": "1",
      "name": "Mahesh",
      "dept": "IT",
      "date": "2026-01-28",
      "login": "-",
      "logout": "-"
    },
    {
      "id": "2",
      "name": "Nandhini",
      "dept": "HR",
      "date": "2026-01-28",
      "login": "-",
      "logout": "-"
    },
    {
      "id": "3",
      "name": "Kiran",
      "dept": "Developer",
      "date": "2026-01-28",
      "login": "-",
      "logout": "-"
    },
    {
      "id": "4",
      "name": "Krishna",
      "dept": "Sales",
      "date": "2026-01-28",
      "login": "-",
      "logout": "-"
    },
  ];

  String _fmt(DateTime d) => DateFormat("dd-MM-yyyy").format(d);

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate : toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        isFrom ? fromDate = picked : toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HrmsAppBar(),
      backgroundColor: const Color(0xFFF6F8FB),
      body: Column(
        children: [

          /// ================= FROM / TO DATES =================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _dateWithLabel(
                label: "From",
                value: _fmt(fromDate),
                onTap: () => _pickDate(true),
              ),
              const SizedBox(width: 16),
              _dateWithLabel(
                label: "To",
                value: _fmt(toDate),
                onTap: () => _pickDate(false),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// ================= ACTION BUTTONS =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _outlineButton("Export")),
                const SizedBox(width: 12),
                Expanded(child: _primaryButton("+ Add Attendance")),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// ================= TABLE WITH HORIZONTAL SCROLL =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 760,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _tableHeader(),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.separated(
                            itemCount: attendanceData.length,
                            // ignore: unnecessary_underscores
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) =>
                                _tableRow(attendanceData[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// ================= DATE WITH LABEL =================
  Widget _dateWithLabel({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Text(value),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_month, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ================= BUTTONS =================
  Widget _primaryButton(String text) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1F6CFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _outlineButton(String text) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  /// ================= TABLE =================
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      color: const Color(0xFFF3F4F6),
      child: const Row(
        children: [
          _HeaderCell("Emp ID", width: 70),
          _HeaderCell("Emp Name", width: 140),
          _HeaderCell("Department", width: 140),
          _HeaderCell("Date", width: 140),
          _HeaderCell("Login Time", width: 120),
          _HeaderCell("Logout Time", width: 120),
        ],
      ),
    );
  }

  Widget _tableRow(Map<String, String> row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        children: [
          _Cell(row["id"]!, width: 70),
          _Cell(row["name"]!, width: 140),
          _Cell(row["dept"]!, width: 140),
          _Cell(row["date"]!, width: 140),
          _Cell(row["login"]!, width: 120),
          _Cell(row["logout"]!, width: 120),
        ],
      ),
    );
  }
}

/// ================= TABLE CELLS =================
class _HeaderCell extends StatelessWidget {
  final String text;
  final double width;
  const _HeaderCell(this.text, {required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final double width;
  const _Cell(this.text, {required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(text),
    );
  }
}
