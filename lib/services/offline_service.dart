import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/patient.dart';
import '../models/appointment.dart';

class OfflineService {
  static const String _patientsBox = 'patients_cache';
  static const String _appointmentsBox = 'appointments_cache';
  static const String _recordsBox = 'dental_records_cache';
  static const String _billingBox = 'billing_cache';
  static const String _pendingOpsBox = 'pending_operations';

  Future<void> initialize() async {
    try {
      await Hive.initFlutter();
    } catch (_) {}
    try { await Hive.openBox<String>(_patientsBox); } catch (_) {}
    try { await Hive.openBox<String>(_appointmentsBox); } catch (_) {}
    try { await Hive.openBox<String>(_recordsBox); } catch (_) {}
    try { await Hive.openBox<String>(_billingBox); } catch (_) {}
    try { await Hive.openBox<String>(_pendingOpsBox); } catch (_) {}
  }

  Future<void> cacheMaps(String boxName, List<Map<String, dynamic>> items) async {
    try {
      final box = Hive.box<String>(boxName);
      await box.clear();
      for (final item in items) {
        final id = item['id']?.toString() ?? '';
        if (id.isNotEmpty) await box.put(id, jsonEncode(item));
      }
    } catch (_) {}
  }

  List<Map<String, dynamic>> getCachedMaps(String boxName) {
    try {
      final box = Hive.box<String>(boxName);
      return box.values.map((v) => jsonDecode(v) as Map<String, dynamic>).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> cachePatients(List<Patient> patients) async {
    final box = Hive.box<String>(_patientsBox);
    for (final p in patients) {
      await box.put(p.id, jsonEncode(p.toJson()));
    }
  }

  Future<void> cacheAppointments(List<Appointment> appointments) async {
    final box = Hive.box<String>(_appointmentsBox);
    for (final a in appointments) {
      await box.put(a.id, jsonEncode(a.toJson()));
    }
  }

  List<Patient> getCachedPatients() {
    final box = Hive.box<String>(_patientsBox);
    return box.values.map((v) => Patient.fromJson(jsonDecode(v))).toList();
  }

  List<Appointment> getCachedAppointments() {
    final box = Hive.box<String>(_appointmentsBox);
    return box.values.map((v) => Appointment.fromJson(jsonDecode(v))).toList();
  }
}
