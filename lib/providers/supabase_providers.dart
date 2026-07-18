import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) => SupabaseService().client);

final patientsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.from('patients').stream(primaryKey: ['id']).order('created_at', ascending: false);
});

final appointmentsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.from('appointments').stream(primaryKey: ['id']).order('start_time', ascending: true);
});

final billingStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.from('billing').stream(primaryKey: ['id']).order('created_at', ascending: false);
});

final dentalRecordsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, patientId) async {
  final client = ref.watch(supabaseClientProvider);
  return client.from('dental_records').select().eq('patient_id', patientId) as List<Map<String, dynamic>>;
});
