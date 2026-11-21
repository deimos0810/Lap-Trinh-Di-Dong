import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  Future<void> _submitAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showMessage("Vui lòng nhập email và mật khẩu");
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isSignUp) {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        _showMessage("Đăng ký tài khoản thành công!");
      } else {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _showMessage("Đăng nhập thành công!");
      }
    } on FirebaseAuthException catch (e) {
      _showMessage("Lỗi: ${e.message}");
    } catch (e) {
      _showMessage("Đã xảy ra lỗi: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred = await _auth.signInWithCredential(credential);
      _showMessage(
        "Đăng nhập Google thành công: ${userCred.user?.displayName}",
      );
    } catch (e) {
      _showMessage("Lỗi Google Sign-in: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Bài 1: Firebase Authentication"),
        backgroundColor: const Color(0xFFFD366E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFD366E).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_person,
                  size: 64,
                  color: Color(0xFFFD366E),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Appwrite / Firebase App",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                user != null
                    ? "Đang đăng nhập: ${user.email}"
                    : (_isSignUp ? "Tạo tài khoản mới" : "Đăng nhập hệ thống"),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFD366E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitAuth,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isSignUp ? "Sign Up" : "Sign In",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: Text(
                  _isSignUp
                      ? "Already have an account? Sign In"
                      : "Create Account",
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await _auth.signInAnonymously();
                  _showMessage("Đã đăng nhập vai trò Khách (Guest)!");
                },
                child: const Text(
                  "Read Messages as Guest",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Or continue with",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _signInWithGoogle,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.g_mobiledata,
                        size: 36,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () =>
                        _showMessage("Apple Sign-in khả dụng trên iOS"),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.apple,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              if (user != null) ...[
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "Đăng xuất tài khoản",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                    setState(() {});
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
