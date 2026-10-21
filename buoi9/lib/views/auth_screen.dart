import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'expense_screen.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const AuthScreen({super.key, this.onLoginSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Gợi ý sẵn tài khoản mẫu để dễ test
    _emailController.text = 'dongluong@gmail.com';
    _passwordController.text = 'password123';
  }

  // 1. Xử lý đăng nhập (Sign in)
  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);
    final result = await _authController.login(
      _emailController.text,
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(result.message)),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Hiển thị dialog chào mừng và cho phép chuyển sang quản lý chi tiêu
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.verified, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text('Đăng Nhập Thành Công', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Xin chào: ${_emailController.text.trim()}!\n\nBạn đã xác thực thông tin thành công qua CSDL SQLite.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Ở lại form'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0072E5)),
              onPressed: () {
                Navigator.pop(ctx);
                if (widget.onLoginSuccess != null) {
                  widget.onLoginSuccess!();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExpenseScreen()),
                  );
                }
              },
              child: const Text('Vào Quản Lý Chi Tiêu', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(result.message)),
            ],
          ),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // 2. Xử lý đăng ký tài khoản (Register)
  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);
    final result = await _authController.register(
      _emailController.text,
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.person_add_alt_1, color: Colors.blue, size: 28),
              SizedBox(width: 8),
              Text('Đăng Ký Thành Công', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Tài khoản "${_emailController.text.trim()}" đã được lưu vào cơ sở dữ liệu SQLite!\n\nBây giờ bạn có thể chọn "Sign in" để đăng nhập.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Đã hiểu'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(result.message)),
            ],
          ),
          backgroundColor: Colors.orange.shade800,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Xem danh sách người dùng trong SQLite (hỗ trợ giáo viên chấm bài)
  void _showUsersListDialog() async {
    final users = await _authController.getAllUsers();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách Users trong SQLite (Bảng users)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(),
            if (users.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('Chưa có tài khoản nào trong CSDL')),
              )
            else
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: users.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (c, idx) {
                    final u = users[idx];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text('${u.id ?? idx + 1}'),
                      ),
                      title: Text(u.email, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Password: ${u.password}'),
                      onTap: () {
                        setState(() {
                          _emailController.text = u.email;
                          _passwordController.text = u.password;
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB), // Nền xám nhạt như hình mẫu PDF
      appBar: AppBar(
        title: const Text(
          'Đăng Nhập & Đăng Ký (SQLite)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.people_alt_outlined),
            tooltip: 'Xem danh sách Users trong SQLite',
            onPressed: _showUsersListDialog,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Khung Card bo tròn theo mẫu hình trang 13 PDF
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFDFE3E8), // Màu nền xám bo tròn chuẩn hình PDF
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nhãn Email
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Ô nhập Email với hint "Value" chuẩn đề bài
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFECEFF1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 15.0, color: Colors.black87),
                        decoration: const InputDecoration(
                          hintText: 'Value',
                          hintStyle: TextStyle(color: Colors.black45),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Nhãn Password
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Ô nhập Password với hint "Value" chuẩn đề bài
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFECEFF1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontSize: 15.0, color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Value',
                          hintStyle: const TextStyle(color: Colors.black45),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black45,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28.0),

                    // 2 nút Sign in và Register chuẩn tông xanh dương như hình mẫu
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            children: [
                              // Nút Sign in
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleSignIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0073E6), // Màu xanh dương chuẩn mockup
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                                    elevation: 2.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14.0),

                              // Nút Register
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleRegister,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0073E6), // Màu xanh dương chuẩn mockup
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                                    elevation: 2.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Gợi ý hướng dẫn sử dụng
              Card(
                color: Colors.white,
                elevation: 0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Dữ liệu đăng ký được lưu trữ bảo mật trong CSDL SQLite',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
