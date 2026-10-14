class VocabItem {
  final int id;
  final String word;
  final String meaning;
  final DateTime createdAt;

  VocabItem({
    required this.id,
    required this.word,
    required this.meaning,
    required this.createdAt,
  });

  String toFileString() {
    return "$id|$word|$meaning|${createdAt.toIso8601String()}";
  }

  static VocabItem fromString(String line) {
    final parts = line.split("|");
    if (parts.length >= 4) {
      return VocabItem(
        id: int.tryParse(parts[0]) ?? 0,
        word: parts[1],
        meaning: parts[2],
        createdAt: DateTime.tryParse(parts[3]) ?? DateTime.now(),
      );
    } else if (parts.length == 3) {
      return VocabItem(
        id: int.tryParse(parts[0]) ?? 0,
        word: parts[1],
        meaning: parts[2],
        createdAt: DateTime.now(),
      );
    } else if (parts.length == 2) {
      return VocabItem(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        word: parts[0],
        meaning: parts[1],
        createdAt: DateTime.now(),
      );
    }
    return VocabItem(
      id: 0,
      word: line,
      meaning: '',
      createdAt: DateTime.now(),
    );
  }
}
