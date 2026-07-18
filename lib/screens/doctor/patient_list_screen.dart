import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/supabase_providers.dart';
import '../../widgets/dental_colors.dart';

class PatientListScreen extends ConsumerWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsAsync = ref.watch(patientsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('قائمة المرضى')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)]),
        ),
        child: SafeArea(
          child: patientsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.redAccent))),
            data: (patients) {
              if (patients.isEmpty) {
                return const Center(child: Text('لا يوجد مرضى', style: TextStyle(color: Colors.white54)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: patients.length,
                itemBuilder: (_, i) {
                  final p = patients[i];
                  return Card(
                    color: DentalColors.card,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: DentalColors.primary.withOpacity(0.2),
                        child: Text((p['full_name'] as String? ?? '?')[0], style: const TextStyle(color: Colors.tealAccent)),
                      ),
                      title: Text(p['full_name'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      subtitle: Text(p['phone'] ?? '', style: const TextStyle(color: Colors.white54)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.white38),
                            onPressed: () => context.go('/patient/${p['id']}'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.medical_services_rounded, color: Colors.tealAccent),
                            onPressed: () => context.go('/dental-chart/${p['id']}'),
                          ),
                        ],
                      ),
                      onTap: () => context.go('/patient/${p['id']}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-patient'),
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
