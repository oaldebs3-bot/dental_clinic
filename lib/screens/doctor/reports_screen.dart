import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/supabase_providers.dart';
import '../../widgets/dental_colors.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billingAsync = ref.watch(billingFutureProvider);
    final patientsAsync = ref.watch(patientsFutureProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('التقارير المالية')),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)])),
        child: SafeArea(
          child: billingAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.redAccent))),
            data: (bills) {
              final totalIncome = bills.fold<double>(0, (s, b) => s + (b['paid_amount'] ?? 0));
              final totalPending = bills.fold<double>(0, (s, b) => s + ((b['total_amount'] ?? 0) - (b['paid_amount'] ?? 0)));
              final paidCount = bills.where((b) => b['status'] == 'paid').length;
              final patientCount = patientsAsync.valueOrNull?.length ?? 0;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(children: [
                    Expanded(child: _ReportCard(label: 'دخل اليوم', value: '$totalIncome ل.س', color: Colors.greenAccent, icon: Icons.today_rounded)),
                    const SizedBox(width: 10),
                    Expanded(child: _ReportCard(label: 'متبقي', value: '$totalPending ل.س', color: Colors.orangeAccent, icon: Icons.account_balance_wallet_rounded)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _ReportCard(label: 'فاتورة مدفوعة', value: '$paidCount', color: Colors.blueAccent, icon: Icons.receipt_rounded)),
                    const SizedBox(width: 10),
                    Expanded(child: _ReportCard(label: 'عدد المرضى', value: '$patientCount', color: Colors.purpleAccent, icon: Icons.people_alt_rounded)),
                  ]),
                  const SizedBox(height: 24),
                  const Text('الفواتير', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  ...bills.take(20).map((b) => Card(
                    color: DentalColors.card,
                    margin: const EdgeInsets.only(bottom: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.tealAccent.withOpacity(0.15),
                        child: Icon(Icons.receipt, color: Colors.tealAccent, size: 18),
                      ),
                      title: Text('فاتورة #${(b['id'] as String).substring(0, 6)}', style: const TextStyle(color: Colors.white)),
                      subtitle: Text('${b['paid_amount']} / ${b['total_amount']} ل.س', style: const TextStyle(color: Colors.white54)),
                      trailing: Chip(
                        label: Text(b['status'] == 'paid' ? 'مدفوع' : 'متبقي', style: const TextStyle(fontSize: 10, color: Colors.white)),
                        backgroundColor: (b['status'] == 'paid' ? Colors.green : Colors.orange).withOpacity(0.2),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  )),
                ]),
              );
            },
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
      decoration: BoxDecoration(color: DentalColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white54)),
      ]),
    );
  }
}
