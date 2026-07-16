import 'package:flutter/material.dart';

class DentalChartScreen extends StatelessWidget {
  final String patientId;
  const DentalChartScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مخطط الأسنان')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('اختر سن لعرض التاريخ والإجراءات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // Upper jaw
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (int i = 1; i <= 8; i++) _Tooth(number: i),
            ]),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (int i = 9; i <= 16; i++) _Tooth(number: i),
            ]),
            const SizedBox(height: 24),
            // Lower jaw
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (int i = 17; i <= 24; i++) _Tooth(number: i),
            ]),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (int i = 25; i <= 32; i++) _Tooth(number: i),
            ]),
          ],
        ),
      ),
    );
  }
}

class _Tooth extends StatelessWidget {
  final int number;
  const _Tooth({required this.number});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showToothMenu(context),
      child: Container(
        width: 36, height: 48, margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(child: Text('$number', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
      ),
    );
  }

  void _showToothMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('السن رقم $number', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('الإجراءات السابقة:', style: TextStyle(fontWeight: FontWeight.bold)),
            const ListTile(title: Text('حشو - 2026/05/12'), leading: Icon(Icons.check_circle, color: Colors.green)),
            const ListTile(title: Text('سحب عصب - 2026/03/20'), leading: Icon(Icons.check_circle, color: Colors.green)),
            const Divider(),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'filling', child: Text('حشو')),
                DropdownMenuItem(value: 'root_canal', child: Text('سحب عصب')),
                DropdownMenuItem(value: 'cleaning', child: Text('تنظيف')),
                DropdownMenuItem(value: 'extraction', child: Text('خلع')),
              ],
              onChanged: (_) {},
              decoration: const InputDecoration(labelText: 'إجراء جديد'),
            ),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('حفظ'))),
          ],
        ),
      ),
    );
  }
}
