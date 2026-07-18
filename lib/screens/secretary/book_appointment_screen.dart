import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/app_back_button.dart';
import '../../widgets/dental_colors.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String? patientId;
  const BookAppointmentScreen({super.key, this.patientId});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  String _procedure = 'كشف';

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d/M/yyyy').format(_selectedDate);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('حجز موعد جديد'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث عن مريض...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.06),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 20),
                Card(
                  color: DentalColors.card,
                  child: Column(
                    children: [
                      _PickerTile(
                        icon: Icons.calendar_today_rounded,
                        title: 'التاريخ',
                        value: dateStr,
                        onTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 90)),
                            builder: (_, child) => Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: DentalColors.primary, brightness: Brightness.dark)), child: child!),
                          );
                          if (d != null) setState(() => _selectedDate = d);
                        },
                      ),
                      Divider(color: Colors.white.withOpacity(0.06), height: 1),
                      _PickerTile(
                        icon: Icons.access_time_rounded,
                        title: 'وقت البداية',
                        value: _startTime.format(context),
                        onTap: () async {
                          final t = await showTimePicker(context: context, initialTime: _startTime);
                          if (t != null) setState(() => _startTime = t);
                        },
                      ),
                      Divider(color: Colors.white.withOpacity(0.06), height: 1),
                      _PickerTile(
                        icon: Icons.access_time_rounded,
                        title: 'وقت النهاية',
                        value: _endTime.format(context),
                        onTap: () async {
                          final t = await showTimePicker(context: context, initialTime: _endTime);
                          if (t != null) setState(() => _endTime = t);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _procedure,
                  items: const [
                    DropdownMenuItem(value: 'كشف', child: Text('كشف', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'حشو', child: Text('حشو', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'سحب عصب', child: Text('سحب عصب', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'خلع', child: Text('خلع', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'تنظيف', child: Text('تنظيف', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'تركيب', child: Text('تركيب', style: TextStyle(color: Colors.white))),
                  ],
                  onChanged: (v) => setState(() => _procedure = v!),
                  decoration: InputDecoration(
                    labelText: 'نوع الإجراء',
                    labelStyle: const TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.06),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                  dropdownColor: const Color(0xFF115E59),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ملاحظات إضافية...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.06),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    alignLabelWithHint: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('تأكيد الحجز'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon; final String title, value; final VoidCallback onTap;

  const _PickerTile({required this.icon, required this.title, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.tealAccent),
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      trailing: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}
