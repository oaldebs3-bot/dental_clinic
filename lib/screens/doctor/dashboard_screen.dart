import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/supabase_providers.dart';
import '../../widgets/dental_colors.dart';
import '../../widgets/confirm_dialog.dart';

class DoctorDashboardScreen extends ConsumerStatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  ConsumerState<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends ConsumerState<DoctorDashboardScreen> {
  int _navIndex = 0;

  Future<void> _onLogout() async {
    final confirmed = await showConfirmDialog(context, title: 'تسجيل الخروج', message: 'هل تريد تسجيل الخروج؟');
    if (!confirmed || !context.mounted) return;
    try {
      await ref.read(authServiceProvider).signOut();
    } catch (_) {}
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM y', 'ar').format(now);
    final patientsAsync = ref.watch(patientsFutureProvider);
    final appointmentsAsync = ref.watch(appointmentsFutureProvider);
    final billingAsync = ref.watch(billingFutureProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        actions: [IconButton(icon: const Icon(Icons.logout_rounded), tooltip: 'تسجيل الخروج', onPressed: _onLogout)],
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)])),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateStr, style: const TextStyle(color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 4),
                const Text('مرحباً دكتور 👋', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Row(children: [
                  Expanded(child: _StatCard(icon: Icons.people_alt_rounded, label: 'عدد المرضى',
                    value: patientsAsync.valueOrNull?.length.toString() ?? '0',
                    gradient: const [Color(0xFF2563EB), Color(0xFF1D4ED8)])),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(icon: Icons.schedule_rounded, label: 'مواعيد اليوم',
                    value: appointmentsAsync.valueOrNull?.length.toString() ?? '0',
                    gradient: const [Color(0xFF059669), Color(0xFF047857)])),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(icon: Icons.attach_money_rounded, label: 'إيرادات',
                    value: billingAsync.valueOrNull?.fold<double>(0, (s, b) => s + (b['paid_amount'] ?? 0)).toString() ?? '0',
                    gradient: const [Color(0xFFD97706), Color(0xFFB45309)])),
                ]),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('آخر المرضى', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () => context.go('/patients'), child: const Text('عرض الكل', style: TextStyle(color: Colors.tealAccent, fontSize: 12))),
                ]),
                const SizedBox(height: 8),
                ...List.generate(
                  (patientsAsync.valueOrNull?.length ?? 0).clamp(0, 5),
                  (i) {
                    final p = patientsAsync.valueOrNull![i];
                    return Card(
                      color: DentalColors.card,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: DentalColors.primary.withOpacity(0.15),
                          child: Text((p['full_name'] as String? ?? '?')[0], style: const TextStyle(color: Colors.tealAccent)),
                        ),
                        title: Text(p['full_name'] ?? '', style: const TextStyle(color: Colors.white)),
                        subtitle: Text(p['phone'] ?? '', style: const TextStyle(color: Colors.white54)),
                        trailing: const Icon(Icons.chevron_left, color: Colors.white24),
                        onTap: () => context.go('/patient/${p['id']}'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF1A3A37), width: 0.5))),
        child: NavigationBar(
          selectedIndex: _navIndex,
          backgroundColor: const Color(0xFF021A17),
          indicatorColor: Colors.tealAccent.withOpacity(0.2),
          onDestinationSelected: (i) {
            setState(() => _navIndex = i);
            context.go(['/dashboard', '/patients', '/reports'][i]);
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined, color: Colors.white54), selectedIcon: Icon(Icons.dashboard_rounded, color: Colors.tealAccent), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.people_outline, color: Colors.white54), selectedIcon: Icon(Icons.people_rounded, color: Colors.tealAccent), label: 'المرضى'),
            NavigationDestination(icon: Icon(Icons.bar_chart_outlined, color: Colors.white54), selectedIcon: Icon(Icons.bar_chart_rounded, color: Colors.tealAccent), label: 'التقارير'),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String label, value; final List<Color> gradient;
  const _StatCard({required this.icon, required this.label, required this.value, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: gradient.last.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ]),
    );
  }
}
