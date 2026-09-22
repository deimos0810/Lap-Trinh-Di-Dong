import 'package:flutter/material.dart';

class Bai3Screen extends StatefulWidget {
  const Bai3Screen({super.key});

  @override
  State<Bai3Screen> createState() => _Bai3ScreenState();
}

class _Bai3ScreenState extends State<Bai3Screen> {
  int _selectedFilterIndex = 0;
  final Set<int> _favoritedItems = {1}; // Default favorited item 2

  final List<String> _filters = [
    'Sắp xếp ▾',
    'Dịch vụ ▾',
    'Gần tôi',
    'Yêu thích',
  ];

  final List<Map<String, dynamic>> _vouchers = [
    {
      'id': 0,
      'provider': 'CGV',
      'logoColor': const Color(0xFFE53935),
      'icon': Icons.movie,
      'title': 'CGV -',
      'description': 'Đồng giá 79K khi mua vé CGV 2D trên M...',
      'hsd': 'HSD: 28/02/2025',
      'badge': null,
      'buttonText': 'Dùng ngay',
      'buttonAction': 'use',
    },
    {
      'id': 1,
      'provider': 'Mua Sim\nchính chủ',
      'logoColor': const Color(0xFFEC407A),
      'icon': Icons.sim_card,
      'title': 'Giảm 100K',
      'description': 'Cho đơn từ 0đ',
      'hsd': 'HSD: 28/02/2025',
      'badge': null,
      'buttonText': 'Dùng ngay',
      'buttonAction': 'use',
    },
    {
      'id': 2,
      'provider': 'Ngân hàng\nQuốc Tế VIB',
      'logoColor': const Color(0xFF1E88E5),
      'icon': Icons.account_balance,
      'title': 'Tặng 100k',
      'description': 'Khi mở thẻ VIB Online Plus 2in1 (*)',
      'hsd': 'HSD: 31/03/2025',
      'badge': 'Quà hiện vật',
      'buttonText': 'Dùng ngay',
      'buttonAction': 'use',
    },
    {
      'id': 3,
      'provider': 'Thanh toán\nbảo hiểm',
      'logoColor': const Color(0xFF0288D1),
      'icon': Icons.umbrella,
      'title': 'Hoàn 15K',
      'description': 'Cho hóa đơn từ 3.000.000đ',
      'hsd': 'Hết hạn sau 5 ngày',
      'isExpiring': true,
      'badge': null,
      'buttonText': 'Dùng ngay',
      'buttonAction': 'use',
    },
    {
      'id': 4,
      'provider': 'Phí không\ndừng',
      'logoColor': const Color(0xFFF57C00),
      'icon': Icons.toll,
      'title': 'Giảm 10K',
      'description': 'Cho đơn từ 100K',
      'hsd': null,
      'badge': null,
      'buttonText': 'Thu thập',
      'buttonAction': 'collect',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          'Quà của Vinh (7)',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Header background continuation with filters
          Container(
            color: const Color(0xFFFCE4EC),
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFA50064) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFA50064) : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        _filters[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Two Header Status Cards
                  Row(
                    children: [
                      // Left Card: Xu Status
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFB300),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    'm',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Đang có',
                                      style: TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                    Text(
                                      '1.955 Xu',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Colors.orange, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Right Card: Blue Gifts Banner
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.card_giftcard, color: Colors.yellowAccent, size: 26),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Bỏ túi ngay\n4 thẻ quà',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.white24,
                                child: Icon(Icons.chevron_right, color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Voucher List
                  ..._vouchers.map((voucher) => _buildVoucherCard(voucher)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(Map<String, dynamic> voucher) {
    final int id = voucher['id'] as int;
    final bool isFav = _favoritedItems.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider Box
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        voucher['icon'] as IconData,
                        color: voucher['logoColor'] as Color,
                        size: 30,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        voucher['provider'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Voucher Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 28),
                        child: Text(
                          voucher['title'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        voucher['description'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      if (voucher['badge'] != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            voucher['badge'] as String,
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                      ],
                      if (voucher['hsd'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          voucher['hsd'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: voucher['isExpiring'] == true ? Colors.red : Colors.grey.shade600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: voucher['buttonAction'] == 'use'
                            ? OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFA50064)),
                                  foregroundColor: const Color(0xFFA50064),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  voucher['buttonText'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey.shade400),
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  voucher['buttonText'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top right heart icon
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? const Color(0xFFA50064) : Colors.grey,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  if (isFav) {
                    _favoritedItems.remove(id);
                  } else {
                    _favoritedItems.add(id);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
