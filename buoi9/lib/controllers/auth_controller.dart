import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../utils/database_helper.dart';

class AuthResult {
  final bool success;
  final String message;
  final AppUser? user;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
  });
}

class AuthController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // 1. Đăng ký tài khoản mới (Register)
  Future<AuthResult> register(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return AuthResult(
        success: false,
        message: 'Vui lòng nhập đầy đủ Email và Password!',
      );
    }

    if (!cleanEmail.contains('@') || !cleanEmail.contains('.')) {
      return AuthResult(
        success: false,
        message: 'Địa chỉ Email không đúng định dạng!',
      );
    }

    if (cleanPassword.length < 4) {
      return AuthResult(
        success: false,
        message: 'Mật khẩu phải có ít nhất 4 ký tự!',
      );
    }

    final db = await _dbHelper.database;

    // Kiểm tra xem email đã tồn tại hay chưa
    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [cleanEmail],
    );

    if (existing.isNotEmpty) {
      return AuthResult(
        success: false,
        message: 'Email này đã được đăng ký trong hệ thống!',
      );
    }

    // Thêm người dùng mới vào SQLite
    final newUser = AppUser(
      email: cleanEmail,
      password: cleanPassword,
      createdAt: DateTime.now().toIso8601String(),
    );

    final id = await db.insert(
      'users',
      newUser.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    final registeredUser = AppUser(
      id: id,
      email: cleanEmail,
      password: cleanPassword,
      createdAt: newUser.createdAt,
    );

    return AuthResult(
      success: true,
      message: 'Đăng ký tài khoản thành công! Bạn có thể Sign in ngay bây giờ.',
      user: registeredUser,
    );
  }

  // 2. Đăng nhập hệ thống (Sign in)
  Future<AuthResult> login(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return AuthResult(
        success: false,
        message: 'Vui lòng điền Email và Password!',
      );
    }

    final db = await _dbHelper.database;

    // Truy vấn kiểm tra email và password trong SQLite
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [cleanEmail, cleanPassword],
    );

    if (maps.isNotEmpty) {
      final user = AppUser.fromMap(maps.first);
      return AuthResult(
        success: true,
        message: 'Đăng nhập thành công! Chào mừng ${user.email}.',
        user: user,
      );
    } else {
      // Kiểm tra xem do sai mật khẩu hay email không tồn tại
      final checkEmail = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [cleanEmail],
      );

      if (checkEmail.isEmpty) {
        return AuthResult(
          success: false,
          message: 'Tài khoản không tồn tại! Vui lòng chọn Register để đăng ký.',
        );
      } else {
        return AuthResult(
          success: false,
          message: 'Mật khẩu không chính xác! Vui lòng kiểm tra lại.',
        );
      }
    }
  }

  // 3. Lấy danh sách toàn bộ người dùng trong CSDL (dùng để kiểm chứng CSDL)
  Future<List<AppUser>> getAllUsers() async {
    final db = await _dbHelper.database;
    final maps = await db.query('users', orderBy: 'id DESC');
    return maps.map((item) => AppUser.fromMap(item)).toList();
  }
}
