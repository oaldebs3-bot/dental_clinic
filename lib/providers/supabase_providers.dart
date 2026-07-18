import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) => SupabaseService().client);

Stream<List<Map<String, dynamic>>> _safeStream(Stream<List<Map<String, dynamic>>> stream) {
  return stream.timeout(
    const Duration(seconds: 15),
    onTimeout: (sink) => sink.add([]),
  ).handleError((_) => <Map<String, dynamic>>[]);
}

final patientsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  try {
    final client = ref.watch(supabaseClientProvider);
    return _safeStream(client.from('patients').stream(primaryKey: ['id']).order('created_at', ascending: false));
  } catch (_) {
    return Stream.value([]);
  }
});

final appointmentsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  try {
    final client = ref.watch(supabaseClientProvider);
    return _safeStream(client.from('appointments').stream(primaryKey: ['id']).order('start_time', ascending: true));
  } catch (_) {
    return Stream.value([]);
  }
});

final billingStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  try {
    final client = ref.watch(supabaseClientProvider);
    return _safeStream(client.from('billing').stream(primaryKey: ['id']).order('created_at', ascending: false));
  } catch (_) {
    return Stream.value([]);
  }
});
