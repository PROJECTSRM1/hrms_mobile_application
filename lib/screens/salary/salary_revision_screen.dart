import 'package:flutter/material.dart';

class SalaryRevisionScreen extends StatelessWidget {
  const SalaryRevisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D9488),
        title: const Text("Salary Revision Analytics"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _salaryGrowthCard(),
            const SizedBox(height: 16),
            _ctcRevisionCard(),
          ],
        ),
      ),
    );
  }

  /* ================= SALARY GRAPH ================= */

  Widget _salaryGrowthCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Salary Growth by Year of Joining",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 260,
              width: double.infinity,
              child: CustomPaint(
                painter: SalaryChartPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ================= CTC REVISION ================= */

  Widget _ctcRevisionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "CTC Revision Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),

            _CtcItem(
              lastRevision: "15-Jan-2024",
              payout: "Jan 24",
              revised: "65,000",
              previous: "58,000",
              duration: "12 M",
              amount: "7,000",
            ),

            Divider(height: 28),

            _CtcItem(
              lastRevision: "15-Jan-2023",
              payout: "Jan 23",
              revised: "58,000",
              previous: "52,000",
              duration: "12 M",
              amount: "6,000",
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= CTC ITEM ================= */

class _CtcItem extends StatelessWidget {
  final String lastRevision;
  final String payout;
  final String revised;
  final String previous;
  final String duration;
  final String amount;

  const _CtcItem({
    required this.lastRevision,
    required this.payout,
    required this.revised,
    required this.previous,
    required this.duration,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row("Last Revision", lastRevision),
        _row("Payout", payout),
        _row("Revised CTC", revised),
        _row("Previous CTC", previous),
        _row("Duration", duration),
        _row("Amount", amount, highlight: true),
      ],
    );
  }

  Widget _row(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
              color: highlight ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= GRAPH PAINTER ================= */

class SalaryChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 40.0;
    const bottomPad = 30.0;

    final chartWidth = size.width - leftPad;
    final chartHeight = size.height - bottomPad;

    final axisPaint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1;

    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()..color = Colors.blue;

    /* Axes */
    canvas.drawLine(
      Offset(leftPad, 0),
      Offset(leftPad, chartHeight),
      axisPaint,
    );

    canvas.drawLine(
      Offset(leftPad, chartHeight),
      Offset(size.width, chartHeight),
      axisPaint,
    );

    /* Y-axis grid + labels */
    final yLabels = [8, 6, 4, 2, 0];
    for (int i = 0; i < yLabels.length; i++) {
      final y = chartHeight * (i / 4);

      canvas.drawLine(
        Offset(leftPad, y),
        Offset(size.width, y),
        gridPaint,
      );

      _drawText(
        canvas,
        yLabels[i].toString(),
        Offset(8, y - 6),
      );
    }

    /* X-axis data */
    final years = ["2019", "2020", "2021", "2022", "2023"];
    final values = [2.5, 2.0, 3.8, 5.2, 4.0];

    final path = Path();

    for (int i = 0; i < values.length; i++) {
      final x = leftPad + chartWidth * (i / (values.length - 1));
      final y = chartHeight - (values[i] / 8) * chartHeight;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 4, dotPaint);

      _drawText(
        canvas,
        years[i],
        Offset(x - 14, chartHeight + 6),
      );
    }

    canvas.drawPath(path, linePaint);
  }

  void _drawText(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 11, color: Colors.black54),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
