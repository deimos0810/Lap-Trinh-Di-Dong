import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/wallet_service.dart';
import 'dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _walletService = WalletService();
  bool _isLoading = false;

  void _showAuthBottomSheet(BuildContext context, bool isSignUp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isSignUp ? "Đăng ký ví ZhipPay" : "Đăng nhập ví ZhipPay",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mật khẩu", prefixIcon: Icon(Icons.lock)),
              ),
              if (!isSignUp)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      if (_emailCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Vui lòng nhập Email để đặt lại mật khẩu!")),
                        );
                        return;
                      }
                      await _walletService.sendPasswordReset(_emailCtrl.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đã gửi email khôi phục mật khẩu!")),
                      );
                    },
                    child: const Text("Quên mật khẩu?"),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C35DE),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final email = _emailCtrl.text.trim();
                          final pass = _passCtrl.text.trim();
                          if (email.isEmpty || pass.isEmpty) return;

                          setSheetState(() => _isLoading = true);
                          try {
                            if (isSignUp) {
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
                            } else {
                              await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
                            }
                            await _walletService.initUserDataIfNew();
                            if (ctx.mounted) Navigator.pop(ctx);
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
                          } finally {
                            if (ctx.mounted) setSheetState(() => _isLoading = false);
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isSignUp ? "Tạo tài khoản" : "Đăng nhập", style: const TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const Spacer(),
              // Thẻ mô phỏng card ví
              Container(
                width: 240,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5B36FE), Color(0xFF865BFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF5B36FE).withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Balance", style: TextStyle(color: Colors.white70, fontSize: 13)),
                    SizedBox(height: 8),
                    Text("\$4,5790.00", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("**** 8943", style: TextStyle(color: Colors.white70, letterSpacing: 2)),
                        Icon(Icons.contactless, color: Colors.white70),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Your next generation of\nfinancial platform",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
              ),
              const SizedBox(height: 12),
              const Text(
                "Simple user experience meets personal finance of the future backed by decentralized finance.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C35DE),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => _showAuthBottomSheet(context, true),
                  child: const Text("Sign up to zhippay", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _showAuthBottomSheet(context, false),
                child: const Text("Already have an account? Sign In", style: TextStyle(color: Color(0xFF4C35DE))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
