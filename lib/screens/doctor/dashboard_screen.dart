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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM y', 'ar').format(now);

    return Scaffold(
      appBar: AppBar(title: const Text('لوحة التحكم'), actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await AuthService().signOut();
            if (context.mounted) context.go('/login');
          },
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateStr, style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
            const SizedBox(height: 8),
            Text('مرحباً دكتور', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Row(children: [
              Expanded(child: _StatCard(icon: Icons.people, label: 'مرضى اليوم', value: '8', color: Colors.blue)),
              SizedBox(width: 12),
              Expanded(child: _StatCard(icon: Icons.schedule, label: 'مواعيد', value: '12', color: Colors.green)),
              SizedBox(width: 12),
              Expanded(child: _StatCard(icon: Icons.attach_money, label: 'إيرادات', value: '2.5M', color: Colors.orange)),
            ]),
            const SizedBox(height: 24),
            Text('قائمة انتظار اليوم', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(child: ListView.builder(
              itemCount: 5,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${i + 1}')),
                  title: Text('مريض ${i + 1}'),
                  subtitle: Text('${9 + i}:00 - خلع ضرس'),
                  trailing: Chip(label: Text(i == 0 ? 'بانتظار' : 'مؤكد', style: const TextStyle(fontSize: 11))),
                ),
              ),
            )),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) {
          setState(() => _navIndex = i);
          final routes = ['/dashboard', '/dental-chart/0', '/reports'];
          context.go(routes[i]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.medical_services), label: 'الأسنان'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'التقارير'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String label, value; final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ]),
      ),
    );
  }
}
