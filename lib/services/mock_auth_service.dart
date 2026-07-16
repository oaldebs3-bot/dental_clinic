import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/patient.dart';

class MockAuthService {
  static const _boxName = 'mock_users';
  AppUser? _currentUser;

  Future<void> initialize() async {
    await Hive.openBox<String>(_boxName);
  }

  List<AppUser> _all() {
    final box = Hive.box<String>(_boxName);
    return box.values.map((v) => AppUser.fromJson(jsonDecode(v))).toList();
  }

  Future<void> _save(AppUser user) async {
    final box = Hive.box<String>(_boxName);
    await box.put(user.id, jsonEncode(user.toJson()));
  }

  AppUser? get currentUser => _currentUser;

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final user = AppUser(id: id, fullName: fullName, phone: phone, role: role);
    await _save(user);
    _currentUser = user;
    return user;
  }

  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final users = _all();
    if (users.isNotEmpty) {
      _currentUser = users.first;
      return _currentUser;
    }
    return null;
  }

  Future<void> signOut() async {
    _currentUser = null;
  }

  List<AppUser> getStaff() => _all().where((u) => u.isStaff).toList();

  List<Patient> getDemoPatients() => [
        Patient(id: 'p1', fullName: 'أحمد محمد', phone: '0933123456', gender: 'male'),
        Patient(id: 'p2', fullName: 'سارة علي', phone: '0944123456', gender: 'female'),
        Patient(id: 'p3', fullName: 'خالد عمر', phone: '0955123456', gender: 'male'),
        Patient(id: 'p4', fullName: 'نور حسن', phone: '0966123456', gender: 'female'),
        Patient(id: 'p5', fullName: 'محمود خالد', phone: '0977123456', gender: 'male'),
      ];
}
