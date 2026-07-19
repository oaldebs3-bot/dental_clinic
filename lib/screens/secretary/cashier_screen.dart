import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/supabase_providers.dart';
import '../../widgets/dental_colors.dart';

class CashierScreen extends ConsumerWidget {
  const CashierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billingAsync = ref.watch(billingFutureProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الصندوق')),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)])),
        child: SafeArea(
          child: billingAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.redAccent))),
            data: (bills) {
              final totalRemaining = bills.fold<double>(0, (s, b) => s + ((b['total_amount'] ?? 0) - (b['paid_amount'] ?? 0)));
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: DentalColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.orangeAccent.withOpacity(0.2))),
                    child: Column(children: [
                      const Text('المبلغ المتبقي', style: TextStyle(color: Colors.white54, fontSize: 13)),
                      const SizedBox(height: 8),
                      Text('$totalRemaining ل.س', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                      const SizedBox(height: 4),
                      Text('${bills.length} فاتورة', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  ...bills.map((b) => Card(
                    color: DentalColors.card,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: (b['status'] == 'paid' ? Colors.green : Colors.amber).withOpacity(0.15),
                        child: Text('${b['total_amount']}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      title: Text('فاتورة #${(b['id'] as String).substring(0, 6)}', style: const TextStyle(color: Colors.white)),
                      subtitle: Text('المتبقي: ${(b['total_amount'] ?? 0) - (b['paid_amount'] ?? 0)} ل.س', style: const TextStyle(color: Colors.white54)),
                      trailing: b['status'] != 'paid'
                          ? GestureDetector(
                              onTap: () async {
                                try {
                                  final client = ref.read(supabaseClientProvider);
                                  if (client != null) { await client.from('billing').update({'paid_amount': b['total_amount'], 'status': 'paid'}).eq('id', b['id']); }
                                } catch (_) {}
                                ref.invalidate(billingFutureProvider);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: Colors.tealAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                                child: const Text('تسديد', style: TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.w500)),
                              ),
                            )
                          : Chip(label: const Text('مدفوع', style: TextStyle(fontSize: 10, color: Colors.white)), backgroundColor: Colors.green.withOpacity(0.2), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity.compact),
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
