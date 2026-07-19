import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_back_button.dart';
import '../../widgets/dental_colors.dart';
import '../../providers/supabase_providers.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  final String? patientId;
  const BookAppointmentScreen({super.key, this.patientId});

  @override
  ConsumerState<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  String _procedure = 'كشف';
  String? _selectedPatientId;
  bool _saving = false;

  Future<void> _save() async {
    if (_selectedPatientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر مريضاً أولاً')));
      return;
    }
    setState(() => _saving = true);
    try {
      final client = ref.read(supabaseClientProvider);
      if (client == null) { throw Exception('Supabase غير متصل'); }
      final start = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _startTime.hour, _startTime.minute);
      final end = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _endTime.hour, _endTime.minute);
      await client.from('appointments').insert({
        'patient_id': _selectedPatientId,
        'doctor_id': client.auth.currentUser!.id,
        'title': _procedure,
        'start_time': start.toUtc().toIso8601String(),
        'end_time': end.toUtc().toIso8601String(),
        'status': 'scheduled',
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(patientsFutureProvider);
    final dateStr = DateFormat('d/M/yyyy').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(leading: const AppBackButton(), title: const Text('حجز موعد جديد')),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)])),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              patientsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('خطأ: $e'),
                data: (patients) => DropdownButtonFormField<String>(
                  value: _selectedPatientId,
                  items: patients.map((p) => DropdownMenuItem(value: p['id'] as String?, child: Text(p['full_name'] ?? '', style: const TextStyle(color: Colors.white)))).toList(),
                  onChanged: (v) => setState(() => _selectedPatientId = v),
                  decoration: const InputDecoration(labelText: 'المريض'),
                  dropdownColor: const Color(0xFF115E59),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: DentalColors.card,
                child: Column(children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today_rounded, color: Colors.tealAccent),
                    title: const Text('التاريخ', style: TextStyle(color: Colors.white70)),
                    trailing: Text(dateStr, style: const TextStyle(color: Colors.white)),
                    onTap: () async {
                      final d = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
                      if (d != null) setState(() => _selectedDate = d);
                    },
                  ),
                  Divider(color: Colors.white.withOpacity(0.06), height: 1),
                  ListTile(
                    leading: const Icon(Icons.access_time_rounded, color: Colors.tealAccent),
                    title: const Text('وقت البداية', style: TextStyle(color: Colors.white70)),
                    trailing: Text(_startTime.format(context), style: const TextStyle(color: Colors.white)),
                    onTap: () async {
                      final t = await showTimePicker(context: context, initialTime: _startTime);
                      if (t != null) setState(() => _startTime = t);
                    },
                  ),
                  Divider(color: Colors.white.withOpacity(0.06), height: 1),
                  ListTile(
                    leading: const Icon(Icons.access_time_rounded, color: Colors.tealAccent),
                    title: const Text('وقت النهاية', style: TextStyle(color: Colors.white70)),
                    trailing: Text(_endTime.format(context), style: const TextStyle(color: Colors.white)),
                    onTap: () async {
                      final t = await showTimePicker(context: context, initialTime: _endTime);
                      if (t != null) setState(() => _endTime = t);
                    },
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _procedure,
                items: ['كشف', 'حشو', 'سحب عصب', 'خلع', 'تنظيف', 'تركيب'].map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(color: Colors.white)))).toList(),
                onChanged: (v) => setState(() => _procedure = v!),
                decoration: const InputDecoration(labelText: 'نوع الإجراء'),
                dropdownColor: const Color(0xFF115E59),
              ),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black)) : const Text('تأكيد الحجز'),
              )),
            ]),
          ),
        ),
      ),
    );
  }
}
