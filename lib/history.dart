class PaymentHistory {
  final int id;
  final String customerName;
  final String packageName;
  final double amount;
  final DateTime date;

  PaymentHistory({
    required this.id,
    required this.customerName,
    required this.packageName,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'packageName': packageName,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory PaymentHistory.fromMap(Map<String, dynamic> map) {
    return PaymentHistory(
      id: map['id'],
      customerName: map['customerName'],
      packageName: map['packageName'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}
