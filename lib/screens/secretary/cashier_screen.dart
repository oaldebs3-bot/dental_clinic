import 'package:flutter/material.dart';
import '../../widgets/dental_colors.dart';

class CashierScreen extends StatelessWidget {
  const CashierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصندوق')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: DentalColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orangeAccent.withOpacity(0.2)),
                  ),
                  child: const Column(children: [
                    Text('المبلغ المتبقي', style: TextStyle(color: Colors.white54, fontSize: 13)),
                    SizedBox(height: 8),
                    Text('3,200,000 ل.س', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                    SizedBox(height: 4),
                    Text('إجمالي الذمم', style: TextStyle(color: Colors.white38, fontSize: 11)),
                  ]),
                ),
                const SizedBox(height: 20),
                TextField(
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
                const SizedBox(height: 16),
                ...List.generate(10, (i) => Card(
                  color: DentalColors.card,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber.withOpacity(0.15),
                      child: Text('${i + 1}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                    ),
                    title: Text('مريض ${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    subtitle: Text('المتبقي: ${(i + 1) * 100}000 ل.س', style: const TextStyle(color: Colors.white54)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.tealAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('تسديد', style: TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                    onTap: () {},
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
