class DailyTask {
  final int id;
  String title;
  String reminderTime; // vi du: "20:00"
  bool isCompleted;

  DailyTask({
    required this.id,
    required this.title,
    required this.reminderTime,
    this.isCompleted = false,
  });

  String toFileString() {
    return "$id|$title|$reminderTime|${isCompleted ? '1' : '0'}";
  }

  static DailyTask fromString(String line) {
    final parts = line.split("|");
    if (parts.length >= 4) {
      return DailyTask(
        id: int.tryParse(parts[0]) ?? 0,
        title: parts[1],
        reminderTime: parts[2],
        isCompleted: parts[3] == '1',
      );
    } else if (parts.length == 3) {
      return DailyTask(
        id: int.tryParse(parts[0]) ?? 0,
        title: parts[1],
        reminderTime: parts[2],
        isCompleted: false,
      );
    } else if (parts.length == 2) {
      return DailyTask(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: parts[0],
        reminderTime: parts[1],
        isCompleted: false,
      );
    }
    return DailyTask(
      id: 0,
      title: line,
      reminderTime: '',
      isCompleted: false,
    );
  }
}
