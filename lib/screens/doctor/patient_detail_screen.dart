import 'package:flutter/material.dart';
import '../../models/patient.dart';

class PatientDetailScreen extends StatelessWidget {
  final Patient patient;
  const PatientDetailScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(patient.fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  CircleAvatar(
                    radius: 32,
                    child: Text(patient.fullName[0], style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(patient.fullName, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      Text(patient.phone, style: const TextStyle(color: Colors.grey)),
                      if (patient.gender != null) Text(patient.gender == 'male' ? 'ذكر' : 'أنثى'),
                    ],
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            Text('سجل العلاج', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.medical_services)),
                  title: Text('زيارة ${i + 1} — ${i == 0 ? "حشو ضرس" : i == 1 ? "خلع" : "تنظيف"}'),
                  subtitle: Text('${14 - i}/7/2026'),
                  trailing: const Icon(Icons.chevron_left),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('المواعيد القادمة', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.schedule, color: Colors.green),
                title: const Text('موعد قادم: 20/7/2026'),
                subtitle: const Text('10:00 - خلع ضرس العقل'),
                trailing: TextButton(onPressed: () {}, child: const Text('تأكيد')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('موعد جديد'),
      ),
    );
  }
}
