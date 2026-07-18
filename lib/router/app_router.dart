import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/doctor/dashboard_screen.dart';
import '../screens/doctor/dental_chart_screen.dart';
import '../screens/doctor/reports_screen.dart';
import '../screens/doctor/patient_detail_screen.dart';
import '../screens/doctor/patient_list_screen.dart';
import '../screens/doctor/patient_form_screen.dart';
import '../screens/secretary/appointments_screen.dart';
import '../screens/secretary/cashier_screen.dart';
import '../screens/secretary/book_appointment_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(supabaseAuthStateProvider);
  final user = authState.valueOrNull;

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoginRoute = state.matchedLocation == '/login';
      final isLoggedIn = user != null;

      if (authState.isLoading) return null;
      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/dashboard', builder: (_, __) => user?.role == 'secretary' ? const AppointmentsScreen() : const DoctorDashboardScreen()),
      GoRoute(path: '/patients', builder: (_, __) => const PatientListScreen()),
      GoRoute(path: '/add-patient', builder: (_, __) => const PatientFormScreen()),
      GoRoute(
        path: '/edit-patient/:patientId',
        builder: (_, state) => PatientFormScreen(patient: {'id': state.pathParameters['patientId']}),
      ),
      GoRoute(
        path: '/dental-chart/:patientId',
        builder: (_, state) => DentalChartScreen(patientId: state.pathParameters['patientId']!),
      ),
      GoRoute(path: '/reports', builder: (_, __) => const ReportsScreen()),
      GoRoute(path: '/appointments', builder: (_, __) => const AppointmentsScreen()),
      GoRoute(path: '/cashier', builder: (_, __) => const CashierScreen()),
      GoRoute(path: '/book-appointment', builder: (_, __) => const BookAppointmentScreen()),
      GoRoute(
        path: '/patient/:patientId',
        builder: (_, state) {
          final id = state.pathParameters['patientId']!;
          return PatientDetailScreen(patientId: id, patientName: 'مريض $id', patientPhone: '09xxxxxxxx');
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(child: Text('الصفحة غير موجودة', style: TextStyle(color: Colors.white, fontSize: 18))),
    ),
  );
});
