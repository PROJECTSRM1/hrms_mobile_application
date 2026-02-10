import 'package:flutter/material.dart';
import 'my_tax_planner_screen.dart';

class ITDeclarationScreen extends StatelessWidget {
  const ITDeclarationScreen({super.key});

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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 6),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.black),
          ),
          const SizedBox(width: 12),
        ],
      ),

      drawer: _buildDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// My Tax Planner + Year
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const MyTaxPlannerScreen(),
    ),
  );
},

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1677FF),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "My Tax Planner",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: "2025 - 2026",
                      items: ["2025 - 2026"]
                          .map(
                            (year) => DropdownMenuItem<String>(
                              value: year,
                              child: Text(year),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Declaration Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  const Text("Declaration Status : "),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Locked",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Apr 2025",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            _card("Section 80C (max limit 1.5 lakh)",
                "Declared: ₹0 / 150000"),

            _card("Other Chapter VI-A Deductions",
                "Declared amount ₹ 0"),

            _card("House Rent Allowance",
                "Declared amount ₹ 0"),

            _card("Medical (Sec 80D)",
                "Declared amount ₹ 0"),

            _card("Income / Loss from House Property",
                "Declared amount ₹ 0"),

            _card("Other Income",
                "Declared amount ₹ 0"),

            _card("TCS / TDS Deduction",
                "Declared amount ₹ 0"),
          ],
        ),
      ),
    );
  }

  /// Drawer
  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration:
                const BoxDecoration(color: Color(0xFF008C8C)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.account_balance,
                    color: Colors.white, size: 40),
                SizedBox(height: 8),
                Text("HRMS Portal",
                    style:
                        TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
          _drawerItem(Icons.money, "Salary", false),
          _drawerItem(Icons.receipt_long, "Payslips", false),
          _drawerItem(Icons.trending_up, "Salary Revision", false),
          _drawerItem(Icons.assignment, "IT Declaration", true),
          _drawerItem(Icons.upload_file, "Proof of Investment", false),
        ],
      ),
    );
  }

  static Widget _drawerItem(
      IconData icon, String title, bool active) {
    return ListTile(
      leading: Icon(icon,
          color: active ? Colors.teal : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: active ? Colors.teal : Colors.black,
          fontWeight:
              active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {},
    );
  }

  /// Declaration Card
  static Widget _card(String title, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Text(amount,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "No declaration added",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
