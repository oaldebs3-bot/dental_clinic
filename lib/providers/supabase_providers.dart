import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../services/offline_service.dart';

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  try {
    return SupabaseService().client;
  } catch (_) {
    return null;
  }
});

final refreshPatientsProvider = StateProvider<int>((ref) => 0);
final refreshAppointmentsProvider = StateProvider<int>((ref) => 0);
final refreshBillingProvider = StateProvider<int>((ref) => 0);

final patientsFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(refreshPatientsProvider);
  try {
    final client = ref.read(supabaseClientProvider);
    if (client == null) return OfflineService().getCachedMaps(_PatientsBox);
    final data = await client.from('patients').select().order('created_at', ascending: false).timeout(const Duration(seconds: 10));
    final list = data as List<Map<String, dynamic>>;
    try { await OfflineService().cacheMaps(_PatientsBox, list); } catch (_) {}
    return list;
  } catch (_) {
    return OfflineService().getCachedMaps(_PatientsBox);
  }
});

final appointmentsFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(refreshAppointmentsProvider);
  try {
    final client = ref.read(supabaseClientProvider);
    if (client == null) return OfflineService().getCachedMaps(_AppointmentsBox);
    final data = await client.from('appointments').select().order('start_time', ascending: true).timeout(const Duration(seconds: 10));
    final list = data as List<Map<String, dynamic>>;
    try { await OfflineService().cacheMaps(_AppointmentsBox, list); } catch (_) {}
    return list;
  } catch (_) {
    return OfflineService().getCachedMaps(_AppointmentsBox);
  }
});

final billingFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(refreshBillingProvider);
  try {
    final client = ref.read(supabaseClientProvider);
    if (client == null) return OfflineService().getCachedMaps(_BillingBox);
    final data = await client.from('billing').select().order('created_at', ascending: false).timeout(const Duration(seconds: 10));
    final list = data as List<Map<String, dynamic>>;
    try { await OfflineService().cacheMaps(_BillingBox, list); } catch (_) {}
    return list;
  } catch (_) {
    return OfflineService().getCachedMaps(_BillingBox);
  }
});

const _PatientsBox = 'patients_cache';
const _AppointmentsBox = 'appointments_cache';
const _BillingBox = 'billing_cache';
