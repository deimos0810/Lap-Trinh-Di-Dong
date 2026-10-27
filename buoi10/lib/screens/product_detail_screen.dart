import 'package:flutter/material.dart';
import '../models/dien_thoai.dart';
import '../services/cart_manager.dart';

class ProductDetailScreen extends StatelessWidget {
  final DienThoai dienThoai;

  const ProductDetailScreen({super.key, required this.dienThoai});

  void _showAddConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn vừa thêm sản phẩm vào Giỏ hàng'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Không', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B4D8),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              CartManager.instance.addItem(dienThoai);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã thêm "${dienThoai.tenDT}" vào giỏ hàng!'),
                  backgroundColor: Colors.green.shade700,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0A500),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'THÔNG TIN SẢN PHẨM',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên điện thoại
            Text(
              'Tên: ${dienThoai.tenDT}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Hình ảnh sản phẩm
            Center(
              child: Container(
                height: 280,
                width: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: dienThoai.hinhAnh != null && dienThoai.hinhAnh!.isNotEmpty
                    ? Image.network(
                        dienThoai.hinhAnh!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const Center(
                          child: Icon(Icons.phone_android, size: 80, color: Colors.grey),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.phone_android, size: 80, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Giá sản phẩm
            Text(
              'Giá: ${dienThoai.gia.toStringAsFixed(1)} đ',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16),

            // Mô tả
            const Text(
              'Mô tả',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dienThoai.moTa.isNotEmpty
                  ? dienThoai.moTa
                  : 'Sản phẩm chính hãng với thiết kế hiện đại, cấu hình mạnh mẽ đáp ứng tối đa nhu cầu của người dùng.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),

            // Nút Thêm vào giỏ hàng
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B4D8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () => _showAddConfirmDialog(context),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(
                  'Thêm vào giỏ hàng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
