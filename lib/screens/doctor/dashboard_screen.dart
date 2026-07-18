import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _navIndex = 0;

  Future<void> _onLogout() async {
    await AuthService().signOut();
    if (!context.mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM y', 'ar').format(now);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'تسجيل الخروج',
            onPressed: _onLogout,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D9488), Color(0xFF021A17)],
          ),
        ),
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
                Row(
                  children: [
                    Expanded(child: _StatCard(
                      icon: Icons.people_alt_rounded,
                      label: 'مرضى اليوم',
                      value: '8',
                      gradient: const [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _StatCard(
                      icon: Icons.schedule_rounded,
                      label: 'مواعيد',
                      value: '12',
                      gradient: const [Color(0xFF059669), Color(0xFF047857)],
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _StatCard(
                      icon: Icons.attach_money_rounded,
                      label: 'إيرادات',
                      value: '2.5M',
                      gradient: const [Color(0xFFD97706), Color(0xFFB45309)],
                    )),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('قائمة انتظار اليوم', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => context.go('/appointments'),
                      child: const Text('عرض الكل', style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...List.generate(5, (i) => _AppointmentCard(
                  index: i,
                  onTap: () => context.go('/dental-chart/${i + 1}'),
                )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF1A3A37), width: 0.5)),
        ),
        child: NavigationBar(
          selectedIndex: _navIndex,
          backgroundColor: const Color(0xFF021A17),
          indicatorColor: Colors.tealAccent.withOpacity(0.2),
          onDestinationSelected: (i) {
            setState(() => _navIndex = i);
            final routes = ['/dashboard', '/dental-chart/0', '/reports'];
            context.go(routes[i]);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: Colors.white54),
              selectedIcon: Icon(Icons.dashboard_rounded, color: Colors.tealAccent),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.medical_services_outlined, color: Colors.white54),
              selectedIcon: Icon(Icons.medical_services_rounded, color: Colors.tealAccent),
              label: 'الأسنان',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined, color: Colors.white54),
              selectedIcon: Icon(Icons.bar_chart_rounded, color: Colors.tealAccent),
              label: 'التقارير',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final List<Color> gradient;

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
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  const _AppointmentCard({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = index == 0 ? 'بانتظار' : 'مؤكد';
    final statusColor = index == 0 ? Colors.amber : Colors.tealAccent;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: Colors.tealAccent.withOpacity(0.15),
          child: Text('${index + 1}', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
        ),
        title: Text('مريض ${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        subtitle: Text('${9 + index}:00 - خلع ضرس', style: const TextStyle(color: Colors.white54, fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w500)),
        ),
        onTap: onTap,
      ),
    );
  }
}
