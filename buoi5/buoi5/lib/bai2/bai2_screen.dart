import 'package:flutter/material.dart';

class Bai2Screen extends StatefulWidget {
  const Bai2Screen({super.key});

  @override
  State<Bai2Screen> createState() => _Bai2ScreenState();
}

class _Bai2ScreenState extends State<Bai2Screen> {
  int _currentBottomNavIndex = 0;

  final List<Map<String, dynamic>> _mainServices = [
    {
      'title': 'Chuyển tiền',
      'icon': Icons.attach_money,
      'color': const Color(0xFFE53935),
    },
    {
      'title': 'Thanh toán\nhóa đơn',
      'icon': Icons.receipt_long,
      'color': const Color(0xFF00ACC1),
    },
    {
      'title': 'Nạp tiền điện\nthoại',
      'icon': Icons.phone_android,
      'color': const Color(0xFF1E88E5),
    },
    {
      'title': 'Mua mã thẻ di\nđộng',
      'icon': Icons.credit_card,
      'color': const Color(0xFFFB8C00),
    },
    {
      'title': 'Heo Đất MoMo',
      'icon': Icons.savings,
      'color': const Color(0xFFE91E63),
    },
    {
      'title': 'Đi bộ cùng\nMoMo',
      'icon': Icons.directions_walk,
      'color': const Color(0xFF4CAF50),
    },
    {
      'title': 'Thanh toán\nnước',
      'icon': Icons.water_drop,
      'color': const Color(0xFF03A9F4),
    },
    {
      'title': 'Quản lý chi\ntiêu',
      'icon': Icons.account_balance_wallet,
      'color': const Color(0xFF009688),
    },
    {
      'title': 'Quỹ nhóm',
      'icon': Icons.groups,
      'color': const Color(0xFFAB47BC),
    },
    {
      'title': 'Chứng Khoán',
      'icon': Icons.show_chart,
      'color': const Color(0xFFD81B60),
    },
    {
      'title': 'Vietlott SMS',
      'icon': Icons.confirmation_number,
      'color': const Color(0xFFE53935),
    },
    {
      'title': 'Xem thêm\ndịch vụ',
      'icon': Icons.grid_view,
      'color': const Color(0xFF78909C),
    },
  ];

  final List<Map<String, dynamic>> _recommendations = [
    {
      'title': 'Vay Nhanh',
      'icon': Icons.monetization_on,
      'color': Colors.amber,
    },
    {
      'title': 'Mua vé xem...',
      'icon': Icons.movie,
      'color': Colors.orangeAccent,
    },
    {
      'title': 'Túi Thần Tài',
      'icon': Icons.account_balance,
      'color': Colors.redAccent,
    },
    {
      'title': 'Ví Trả Sau',
      'icon': Icons.payment,
      'color': Colors.purpleAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA50064), // MoMo Signature Pink/Magenta
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'Tìm kiếm...',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Services Grid 4 columns
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _mainServices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final service = _mainServices[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (service['color'] as Color).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          service['icon'] as IconData,
                          color: service['color'] as Color,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.1,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Section: Sự kiện đang diễn ra
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sự kiện đang diễn ra',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF3C4), Color(0xFFFFD180), Color(0xFFFF80AB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          size: 48,
                          color: Color(0xFFA50064),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade800,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'LẮC XU',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Tích Lắc Lắc cộng nhiều\nThưởng cuối cùng lên Đến 50 triệu',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF5D4037),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFA50064),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'CHƠI NGAY',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Section: MoMo đề xuất
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MoMo đề xuất',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _recommendations.map((rec) {
                      return Column(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              rec['icon'] as IconData,
                              color: rec['color'] as Color,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            rec['title'] as String,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // AI Horoscope Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade200, Colors.yellow.shade100],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.shade400),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.deepOrange, size: 28),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2025 nhờ ai mà nở hoa?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          'Gieo quẻ với AI, tìm quý nhân của bạn',
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade900,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Gieo ngay', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Section: Có thể bạn quan tâm
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Có thể bạn quan tâm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, 'MoMo'),
            _buildNavItem(1, Icons.percent, 'Ưu đãi'),
            const SizedBox(width: 48), // Space for floating button
            _buildNavItem(2, Icons.history, 'Lịch sử GD'),
            _buildNavItem(3, Icons.person_outline, 'Tôi'),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFA50064),
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentBottomNavIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentBottomNavIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFA50064) : Colors.grey,
              size: 22,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFFA50064) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
