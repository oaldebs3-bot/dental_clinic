import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/dental_colors.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المواعيد')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'بحث عن مريض',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.06),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 10,
                itemBuilder: (_, i) => Card(
                  color: DentalColors.card,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text('مريض ${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    subtitle: Text('${9 + i}:00 - ${i % 2 == 0 ? "حشو" : "خلع"}', style: const TextStyle(color: Colors.white54)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                          tooltip: 'تأكيد',
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                          tooltip: 'إلغاء',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/book-appointment'),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('حجز موعد جديد'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
