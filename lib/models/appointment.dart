class Appointment {
  final String? id;
  final String patientId;
  final String doctorId;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String status;
  final String? notes;
  final DateTime createdAt;

  Appointment({
    this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.appointmentTime,
    this.status = 'pending',
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'patient_id': patientId,
        'doctor_id': doctorId,
        'appointment_date': appointmentDate.toIso8601String().split('T').first,
        'appointment_time': appointmentTime,
        'status': status,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json['id'] as String?,
        patientId: json['patient_id'] as String,
        doctorId: json['doctor_id'] as String,
        appointmentDate: DateTime.parse(json['appointment_date'] as String),
        appointmentTime: json['appointment_time'] as String,
        status: json['status'] as String? ?? 'pending',
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
