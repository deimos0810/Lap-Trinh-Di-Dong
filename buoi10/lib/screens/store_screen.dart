import 'package:flutter/material.dart';
import '../models/dien_thoai.dart';
import '../services/api_service.dart';
import '../services/cart_manager.dart';
import '../widgets/app_drawer.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<DienThoai> _allPhones = [];
  List<DienThoai> _featuredPhones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final all = await ApiService.getDienThoais();
      final featured = await ApiService.getDienThoaiNoiBat();
      if (mounted) {
        setState(() {
          _allPhones = all;
          _featuredPhones = featured.isNotEmpty
              ? featured
              : all.where((e) => e.noiBat).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _allPhones = ApiService.fallbackDienThoais;
          _featuredPhones = ApiService.fallbackDienThoais.where((e) => e.noiBat).toList();
          _isLoading = false;
        });
      }
    }
  }

  // Hộp thoại xác nhận thêm vào giỏ hàng đúng mẫu slide 22
  void _confirmAddToCart(DienThoai dt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xác nhận',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text(
          'Bạn vừa thêm sản phẩm vào Giỏ hàng',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Không',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B4D8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              CartManager.instance.addItem(dt);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã thêm "${dt.tenDT}" vào giỏ hàng!'),
                  backgroundColor: Colors.green.shade700,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Đồng ý', style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị mỗi thẻ điện thoại
  Widget _buildProductCard(DienThoai dt) {
    return Container(
      width: 175,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(dienThoai: dt),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh điện thoại
              Expanded(
                flex: 5,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: dt.hinhAnh != null && dt.hinhAnh!.isNotEmpty
                        ? Image.network(
                            dt.hinhAnh!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (ctx, err, stack) => Container(
                              color: Colors.grey.shade100,
                              child: const Icon(
                                Icons.phone_android,
                                size: 50,
                                color: Colors.blueGrey,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade100,
                            child: const Icon(
                              Icons.phone_android,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Tên sản phẩm
              Text(
                dt.tenDT,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 2),

              // Mô tả ngắn
              Expanded(
                flex: 2,
                child: Text(
                  dt.moTa,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    height: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Giá tiền và nút + tròn
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    dt.gia.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  InkWell(
                    onTap: () => _confirmAddToCart(dt),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00B4D8), // Nút tròn màu xanh ngọc
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
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
      backgroundColor: const Color(0xFFFAFAFA),
      drawer: const AppDrawer(currentRoute: 'store'),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0A500), // Màu cam vàng đúng hình slide
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text(
          'Cửa hàng điện thoại',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          // Nút giỏ hàng có badge hiển thị số lượng
          AnimatedBuilder(
            animation: CartManager.instance,
            builder: (context, _) {
              final count = CartManager.instance.itemCount;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.black87),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFF0A500)),
            )
          : RefreshIndicator(
              color: const Color(0xFFF0A500),
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mục 1: Chọn sản phẩm bạn muốn sử dụng
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      child: Text(
                        'Chọn sản phẩm bạn muốn sử dụng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),

                    // Danh sách cuộn ngang các sản phẩm
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: _allPhones.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(_allPhones[index]);
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Mục 2: Sản phẩm được lựa chọn nhiều nhất
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      child: Text(
                        'Sản phẩm được lựa chọn nhiều nhất',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),

                    // Danh sách cuộn ngang các sản phẩm nổi bật
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: _featuredPhones.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(_featuredPhones[index]);
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
