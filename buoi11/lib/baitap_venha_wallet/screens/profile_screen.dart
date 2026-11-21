import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../services/wallet_service.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onBack;
  const ProfileScreen({super.key, required this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _walletService = WalletService();
  final _nameCtrl = TextEditingController();
  File? _avatarFile;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Quản lý Profile"),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _walletService.streamUserProfile(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final displayName = data?['displayName'] ?? _walletService.currentUser?.displayName ?? 'Chưa đặt tên';
          final email = data?['email'] ?? _walletService.currentUser?.email ?? '';
          final avatarUrl = data?['avatarUrl'] ?? _walletService.currentUser?.photoURL;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _avatarFile != null
                            ? FileImage(_avatarFile!)
                            : (avatarUrl != null && avatarUrl.isNotEmpty
                                ? (avatarUrl.startsWith('base64:')
                                    ? MemoryImage(base64Decode(avatarUrl.replaceFirst('base64:', '')))
                                    : NetworkImage(avatarUrl) as ImageProvider)
                                : null),
                        child: (_avatarFile == null && (avatarUrl == null || avatarUrl.isEmpty))
                            ? const Icon(Icons.person, size: 54, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () async {
                            final picker = ImagePicker();
                            final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                            if (img != null) {
                              setState(() => _avatarFile = File(img.path));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Color(0xFF4C35DE), shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                TextField(
                  controller: _nameCtrl..text = displayName,
                  decoration: InputDecoration(
                    labelText: "Họ và tên",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C35DE)),
                    onPressed: _isSaving
                        ? null
                        : () async {
                            setState(() => _isSaving = true);
                            try {
                              await _walletService.updateProfile(
                                displayName: _nameCtrl.text.trim(),
                                avatarFile: _avatarFile,
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Cập nhật Profile thành công!")),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
                              }
                            } finally {
                              if (mounted) setState(() => _isSaving = false);
                            }
                          },
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Lưu thay đổi", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    widget.onBack();
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
