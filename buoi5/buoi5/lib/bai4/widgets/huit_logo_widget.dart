import 'package:flutter/material.dart';

class HuitLogoWidget extends StatelessWidget {
  final double size;
  final String? imagePath;

  const HuitLogoWidget({
    super.key,
    this.size = 140,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF0F4C81), width: size * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: CustomPaint(
          size: Size(size, size),
          painter: _HuitLogoPainter(),
          child: Container(),
        ),
      ),
    );
  }
}

class _HuitLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final bgPaint = Paint()..color = const Color(0xFF0F4C81);
    canvas.drawCircle(center, radius, bgPaint);

    // Inner white circle
    final innerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03;
    canvas.drawCircle(center, radius * 0.88, innerCirclePaint);

    // Yellow arc banner text top
    final textPainter1 = TextPainter(
      text: const TextSpan(
        text: 'TRƯỜNG ĐẠI HỌC CÔNG THƯƠNG',
        style: TextStyle(
          color: Color(0xFFFFD54F),
          fontSize: 6.5,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter1.layout();
    textPainter1.paint(
      canvas,
      Offset(center.dx - textPainter1.width / 2, size.height * 0.18),
    );

    final textPainter2 = TextPainter(
      text: const TextSpan(
        text: 'TP. HỒ CHÍ MINH',
        style: TextStyle(
          color: Colors.white,
          fontSize: 6.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter2.layout();
    textPainter2.paint(
      canvas,
      Offset(center.dx - textPainter2.width / 2, size.height * 0.26),
    );

    // Center emblem symbol (Book & Gears)
    final emblemPaint = Paint()
      ..color = const Color(0xFF1E88E5)
      ..style = PaintingStyle.fill;

    final emblemPath = Path();
    final emW = size.width * 0.4;
    final emH = size.height * 0.3;
    final left = center.dx - emW / 2;
    final top = center.dy - emH / 2.5;

    // Draw stylized open book / gear icon
    emblemPath.moveTo(left, top + emH * 0.3);
    emblemPath.lineTo(center.dx, top);
    emblemPath.lineTo(left + emW, top + emH * 0.3);
    emblemPath.lineTo(left + emW, top + emH * 0.8);
    emblemPath.lineTo(center.dx, top + emH * 0.5);
    emblemPath.lineTo(left, top + emH * 0.8);
    emblemPath.close();

    canvas.drawPath(emblemPath, emblemPaint);

    // Inner book accent lines
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx, top),
      Offset(center.dx, top + emH * 0.5),
      linePaint,
    );

    // Red HUIT badge at bottom
    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.76),
        width: size.width * 0.36,
        height: size.height * 0.16,
      ),
      const Radius.circular(4),
    );
    final badgePaint = Paint()..color = const Color(0xFFD32F2F);
    canvas.drawRRect(badgeRect, badgePaint);

    final huitText = TextPainter(
      text: const TextSpan(
        text: 'HUIT',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    huitText.layout();
    huitText.paint(
      canvas,
      Offset(center.dx - huitText.width / 2, size.height * 0.71),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
