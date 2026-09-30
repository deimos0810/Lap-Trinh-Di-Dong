import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';

class Bai5AddContactScreen extends StatefulWidget {
  const Bai5AddContactScreen({super.key});

  @override
  State<Bai5AddContactScreen> createState() => _Bai5AddContactScreenState();
}

class _Bai5AddContactScreenState extends State<Bai5AddContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _avatar;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _avatar = File(pickedFile.path));
    }
  }

  Future<void> _saveContact() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tên và SĐT không được để trống!')));
      return;
    }

    final newContact = Contact()
      ..name.first = _nameController.text.trim()
      ..phones = [Phone(_phoneController.text.trim())]
      ..emails = _emailController.text.isNotEmpty ? [Email(_emailController.text.trim())] : [];

    if (_avatar != null) {
      newContact.photo = await _avatar!.readAsBytes();
    }

    try {
      await newContact.insert();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm danh bạ thành công!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm danh bạ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: CircleAvatar(
                radius: 45,
                backgroundImage: _avatar != null ? FileImage(_avatar!) : null,
                child: _avatar == null ? const Icon(Icons.camera_alt, size: 35) : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Tên', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Số điện thoại', border: OutlineInputBorder()), keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveContact, child: const Text('Lưu Danh Bạ')),
          ],
        ),
      ),
    );
  }
}