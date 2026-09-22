import 'package:flutter/material.dart';

class PhoneMockupWidget extends StatelessWidget {
  final String productId;
  final String name;
  final double height;

  const PhoneMockupWidget({
    super.key,
    required this.productId,
    required this.name,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    // Determine phone style based on product ID
    final bool isPhone1 = productId == 'p1';
    final Color frameColor = isPhone1
        ? const Color(0xFF1E1E2C)
        : const Color(0xFF00796B);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: frameColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Wallpaper Gradient Screen
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isPhone1
                      ? [
                          const Color(0xFF1A1C2E),
                          const Color(0xFF3B285E),
                          const Color(0xFF6B429A),
                          const Color(0xFFB171D7),
                        ]
                      : [
                          const Color(0xFF004D40),
                          const Color(0xFF00897B),
                          const Color(0xFF4DB6AC),
                          const Color(0xFF80CBC4),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Top Status Bar (Time 8:20 & Battery/Signal)
            Positioned(
              top: 6,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '8:20',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.wifi,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.battery_full,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Punch hole camera top center
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Screen graphics / abstract wallpaper wave
            Positioned(
              top: height * 0.35,
              left: 16,
              right: 16,
              child: Container(
                height: height * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom App Icons Grid Mockup
            Positioned(
              bottom: 8,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniAppIcon(Colors.redAccent, Icons.call),
                  _buildMiniAppIcon(Colors.greenAccent.shade700, Icons.message),
                  _buildMiniAppIcon(Colors.blueAccent, Icons.camera_alt),
                  _buildMiniAppIcon(Colors.orangeAccent, Icons.public),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniAppIcon(Color color, IconData icon) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, color: Colors.white, size: 9),
    );
  }
}
