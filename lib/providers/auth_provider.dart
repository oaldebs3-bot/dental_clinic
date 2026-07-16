import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final supabaseAuthStateProvider = StreamProvider<AppUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authState.map((event) {
    final user = event.session?.user;
    if (user == null) return null;
    return AppUser(
      id: user.id,
      fullName: user.userMetadata?['full_name'] as String? ?? '',
      phone: user.userMetadata?['phone'] as String?,
      role: user.userMetadata?['role'] as String? ?? 'patient',
    );
  });
});

final currentUserProvider = Provider<AppUser?>((ref) {
  final user = ref.watch(authServiceProvider).currentUser;
  if (user == null) return null;
  return AppUser(
    id: user.id,
    fullName: user.userMetadata?['full_name'] as String? ?? '',
    phone: user.userMetadata?['phone'] as String?,
    role: user.userMetadata?['role'] as String? ?? 'patient',
  );
});
