import 'package:flutter/material.dart';
import '../../widgets/dental_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقارير المالية')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(children: [
                  Expanded(child: _ReportCard(label: 'دخل اليوم', value: '450,000 ل.س', color: Colors.greenAccent, icon: Icons.today_rounded)),
                  const SizedBox(width: 10),
                  Expanded(child: _ReportCard(label: 'دخل الشهر', value: '12,500,000 ل.س', color: Colors.blueAccent, icon: Icons.date_range_rounded)),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: _ReportCard(label: 'متبقي بالذمة', value: '3,200,000 ل.س', color: Colors.orangeAccent, icon: Icons.account_balance_wallet_rounded)),
                  const SizedBox(width: 10),
                  Expanded(child: _ReportCard(label: 'عدد المرضى', value: '87', color: Colors.purpleAccent, icon: Icons.people_alt_rounded)),
                ]),
                const SizedBox(height: 24),
                const Text('آخر المدفوعات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                ...List.generate(10, (i) => Card(
                  color: DentalColors.card,
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.tealAccent.withOpacity(0.15),
                      child: Text('${i + 1}', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                    ),
                    title: Text('مريض ${i + 1}', style: const TextStyle(color: Colors.white)),
                    subtitle: Text('دفع ${(i + 1) * 50}000 ل.س', style: const TextStyle(color: Colors.white54)),
                    trailing: Text('${i + 1}/7/2026', style: const TextStyle(color: Colors.white38)),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String label, value; final Color color; final IconData icon;
  const _ReportCard({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DentalColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white54)),
      ]),
    );
  }
}
