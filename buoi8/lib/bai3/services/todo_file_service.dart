import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/todo_reminder.dart';

class TodoFileService {
  // Bộ nhớ đệm dành cho Web (do Web không hỗ trợ dart:io File)
  static final List<TodoReminder> _webStorage = [];

  Future<String> get _path async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _file async {
    final path = await _path;
    return File('$path/todo.txt');
  }

  Future<void> saveTodos(List<TodoReminder> todos) async {
    if (kIsWeb) {
      _webStorage.clear();
      _webStorage.addAll(todos);
      return;
    }

    try {
      final file = await _file;
      String data = todos.map((e) => e.toFileString()).join("\n");
      await file.writeAsString(data);
    } catch (e) {
      debugPrint("Error writing todo.txt: $e");
    }
  }

  // Đọc dữ liệu từ file và trả về danh sách Todo
  Future<List<TodoReminder>> loadTodos() async {
    if (kIsWeb) {
      return List.from(_webStorage);
    }

    try {
      final file = await _file;
      if (!await file.exists()) {
        return [];
      }
      final content = await file.readAsString();
      return content
          .split("\n")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map((e) => TodoReminder.fromString(e))
          .toList();
    } catch (e) {
      debugPrint("Error loading todo.txt: $e");
      return [];
    }
  }
}
