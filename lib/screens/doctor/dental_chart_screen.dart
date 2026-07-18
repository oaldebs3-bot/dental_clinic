import 'package:flutter/material.dart';
import '../../widgets/app_back_button.dart';
import '../../widgets/tooth_data.dart';

class DentalChartScreen extends StatelessWidget {
  final String patientId;
  const DentalChartScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('مخطط الأسنان'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Jaw label
                const Text('الفك العلوي', style: TextStyle(color: Colors.white38, fontSize: 11)),
                const SizedBox(height: 4),
                Row(children: [
                  for (int i = 1; i <= 8; i++) _Tooth(number: i),
                ], mainAxisAlignment: MainAxisAlignment.center),
                const SizedBox(height: 4),
                Row(children: [
                  for (int i = 9; i <= 16; i++) _Tooth(number: i),
                ], mainAxisAlignment: MainAxisAlignment.center),
                const SizedBox(height: 20),
                Divider(color: Colors.white.withOpacity(0.1), height: 1),
                const SizedBox(height: 20),
                const Text('الفك السفلي', style: TextStyle(color: Colors.white38, fontSize: 11)),
                const SizedBox(height: 4),
                Row(children: [
                  for (int i = 17; i <= 24; i++) _Tooth(number: i),
                ], mainAxisAlignment: MainAxisAlignment.center),
                const SizedBox(height: 4),
                Row(children: [
                  for (int i = 25; i <= 32; i++) _Tooth(number: i),
                ], mainAxisAlignment: MainAxisAlignment.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tooth extends StatelessWidget {
  final int number;
  const _Tooth({required this.number});

  ToothData get _data => ToothData.forNumber(number);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showToothMenu(context),
      child: Container(
        width: 38, height: 50, margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_data.fdi, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
            const SizedBox(height: 1),
            Text('$number', style: const TextStyle(fontSize: 7, color: Colors.white38)),
          ],
        ),
      ),
    );
  }

  void _showToothMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A2E2A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(_data.fdi, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
            const SizedBox(height: 4),
            Text(_data.name, style: const TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 4),
            Text('السن رقم $number', style: const TextStyle(fontSize: 11, color: Colors.white38)),
            const SizedBox(height: 20),
            const _ProcedureTile(title: 'حشو - 2026/05/12', icon: Icons.check_circle, color: Colors.green),
            const _ProcedureTile(title: 'سحب عصب - 2026/03/20', icon: Icons.check_circle, color: Colors.green),
            const Divider(color: Colors.white12),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'filling', child: Text('حشو', style: TextStyle(color: Colors.white))),
                DropdownMenuItem(value: 'root_canal', child: Text('سحب عصب', style: TextStyle(color: Colors.white))),
                DropdownMenuItem(value: 'cleaning', child: Text('تنظيف', style: TextStyle(color: Colors.white))),
                DropdownMenuItem(value: 'extraction', child: Text('خلع', style: TextStyle(color: Colors.white))),
              ],
              onChanged: (_) {},
              decoration: const InputDecoration(labelText: 'إجراء جديد', labelStyle: TextStyle(color: Colors.white60)),
              dropdownColor: const Color(0xFF115E59),
            ),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حفظ'),
            )),
          ],
        ),
      ),
    );
  }
}

class _ProcedureTile extends StatelessWidget {
  final String title; final IconData icon; final Color color;
  const _ProcedureTile({required this.title, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: color),
    title: Text(title, style: const TextStyle(color: Colors.white70)),
    dense: true,
  );
}
