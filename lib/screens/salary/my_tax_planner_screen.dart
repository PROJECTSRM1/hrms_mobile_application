import 'package:flutter/material.dart';
import 'tax_planner_cards_screen.dart';

class MyTaxPlannerScreen extends StatefulWidget {
  const MyTaxPlannerScreen({super.key});

  @override
  State<MyTaxPlannerScreen> createState() =>
      _MyTaxPlannerScreenState();
}

class _MyTaxPlannerScreenState extends State<MyTaxPlannerScreen> {
  String selectedYear = "2025 - 2026";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF008C8C),
        title: const Text(
          "IT Declaration",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),

      body: Stack(
        children: [

          /// 🔹 YEAR DROPDOWN (TOP RIGHT)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              height: 40,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border:
                    Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedYear,
                  items: const [
                    DropdownMenuItem(
                      value: "2025 - 2026",
                      child: Text("2025 - 2026"),
                    ),
                    DropdownMenuItem(
                      value: "2024 - 2025",
                      child: Text("2024 - 2025"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                    });
                  },
                ),
              ),
            ),
          ),

          /// 🔹 CENTER CARD
          Center(
            child: Container(
              width: 420,
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 36),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Create Your Tax Plan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please create a tax plan to calculate your taxes.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const TaxPlannerCardsScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1677FF),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        "Create Plan",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
