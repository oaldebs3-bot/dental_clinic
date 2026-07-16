class Billing {
  final String? id;
  final String patientId;
  final double totalAmount;
  final double paidAmount;
  final String paymentStatus;
  final DateTime createdAt;

  Billing({
    this.id,
    required this.patientId,
    required this.totalAmount,
    this.paidAmount = 0,
    this.paymentStatus = 'unpaid',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get remainingAmount => totalAmount - paidAmount;

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'patient_id': patientId,
        'total_amount': totalAmount,
        'paid_amount': paidAmount,
        'remaining_amount': remainingAmount,
        'payment_status': paymentStatus,
        'created_at': createdAt.toIso8601String(),
      };

  factory Billing.fromJson(Map<String, dynamic> json) => Billing(
        id: json['id'] as String?,
        patientId: json['patient_id'] as String,
        totalAmount: (json['total_amount'] as num).toDouble(),
        paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0,
        paymentStatus: json['payment_status'] as String? ?? 'unpaid',
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
