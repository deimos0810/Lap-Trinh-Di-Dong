class TodoReminder {
  final int id;
  String title;
  DateTime time;

  TodoReminder({
    required this.id,
    required this.title,
    required this.time,
  });

  // Convert -> string de luu vao file
  String toFileString() {
    return "$id|$title|${time.toIso8601String()}";
  }

  // Parse <- string tu file
  static TodoReminder fromString(String line) {
    final parts = line.split("|");
    if (parts.length >= 3) {
      return TodoReminder(
        id: int.tryParse(parts[0]) ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: parts[1],
        time: DateTime.parse(parts[2]),
      );
    } else {
      // Tuong thich dinh dang cu title|isoString
      return TodoReminder(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: parts[0],
        time: DateTime.parse(parts[1]),
      );
    }
  }
}
