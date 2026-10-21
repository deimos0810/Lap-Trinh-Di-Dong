import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Khởi tạo FFI cho Windows/Linux desktop nếu cần
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'btvn_buoi9_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 1. Bảng quản lý chi tiêu cá nhân (Bài tập 1 về nhà)
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            note TEXT,
            date TEXT NOT NULL,
            category TEXT NOT NULL
          )
        ''');

        // 2. Bảng quản lý tài khoản người dùng đăng nhập/đăng ký (Bài tập 2 về nhà)
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            createdAt TEXT
          )
        ''');

        // Chèn dữ liệu mẫu cho Chi tiêu cá nhân
        await db.insert('expenses', {
          'title': 'Ăn trưa cơm tấm sườn',
          'amount': 45000.0,
          'note': 'Quán Cơm Tấm gần trường',
          'date': '2026-10-21',
          'category': 'Ăn uống',
        });
        await db.insert('expenses', {
          'title': 'Đổ xăng xe máy',
          'amount': 90000.0,
          'note': 'Đầy bình xăng xe Wave',
          'date': '2026-10-21',
          'category': 'Đi lại',
        });
        await db.insert('expenses', {
          'title': 'Tiền phòng trọ tháng 10',
          'amount': 2500000.0,
          'note': 'Chuyển khoản tiền phòng trọ và điện nước',
          'date': '2026-10-05',
          'category': 'Nhà ở',
        });
        await db.insert('expenses', {
          'title': 'Mua giáo trình SQLite Flutter',
          'amount': 180000.0,
          'note': 'Tài liệu học tập Lập trình di động',
          'date': '2026-10-18',
          'category': 'Học tập',
        });
        await db.insert('expenses', {
          'title': 'Cà phê học nhóm',
          'amount': 55000.0,
          'note': 'Highlands Coffee cùng nhóm đồ án',
          'date': '2026-10-20',
          'category': 'Giải trí',
        });

        // Chèn tài khoản mẫu ban đầu cho Bài tập 2
        await db.insert('users', {
          'email': 'dongluong@gmail.com',
          'password': 'password123',
          'createdAt': DateTime.now().toIso8601String(),
        });
        await db.insert('users', {
          'email': 'admin@gmail.com',
          'password': 'admin',
          'createdAt': DateTime.now().toIso8601String(),
        });
      },
    );
  }
}
