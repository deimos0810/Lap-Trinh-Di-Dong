import 'package:sqflite/sqflite.dart';
import '../models/expense.dart';
import '../utils/database_helper.dart';

class ExpenseController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // 1. Thêm một mục chi tiêu mới
  Future<int> insertExpense(Expense expense) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 2. Lấy toàn bộ danh sách chi tiêu (sắp xếp theo id giảm dần)
  Future<List<Expense>> fetchAllExpenses() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'id DESC',
    );
    return maps.map((item) => Expense.fromMap(item)).toList();
  }

  // 3. Cập nhật một mục chi tiêu
  Future<int> updateExpense(Expense expense) async {
    final db = await _dbHelper.database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // 4. Xóa mục chi tiêu theo id
  Future<int> deleteExpense(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 5. Tính tổng số tiền chi tiêu
  Future<double> getTotalAmount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT SUM(amount) as total FROM expenses');
    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }

  // 6. Tìm kiếm chi tiêu theo nội dung hoặc ghi chú
  Future<List<Expense>> searchExpenses(String keyword) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'title LIKE ? OR note LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: 'id DESC',
    );
    return maps.map((item) => Expense.fromMap(item)).toList();
  }

  // 7. Lọc theo danh mục
  Future<List<Expense>> filterByCategory(String category) async {
    if (category == 'Tất cả') {
      return fetchAllExpenses();
    }
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'id DESC',
    );
    return maps.map((item) => Expense.fromMap(item)).toList();
  }
}
