import 'package:flutter/material.dart';
import '../../widgets/app_back_button.dart';
import '../../widgets/dental_colors.dart';

class PatientDetailScreen extends StatelessWidget {
  final String patientId;
  final String patientName;
  final String patientPhone;

  const PatientDetailScreen({
    super.key,
    required this.patientId,
    this.patientName = 'مريض',
    this.patientPhone = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(patientName),
        actions: [
          IconButton(
            icon: const Icon(Icons.medical_services_outlined, color: Colors.tealAccent),
            tooltip: 'مخطط الأسنان',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Scaffold(
                appBar: AppBar(leading: const AppBackButton(), title: const Text('مخطط الأسنان')),
                body: const Center(child: Text('قريباً...', style: TextStyle(color: Colors.white54))),
              )),
            ),
          ),
        ],
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
                        child: Text(patientName[0], style: const TextStyle(fontSize: 24, color: Colors.tealAccent)),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(patientName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(patientPhone, style: const TextStyle(color: Colors.white54)),
                          Text('رقم الملف: $patientId', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                        ],
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('سجل العلاج', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                ...List.generate(3, (i) => Card(
                  color: DentalColors.card,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: DentalColors.primary.withOpacity(0.15),
                      child: const Icon(Icons.medical_services, color: Colors.tealAccent),
                    ),
                    title: Text('زيارة ${i + 1} — ${["حشو ضرس", "خلع", "تنظيف"][i]}', style: const TextStyle(color: Colors.white)),
                    subtitle: Text('${14 - i}/7/2026', style: const TextStyle(color: Colors.white54)),
                    trailing: const Icon(Icons.chevron_left, color: Colors.white38),
                  ),
                )),
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
