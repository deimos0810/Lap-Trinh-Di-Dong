import 'package:flutter/material.dart';

class Bai1Screen extends StatefulWidget {
  const Bai1Screen({super.key});

  @override
  State<Bai1Screen> createState() => _Bai1ScreenState();
}

class _Bai1ScreenState extends State<Bai1Screen> {
  int selectedCategoryIndex = 0;
  int? selectedMajorIndex;

  final List<String> categories = [
    'Đồ án',
    'KLKS',
    'Luận văn',
    'Khác',
  ];

  final List<Map<String, String>> majors = [
    {
      'title': 'Công nghệ phần mềm',
      'subtitle': 'Phát triển các ứng dụng giải quyết các vấn đề thực tế',
    },
    {
      'title': 'Hệ thống thông tin',
      'subtitle': 'Phát triển các kỹ thuật xử lý thông tin trong tổ chức',
    },
    {
      'title': 'Mạng máy tính',
      'subtitle': 'Xử lý các vấn đề liên quan đến mạng máy tính',
    },
    {
      'title': 'An toàn thông tin',
      'subtitle': 'Thiết kế và đảm bảo an toàn cho hệ thống máy tính',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF59E0B),
        elevation: 0,
        leading: const Icon(Icons.home, color: Colors.black87),
        title: const Text(
          'ListView Demo',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section 1: Chọn loại đề tài
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF0088CC),
            child: const Text(
              'Chọn loại đề tài',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          
          // Horizontal list of categories
          Container(
            height: 120,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? const Color(0xFF6B21A8) : const Color(0xFF7C3AED),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: isSelected
                                ? Border.all(color: Colors.orange, width: 3)
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            categories[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Header Section 2: Chọn chuyên ngành thực hiện
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF0088CC),
            child: const Text(
              'Chọn chuyên ngành thực hiện',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          // Vertical list of majors
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: majors.length,
              itemBuilder: (context, index) {
                final major = majors[index];
                final isSelected = selectedMajorIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMajorIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFDCDCCA) : const Color(0xFFE5E5DC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.deepOrange : Colors.grey.shade600,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.home,
                          size: 28,
                          color: Color(0xFF4A4A4A),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                major['title']!,
                                style: const TextStyle(
                                  color: Color(0xFFE53935),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                major['subtitle']!,
                                style: const TextStyle(
                                  color: Color(0xFF4A4A4A),
                                  fontSize: 12,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF4A4A4A),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
