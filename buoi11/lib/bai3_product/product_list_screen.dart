import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    _seedDefaultProductsIfEmpty();
  }

  // Khởi tạo 5 mẫu xe đạp giống hệt trong slide nếu Firestore chưa có dữ liệu
  Future<void> _seedDefaultProductsIfEmpty() async {
    try {
      final snap = await FirebaseFirestore.instance.collection('products').limit(1).get();
      if (snap.docs.isEmpty) {
        final sampleProducts = [
          {"name": "Instinct", "price": 6999.99, "imageUrl": "https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=300"},
          {"name": "Stumpjumper", "price": 3178.99, "imageUrl": "https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?w=300"},
          {"name": "Trek Fuel", "price": 4999.99, "imageUrl": "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=300"},
          {"name": "Devinci Troy", "price": 5599.00, "imageUrl": "https://images.unsplash.com/photo-1576435728678-68d0fbf94e91?w=300"},
          {"name": "Slayer", "price": 4699.99, "imageUrl": "https://images.unsplash.com/photo-1502744688674-c619d1586c9e?w=300"},
          {"name": "Trek Slash 8", "price": 6999.99, "imageUrl": "https://images.unsplash.com/photo-1511994298241-608e28f14fde?w=300"},
        ];
        for (var p in sampleProducts) {
          await FirebaseFirestore.instance.collection('products').add({
            'name': p['name'],
            'price': p['price'],
            'imageUrl': p['imageUrl'],
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (_) {}
  }

  void _showAddProductModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    File? selectedImage;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),
              const Text("Thêm Sản Phẩm Mới", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70, maxWidth: 600);
                  if (picked != null) {
                    setModalState(() => selectedImage = File(picked.path));
                  }
                },
                child: Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.blue),
                            SizedBox(height: 6),
                            Text("Nhấn để chọn hình ảnh sản phẩm", style: TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "Tên sản phẩm",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Giá sản phẩm (\$)",
                  prefixText: "\$ ",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B46C1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                          final name = nameCtrl.text.trim();
                          final priceStr = priceCtrl.text.trim();
                          if (name.isEmpty || priceStr.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Vui lòng điền đủ tên và giá")),
                            );
                            return;
                          }

                          setModalState(() => isSaving = true);
                          try {
                            String imageUrl = "https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=300";

                            // Tải ảnh lên Firebase Storage nếu có, nếu chưa mở thẻ thì chuyển thành Base64 lưu trực tiếp vào Firestore
                            if (selectedImage != null) {
                              try {
                                final ref = FirebaseStorage.instance
                                    .ref()
                                    .child('products/${DateTime.now().millisecondsSinceEpoch}.jpg');
                                await ref.putFile(selectedImage!);
                                imageUrl = await ref.getDownloadURL();
                              } catch (_) {
                                // Fallback Base64 (hoạt động 100% không cần Storage Blaze)
                                final bytes = await selectedImage!.readAsBytes();
                                imageUrl = "base64:${base64Encode(bytes)}";
                              }
                            }

                            // Lưu vào Firestore
                            await FirebaseFirestore.instance.collection('products').add({
                              'name': name,
                              'price': double.tryParse(priceStr) ?? 0.0,
                              'imageUrl': imageUrl,
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                            if (ctx.mounted) Navigator.pop(ctx);
                          } catch (e) {
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
                            }
                          } finally {
                            if (ctx.mounted) setModalState(() => isSaving = false);
                          }
                        },
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Lưu sản phẩm", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(String? url) {
    if (url == null || url.isEmpty) {
      return const Icon(Icons.pedal_bike, size: 36, color: Colors.purple);
    }
    if (url.startsWith('base64:')) {
      final base64String = url.replaceFirst('base64:', '');
      return Image.memory(base64Decode(base64String), fit: BoxFit.cover);
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(Icons.pedal_bike, size: 36, color: Colors.purple),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Products"),
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        onPressed: () => _showAddProductModal(context),
        icon: const Icon(Icons.add),
        label: const Text("Thêm sản phẩm"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi kết nối Firestore: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text("Chưa có sản phẩm nào. Hãy bấm Thêm sản phẩm!", style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final price = (data['price'] as num?)?.toDouble() ?? 0.0;

              return Card(
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildProductImage(data['imageUrl']),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'] ?? 'Không tên',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${price.toStringAsFixed(2)}",
                              style: const TextStyle(color: Color(0xFF6B46C1), fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Xác nhận xóa"),
                              content: Text("Bạn có muốn xóa '${data['name']}' không?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Hủy")),
                                TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Xóa", style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await FirebaseFirestore.instance.collection('products').doc(doc.id).delete();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
