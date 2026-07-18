import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../../widgets/app_back_button.dart';
import '../../widgets/dental_colors.dart';

class PatientDetailScreen extends StatelessWidget {
  final Patient patient;
  const PatientDetailScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(patient.fullName),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: DentalColors.card,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: DentalColors.primary.withOpacity(0.2),
                        child: Text(patient.fullName[0], style: const TextStyle(fontSize: 24, color: Colors.tealAccent)),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(patient.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(patient.phone, style: const TextStyle(color: Colors.white54)),
                          if (patient.gender != null) Text(patient.gender == 'male' ? 'ذكر' : 'أنثى', style: const TextStyle(color: Colors.white54)),
                        ],
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('سجل العلاج', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (_, i) => Card(
                    color: DentalColors.card,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: DentalColors.primary.withOpacity(0.15),
                        child: const Icon(Icons.medical_services, color: Colors.tealAccent),
                      ),
                      title: Text('زيارة ${i + 1} — ${i == 0 ? "حشو ضرس" : i == 1 ? "خلع" : "تنظيف"}', style: const TextStyle(color: Colors.white)),
                      subtitle: Text('${14 - i}/7/2026', style: const TextStyle(color: Colors.white54)),
                      trailing: const Icon(Icons.chevron_left, color: Colors.white38),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('المواعيد القادمة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                Card(
                  color: DentalColors.card,
                  child: ListTile(
                    leading: const Icon(Icons.schedule, color: Colors.green),
                    title: const Text('موعد قادم: 20/7/2026', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('10:00 - خلع ضرس العقل', style: TextStyle(color: Colors.white54)),
                    trailing: TextButton(onPressed: () {}, child: const Text('تأكيد', style: TextStyle(color: Colors.tealAccent))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('موعد جديد'),
      ),
    );
  }
}
