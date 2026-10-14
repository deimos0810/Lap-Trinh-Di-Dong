import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/daily_task.dart';

class DailyTaskFileService {
  // Bộ nhớ đệm dành cho Web
  static final List<DailyTask> _webStorage = [];

  Future<String> get _path async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _file async {
    final path = await _path;
    return File('$path/daily_tasks.txt');
  }

  static final List<DailyTask> _defaultTasks = [
    DailyTask(id: 101, title: 'Học bài chương 4', reminderTime: '20:00', isCompleted: false),
    DailyTask(id: 102, title: 'Làm bài tập Flutter Notification', reminderTime: '21:00', isCompleted: false),
    DailyTask(id: 103, title: 'Đọc tài liệu State Management', reminderTime: '22:00', isCompleted: false),
  ];

  Future<List<DailyTask>> loadTasks() async {
    if (kIsWeb) {
      if (_webStorage.isEmpty) {
        _webStorage.addAll(_defaultTasks);
      }
      return List.from(_webStorage);
    }

    try {
      final file = await _file;
      if (!await file.exists()) {
        await saveTasks(_defaultTasks);
        return List.from(_defaultTasks);
      }
      final content = await file.readAsString();
      final lines = content
          .split("\n")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (lines.isEmpty) {
        await saveTasks(_defaultTasks);
        return List.from(_defaultTasks);
      }

      return lines.map((e) => DailyTask.fromString(e)).toList();
    } catch (e) {
      debugPrint("Error loading tasks: $e");
      return List.from(_defaultTasks);
    }
  }

  Future<void> saveTasks(List<DailyTask> tasks) async {
    if (kIsWeb) {
      _webStorage.clear();
      _webStorage.addAll(tasks);
      return;
    }

    try {
      final file = await _file;
      final data = tasks.map((e) => e.toFileString()).join("\n");
      await file.writeAsString(data);
    } catch (e) {
      debugPrint("Error saving tasks: $e");
    }
  }

  Future<void> addTask(DailyTask task) async {
    final tasks = await loadTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(DailyTask task) async {
    final tasks = await loadTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(int id) async {
    final tasks = await loadTasks();
    tasks.removeWhere((t) => t.id == id);
    await saveTasks(tasks);
  }
}
