import 'package:flutter/material.dart';
import '../widgets/huit_logo_widget.dart';

class IntroScreen extends StatelessWidget {
  final VoidCallback onStartApp;

  const IntroScreen({
    super.key,
    required this.onStartApp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Logo Image (assets/images/logo.png)
            Center(
              child: SizedBox(
                width: 140,
                height: 140,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const HuitLogoWidget(size: 140);
                  },
                ),
              ),
            ),

            const SizedBox(height: 36),

            // Title
            const Text(
              'Cửa hàng điện thoại',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            // Address Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '140 Lê Trọng Tấn, Tân Phú, TP.Hồ Chí Minh',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),

            const Spacer(flex: 3),

            // Arrow circle button -> Start app
            GestureDetector(
              onTap: onStartApp,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.grey,
                  size: 26,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
