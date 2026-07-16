class AppUser {
  final String id;
  final String fullName;
  final String? phone;
  final String role;

  AppUser({
    required this.id,
    required this.fullName,
    this.phone,
    this.role = 'patient',
  });

  bool get isDoctor => role == 'doctor';
  bool get isSecretary => role == 'secretary';
  bool get isPatient => role == 'patient';
  bool get isStaff => isDoctor || isSecretary;

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'phone': phone,
        'role': role,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
        phone: json['phone'] as String?,
        role: json['role'] as String? ?? 'patient',
      );
}
