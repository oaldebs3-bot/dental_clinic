import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      appBar: AppBar(title: const Text('حجز موعد جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(decoration: InputDecoration(labelText: 'المريض', prefixIcon: Icon(Icons.search))),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('التاريخ'),
              trailing: Text(dateStr),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (d != null) setState(() => _selectedDate = d);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('وقت البداية'),
              trailing: Text(_startTime.format(context)),
              onTap: () async {
                final t = await showTimePicker(context: context, initialTime: _startTime);
                if (t != null) setState(() => _startTime = t);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('وقت النهاية'),
              trailing: Text(_endTime.format(context)),
              onTap: () async {
                final t = await showTimePicker(context: context, initialTime: _endTime);
                if (t != null) setState(() => _endTime = t);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _procedure,
              items: const [
                DropdownMenuItem(value: 'كشف', child: Text('كشف')),
                DropdownMenuItem(value: 'حشو', child: Text('حشو')),
                DropdownMenuItem(value: 'سحب عصب', child: Text('سحب عصب')),
                DropdownMenuItem(value: 'خلع', child: Text('خلع')),
                DropdownMenuItem(value: 'تنظيف', child: Text('تنظيف')),
                DropdownMenuItem(value: 'تركيب', child: Text('تركيب')),
              ],
              onChanged: (v) => setState(() => _procedure = v!),
              decoration: const InputDecoration(labelText: 'نوع الإجراء'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'ملاحظات', alignLabelWithHint: true),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check),
                label: const Text('تأكيد الحجز'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
