class Expense {
  final int? id;
  final String title;
  final double amount;
  final String note;
  final String date;
  final String category;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.note,
    required this.date,
    this.category = 'Khác',
  });

  // Chuyển đối tượng Expense thành Map để ghi vào SQLite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'amount': amount,
      'note': note,
      'date': date,
      'category': category,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Chuyển Map từ SQLite thành đối tượng Expense
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      note: (map['note'] ?? '') as String,
      date: (map['date'] ?? '') as String,
      category: (map['category'] ?? 'Khác') as String,
    );
  }
}
