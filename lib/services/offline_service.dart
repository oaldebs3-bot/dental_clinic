import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/patient.dart';
import '../models/appointment.dart';

class OfflineService {
  static const String _patientsBox = 'patients_cache';
  static const String _appointmentsBox = 'appointments_cache';
  static const String _recordsBox = 'dental_records_cache';
  static const String _billingBox = 'billing_cache';
  static const String _pendingOpsBox = 'pending_operations';

  Future<void> initialize() async {
    await Hive.openBox<String>(_patientsBox);
    await Hive.openBox<String>(_appointmentsBox);
    await Hive.openBox<String>(_recordsBox);
    await Hive.openBox<String>(_billingBox);
    await Hive.openBox<String>(_pendingOpsBox);
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
