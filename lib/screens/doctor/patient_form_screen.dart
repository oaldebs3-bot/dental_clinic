import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/supabase_providers.dart';
import '../../widgets/app_back_button.dart';

class PatientFormScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? patient;
  const PatientFormScreen({super.key, this.patient});

  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _gender = 'male';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.patient != null) {
      _nameCtrl.text = widget.patient!['full_name'] ?? '';
      _phoneCtrl.text = widget.patient!['phone'] ?? '';
      _notesCtrl.text = widget.patient!['notes'] ?? '';
      _gender = widget.patient!['gender'] ?? 'male';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final client = ref.read(supabaseClientProvider);
      if (client == null) { throw Exception('Supabase غير متصل. تأكد من اتصال الإنترنت.'); }
      final data = {
        'full_name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'gender': _gender,
        'notes': _notesCtrl.text.trim(),
      };
      if (widget.patient != null) {
        await client.from('patients').update(data).eq('id', widget.patient!['id']);
      } else {
        final uid = client.auth.currentUser?.id;
        if (uid == null) { throw Exception('يجب تسجيل الدخول أولاً'); }
        data['user_id'] = uid;
        await client.from('patients').insert(data);
      }
      ref.invalidate(patientsFutureProvider);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.patient != null;
    return Scaffold(
      appBar: AppBar(leading: const AppBackButton(), title: Text(isEdit ? 'تعديل مريض' : 'إضافة مريض')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D9488), Color(0xFF021A17)]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'الاسم الكامل'), style: const TextStyle(color: Colors.white), textAlign: TextAlign.right),
              const SizedBox(height: 14),
              TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'رقم الهاتف'), style: const TextStyle(color: Colors.white), keyboardType: TextInputType.phone, textAlign: TextAlign.right),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _gender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('ذكر', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 'female', child: Text('أنثى', style: TextStyle(color: Colors.white))),
                ],
                onChanged: (v) => setState(() => _gender = v!),
                decoration: const InputDecoration(labelText: 'الجنس'),
                dropdownColor: const Color(0xFF115E59),
              ),
              const SizedBox(height: 14),
              TextField(controller: _notesCtrl, decoration: const InputDecoration(labelText: 'ملاحظات'), style: const TextStyle(color: Colors.white), maxLines: 3, textAlign: TextAlign.right),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black)) : Text(isEdit ? 'حفظ التعديلات' : 'إضافة المريض'),
              )),
            ]),
          ),
        ),
      ),
    );
  }
}
