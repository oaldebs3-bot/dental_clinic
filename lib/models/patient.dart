class Patient {
  final String? id;
  final String? userId;
  final String fullName;
  final String phone;
  final int? age;
  final String? gender;
  final String? medicalHistory;
  final DateTime createdAt;

  Patient({
    this.id,
    this.userId,
    required this.fullName,
    required this.phone,
    this.age,
    this.gender,
    this.medicalHistory,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'full_name': fullName,
        'phone': phone,
        'age': age,
        'gender': gender,
        'medical_history': medicalHistory,
        'created_at': createdAt.toIso8601String(),
      };

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json['id'] as String?,
        userId: json['user_id'] as String?,
        fullName: json['full_name'] as String,
        phone: json['phone'] as String,
        age: json['age'] as int?,
        gender: json['gender'] as String?,
        medicalHistory: json['medical_history'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
