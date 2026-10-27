import 'package:flutter/material.dart';
import '../models/hoa_don.dart';
import '../services/api_service.dart';
import '../widgets/app_drawer.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<HoaDon> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    final orders = await ApiService.getLichSuHoaDon();
    setState(() {
      _orders = orders;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      drawer: const AppDrawer(currentRoute: 'history'),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0A500),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text(
          'Lịch sử hóa đơn (SQL Server)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _fetchOrders,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFF0A500)),
            )
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 70, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        'Chưa có hóa đơn nào được lưu trong CSDL.',
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final hd = _orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber.shade100,
                          child: const Icon(Icons.receipt, color: Color(0xFFF0A500)),
                        ),
                        title: Text(
                          hd.maHD,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Text(
                          'Ngày: ${hd.ngayLap.toString().substring(0, 16)} • ${hd.trangThai}',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                        ),
                        trailing: Text(
                          '${hd.tongTien.toStringAsFixed(1)} đ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.redAccent,
                          ),
                        ),
                        children: [
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Chi tiết sản phẩm đã mua:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 6),
                                if (hd.chiTiets.isEmpty)
                                  const Text('Dữ liệu chi tiết đơn hàng.')
                                else
                                  ...hd.chiTiets.map(
                                    (ct) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '• ${ct.tenDT.isNotEmpty ? ct.tenDT : ct.maDT} (x${ct.soLuong})',
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                          Text(
                                            '${ct.thanhTien.toStringAsFixed(1)} đ',
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
