import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقارير المالية')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(children: [
              Expanded(child: _ReportCard(label: 'دخل اليوم', value: '450,000 ل.س', color: Colors.green)),
              SizedBox(width: 12),
              Expanded(child: _ReportCard(label: 'دخل الشهر', value: '12,500,000 ل.س', color: Colors.blue)),
            ]),
            const SizedBox(height: 12),
            const Row(children: [
              Expanded(child: _ReportCard(label: 'متبقي بالذمة', value: '3,200,000 ل.س', color: Colors.orange)),
              SizedBox(width: 12),
              Expanded(child: _ReportCard(label: 'عدد المرضى', value: '87', color: Colors.purple)),
            ]),
            const SizedBox(height: 24),
            const Text('آخر المدفوعات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, i) => ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text('مريض ${i + 1}'),
                subtitle: Text('دفع ${(i + 1) * 50}000 ل.س'),
                trailing: Text('${i + 1}/7/2026', style: const TextStyle(color: Colors.grey)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String label, value; final Color color;
  const _ReportCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
      ),
    );
  }
}
