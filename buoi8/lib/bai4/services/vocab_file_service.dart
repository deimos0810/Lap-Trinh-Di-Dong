import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/vocab_item.dart';

class VocabFileService {
  // Bộ nhớ đệm dành cho Web
  static final List<VocabItem> _webStorage = [];

  Future<String> get _path async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _file async {
    final path = await _path;
    return File('$path/vocabularies.txt');
  }

  // Khởi tạo các từ mặc định nếu file chưa có dữ liệu
  static final List<VocabItem> _defaultWords = [
    VocabItem(id: 1, word: 'subject', meaning: 'môn học', createdAt: DateTime.now()),
    VocabItem(id: 2, word: 'student', meaning: 'sinh viên', createdAt: DateTime.now()),
    VocabItem(id: 3, word: 'teacher', meaning: 'giáo viên', createdAt: DateTime.now()),
    VocabItem(id: 4, word: 'computer', meaning: 'máy tính', createdAt: DateTime.now()),
    VocabItem(id: 5, word: 'mobile', meaning: 'di động', createdAt: DateTime.now()),
    VocabItem(id: 6, word: 'library', meaning: 'thư viện', createdAt: DateTime.now()),
    VocabItem(id: 7, word: 'developer', meaning: 'lập trình viên', createdAt: DateTime.now()),
    VocabItem(id: 8, word: 'database', meaning: 'cơ sở dữ liệu', createdAt: DateTime.now()),
  ];

  Future<List<VocabItem>> loadVocabularies() async {
    if (kIsWeb) {
      if (_webStorage.isEmpty) {
        _webStorage.addAll(_defaultWords);
      }
      return List.from(_webStorage);
    }

    try {
      final file = await _file;
      if (!await file.exists()) {
        await saveVocabularies(_defaultWords);
        return List.from(_defaultWords);
      }
      final content = await file.readAsString();
      final lines = content
          .split("\n")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (lines.isEmpty) {
        await saveVocabularies(_defaultWords);
        return List.from(_defaultWords);
      }

      return lines.map((e) => VocabItem.fromString(e)).toList();
    } catch (e) {
      debugPrint("Error loading vocabularies: $e");
      return List.from(_defaultWords);
    }
  }

  Future<void> saveVocabularies(List<VocabItem> items) async {
    if (kIsWeb) {
      _webStorage.clear();
      _webStorage.addAll(items);
      return;
    }

    try {
      final file = await _file;
      final data = items.map((e) => e.toFileString()).join("\n");
      await file.writeAsString(data);
    } catch (e) {
      debugPrint("Error saving vocabularies: $e");
    }
  }

  Future<void> addVocabulary(VocabItem item) async {
    final list = await loadVocabularies();
    list.add(item);
    await saveVocabularies(list);
  }

  Future<void> deleteVocabulary(int id) async {
    final list = await loadVocabularies();
    list.removeWhere((element) => element.id == id);
    await saveVocabularies(list);
  }
}
