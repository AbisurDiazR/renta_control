class Invoice {
  final String id;
  final String customerName;
  final String createdAt;
  final String status;
  final double total;

  Invoice({
    required this.id,
    required this.customerName,
    required this.createdAt,
    required this.status,
    required this.total,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      customerName: json['customer']['legal_name'],
      createdAt: json['created_at'],
      status: json['status'],
      total: (json['total'] as num).toDouble(),
    );
  }
}
