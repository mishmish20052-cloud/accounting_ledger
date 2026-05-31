class TransactionModel {
  final String id;
  final String accountId;
  final double amount;
  final String type; // 'debit' (له) أو 'credit' (عليه)
  final String description;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      accountId: map['account_id'],
      amount: (map['amount'] ?? 0.0).toDouble(),
      type: map['type'],
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account_id': accountId,
      'amount': amount,
      'type': type,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}
