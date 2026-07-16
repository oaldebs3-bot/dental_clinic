class DentalRecord {
  final String? id;
  final String patientId;
  final String doctorId;
  final String? appointmentId;
  final int toothNumber;
  final String procedureType;
  final String? notes;
  final DateTime createdAt;

  DentalRecord({
    this.id,
    required this.patientId,
    required this.doctorId,
    this.appointmentId,
    required this.toothNumber,
    required this.procedureType,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'patient_id': patientId,
        'doctor_id': doctorId,
        'appointment_id': appointmentId,
        'tooth_number': toothNumber,
        'procedure_type': procedureType,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  factory DentalRecord.fromJson(Map<String, dynamic> json) => DentalRecord(
        id: json['id'] as String?,
        patientId: json['patient_id'] as String,
        doctorId: json['doctor_id'] as String,
        appointmentId: json['appointment_id'] as String?,
        toothNumber: json['tooth_number'] as int,
        procedureType: json['procedure_type'] as String,
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
