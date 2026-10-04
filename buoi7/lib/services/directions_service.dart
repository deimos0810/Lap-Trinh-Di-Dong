import 'dart:convert';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as geo;

class DirectionsResult {
  final List<LatLng> polylinePoints;
  final String distanceText;
  final String durationText;
  final double distanceValueMeters;
  final double durationValueSeconds;

  DirectionsResult({
    required this.polylinePoints,
    required this.distanceText,
    required this.durationText,
    required this.distanceValueMeters,
    required this.durationValueSeconds,
  });
}

class DirectionsService {
  static const String defaultApiKey = "AIzaSyB_ALUqcqvAsERy26jsTnyzZLnrs0ySzls";

  /// Giải mã chuỗi polyline mã hóa từ Google Directions API
  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  /// Gọi Directions API hoặc tự động sinh tuyến đường mô phỏng nếu chưa có API Key
  static Future<DirectionsResult?> getDirections({
    required LatLng origin,
    required LatLng destination,
    String mode = 'driving', // driving, walking, bicycling, transit
    String apiKey = defaultApiKey,
  }) async {
    if (apiKey != "YOUR_API_KEY_HERE" && apiKey.isNotEmpty) {
      try {
        final url = "https://maps.googleapis.com/maps/api/directions/json?"
            "origin=${origin.latitude},${origin.longitude}"
            "&destination=${destination.latitude},${destination.longitude}"
            "&mode=$mode"
            "&key=$apiKey";
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['routes'] != null && (data['routes'] as List).isNotEmpty) {
            final route = data['routes'][0];
            final leg = route['legs'][0];
            final points = decodePolyline(route['overview_polyline']['points']);

            return DirectionsResult(
              polylinePoints: points,
              distanceText: leg['distance']['text'] ?? '',
              durationText: leg['duration']['text'] ?? '',
              distanceValueMeters: (leg['distance']['value'] as num).toDouble(),
              durationValueSeconds: (leg['duration']['value'] as num).toDouble(),
            );
          }
        }
      } catch (e) {
        // Fallback sang mock calculation nếu gặp lỗi mạng hoặc API key
      }
    }

    // Fallback: Tính toán khoảng cách Haversine và mô phỏng đường đi chi tiết
    return _generateMockDirections(origin, destination, mode);
  }

  /// Chuyển đổi địa chỉ văn bản thành Tọa độ LatLng (Geocoding)
  static Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      List<geo.Location> locations = await geo.locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (_) {}

    // Fallback thử dùng Nominatim OpenStreetMap API nếu geocoding native gặp hạn chế
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(address)}');
      final response = await http.get(url, headers: {'User-Agent': 'FlutterApp/1.0'});
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        }
      }
    } catch (_) {}

    return null;
  }

  /// Mô phỏng tuyến đường linh hoạt cho các phương tiện khi không có kết nối API Key chính thức
  static DirectionsResult _generateMockDirections(
      LatLng origin, LatLng destination, String mode) {
    double distanceKm = _calculateHaversineDistance(origin, destination);
    double speedKmH = 40.0; // Xe máy / Ô tô mặc định
    if (mode == 'walking') {
      speedKmH = 5.0;
    } else if (mode == 'bicycling') {
      speedKmH = 15.0;
    } else if (mode == 'driving') {
      speedKmH = 50.0;
    } else if (mode == 'transit') {
      speedKmH = 30.0;
    }

    double hours = distanceKm / speedKmH;
    int minutes = (hours * 60).round();
    if (minutes < 1) minutes = 1;

    String durationText = minutes >= 60
        ? '${minutes ~/ 60} giờ ${minutes % 60} phút'
        : '$minutes phút';
    String distanceText = distanceKm < 1.0
        ? '${(distanceKm * 1000).round()} m'
        : '${distanceKm.toStringAsFixed(1)} km';

    // Tạo các điểm nối zic-zac tự nhiên giữa điểm đầu và điểm cuối
    List<LatLng> interpolatedPoints = [origin];
    int steps = 6;
    for (int i = 1; i < steps; i++) {
      double fraction = i / steps;
      double lat = origin.latitude + (destination.latitude - origin.latitude) * fraction;
      double lng = origin.longitude + (destination.longitude - origin.longitude) * fraction;

      // Thêm độ lệch góc đường (zigzag)
      double offsetLat = (i % 2 == 1 ? 0.0012 : -0.0009);
      double offsetLng = (i % 2 == 1 ? -0.0008 : 0.0014);

      interpolatedPoints.add(LatLng(lat + offsetLat, lng + offsetLng));
    }
    interpolatedPoints.add(destination);

    return DirectionsResult(
      polylinePoints: interpolatedPoints,
      distanceText: distanceText,
      durationText: durationText,
      distanceValueMeters: distanceKm * 1000,
      durationValueSeconds: hours * 3600,
    );
  }

  static double _calculateHaversineDistance(LatLng p1, LatLng p2) {
    const double r = 6371; // Bán kính trái đất (km)
    double dLat = _toRadians(p2.latitude - p1.latitude);
    double dLng = _toRadians(p2.longitude - p1.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(p1.latitude)) *
            cos(_toRadians(p2.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  static double _toRadians(double degree) => degree * pi / 180;
}
