import 'package:flutter/material.dart';

class HraEditDialog extends StatelessWidget {
  const HraEditDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "House Rent Allowance",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),

            const SizedBox(height: 16),

            _infoBox("Total Declared ₹0.00"),

            const SizedBox(height: 16),

            const Text("House 1", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            _dropdown("From *", "Apr 2025"),
            _dropdown("To *", "Mar 2026"),

            const SizedBox(height: 12),

            _input("Monthly Rent Amount *", "₹"),

            const SizedBox(height: 8),
            const Text(
              "ANNUAL RENT AMOUNT ₹ : 0.00",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 16),

            _dropdown("Full Address", "New Address"),

            const SizedBox(height: 12),

            _input("House Name / Number", ""),
            _input("Street / Area / Locality", ""),
            _input("Town / City", ""),
            _input("Pincode *", ""),

            const SizedBox(height: 16),

            const Text("Does your landlord have a PAN?"),
            Row(
              children: const [
                Radio(value: true, groupValue: true, onChanged: null),
                Text("Yes"),
                Radio(value: false, groupValue: true, onChanged: null),
                Text("No"),
              ],
            ),

            _input("Landlord's Name *", ""),
            _input("Landlord's PAN *", ""),

            const SizedBox(height: 20),

            /// Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text("Clear Form"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Update"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _input(String label, String prefix) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefix,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dropdown(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(value),
      ),
    );
  }

  Widget _infoBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text),
    );
  }
}
