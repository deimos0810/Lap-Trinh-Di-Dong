class FavoriteRoute {
  final int? id;
  final String title;
  final String startAddress;
  final double startLat;
  final double startLng;
  final String endAddress;
  final double endLat;
  final double endLng;
  final String travelMode;
  final String distanceText;
  final String durationText;
  final String createdAt;

  FavoriteRoute({
    this.id,
    required this.title,
    required this.startAddress,
    required this.startLat,
    required this.startLng,
    required this.endAddress,
    required this.endLat,
    required this.endLng,
    required this.travelMode,
    required this.distanceText,
    required this.durationText,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startAddress': startAddress,
      'startLat': startLat,
      'startLng': startLng,
      'endAddress': endAddress,
      'endLat': endLat,
      'endLng': endLng,
      'travelMode': travelMode,
      'distanceText': distanceText,
      'durationText': durationText,
      'createdAt': createdAt,
    };
  }

  factory FavoriteRoute.fromMap(Map<String, dynamic> map) {
    return FavoriteRoute(
      id: map['id'] as int?,
      title: map['title'] ?? '',
      startAddress: map['startAddress'] ?? '',
      startLat: (map['startLat'] as num).toDouble(),
      startLng: (map['startLng'] as num).toDouble(),
      endAddress: map['endAddress'] ?? '',
      endLat: (map['endLat'] as num).toDouble(),
      endLng: (map['endLng'] as num).toDouble(),
      travelMode: map['travelMode'] ?? 'driving',
      distanceText: map['distanceText'] ?? '',
      durationText: map['durationText'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }
}
