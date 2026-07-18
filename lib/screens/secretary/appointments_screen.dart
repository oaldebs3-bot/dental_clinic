import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/supabase_providers.dart';
import '../../widgets/dental_colors.dart';
import '../../widgets/confirm_dialog.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(appointmentsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المواعيد')),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)])),
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
              Expanded(
                child: appointmentsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.redAccent))),
                  data: (appointments) {
                    if (appointments.isEmpty) return const Center(child: Text('لا توجد مواعيد', style: TextStyle(color: Colors.white54)));
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: appointments.length,
                      itemBuilder: (_, i) {
                        final a = appointments[i];
                        return Card(
                          color: DentalColors.card,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(a['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            subtitle: Text(a['start_time']?.toString().substring(0, 16) ?? '', style: const TextStyle(color: Colors.white54)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (a['status'] == 'scheduled')
                                  IconButton(
                                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                                    onPressed: () async {
                                      final ok = await showConfirmDialog(context, title: 'تأكيد موعد', message: 'تأكيد هذا الموعد؟');
                                      if (ok) {
                                        ref.read(supabaseClientProvider).from('appointments').update({'status': 'completed'}).eq('id', a['id']);
                                      }
                                    },
                                  ),
                                if (a['status'] == 'scheduled')
                                  IconButton(
                                    icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                                    onPressed: () async {
                                      final ok = await showConfirmDialog(context, title: 'إلغاء موعد', message: 'إلغاء هذا الموعد؟');
                                      if (ok) {
                                        ref.read(supabaseClientProvider).from('appointments').update({'status': 'cancelled'}).eq('id', a['id']);
                                      }
                                    },
                                  ),
                                Chip(
                                  label: Text(_statusText(a['status'] as String? ?? ''), style: const TextStyle(fontSize: 10, color: Colors.white)),
                                  backgroundColor: _statusColor(a['status'] as String? ?? '').withOpacity(0.2),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/book-appointment'),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('حجز موعد جديد'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusText(String s) => switch (s) { 'scheduled' => 'مؤكد', 'completed' => 'تم', 'cancelled' => 'ملغي', 'no_show' => 'غائب', _ => s };
  Color _statusColor(String s) => switch (s) { 'scheduled' => Colors.blue, 'completed' => Colors.green, 'cancelled' => Colors.red, 'no_show' => Colors.orange, _ => Colors.grey };
}
