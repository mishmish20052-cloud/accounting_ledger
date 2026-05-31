class Account {
  final String id;
  final String name;
  final String phone;
  final double totalDebit;  // إجمالي المبالغ التي له
  final double totalCredit; // إجمالي المبالغ التي عليه
  final DateTime createdAt;

  Account({
    required this.id,
    required this.name,
    required this.phone,
    this.totalDebit = 0.0,
    this.totalCredit = 0.0,
    required this.createdAt,
  });

  // تحويل البيانات من قاعدة البيانات إلى كائن برمي
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      phone: map['phone'] ?? '',
      totalDebit: (map['total_debit'] ?? 0.0).toDouble(),
      totalCredit: (map['total_credit'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // تحويل الكائن البرمجي إلى خريطة لحفظه في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'total_debit': totalDebit,
      'total_credit': totalCredit,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
