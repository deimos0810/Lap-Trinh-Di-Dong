import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/directions_service.dart';

class Bai2RouteScreen extends StatefulWidget {
  const Bai2RouteScreen({super.key});

  @override
  State<Bai2RouteScreen> createState() => _Bai2RouteScreenState();
}

class _Bai2RouteScreenState extends State<Bai2RouteScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  LatLng? _startLatLng;
  LatLng? _endLatLng;
  bool _isLoading = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009), // TP.HCM mặc định
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission != LocationPermission.denied && permission != LocationPermission.deniedForever) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _startLatLng = LatLng(position.latitude, position.longitude);
          _endLatLng = const LatLng(10.8065, 106.6289); // ĐH Công Thương TP.HCM (HUIT)
          _addMarker(_startLatLng!, "Xuất phát (Vị trí hiện tại)", BitmapDescriptor.hueGreen);
          _addMarker(_endLatLng!, "Đích đến (ĐH Công Thương TP.HCM)", BitmapDescriptor.hueRed);
          _moveCamera(_startLatLng!);
          _startController.text = "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
          _endController.text = "10.8065, 106.6289"; // Trường Đại học Công Thương TP.HCM
        });
      }
    } catch (_) {
      // Tọa độ mặc định nếu chưa lấy được GPS
      setState(() {
        _startLatLng = const LatLng(10.7769, 106.7009);
        _endLatLng = const LatLng(10.8065, 106.6289);
        _startController.text = "10.7769, 106.7009";
        _endController.text = "10.8065, 106.6289";
      });
    }
  }

  void _addMarker(LatLng position, String title, double hue) {
    _markers.add(
      Marker(
        markerId: MarkerId(title),
        position: position,
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      ),
    );
  }

  Future<void> _moveCamera(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 13));
  }

  Future<void> _findRoute() async {
    if (_startController.text.trim().isEmpty || _endController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ tọa độ điểm xuất phát và đích đến!')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      List<String> start = _startController.text.split(',');
      List<String> end = _endController.text.split(',');

      _startLatLng = LatLng(double.parse(start[0].trim()), double.parse(start[1].trim()));
      _endLatLng = LatLng(double.parse(end[0].trim()), double.parse(end[1].trim()));

      final result = await DirectionsService.getDirections(
        origin: _startLatLng!,
        destination: _endLatLng!,
        mode: 'driving',
      );

      if (result != null && result.polylinePoints.isNotEmpty) {
        setState(() {
          _markers.clear();
          _addMarker(_startLatLng!, "Xuất phát", BitmapDescriptor.hueGreen);
          _addMarker(_endLatLng!, "Đích đến", BitmapDescriptor.hueRed);

          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: result.polylinePoints,
              color: Colors.blueAccent,
              width: 5,
            ),
          );
        });

        _moveCamera(_startLatLng!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tìm đường thành công! Khoảng cách: ${result.distanceText}, Thời gian: ${result.durationText}'),
              backgroundColor: Colors.green[700],
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không tìm thấy tuyến đường nào!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Định dạng tọa độ không hợp lệ. Vui lòng nhập dạng: lat, lng (Ví dụ: 10.7769, 106.7009)')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 2: Route Finder (Tìm Đường)'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.indigo.shade50,
            child: Column(
              children: [
                TextField(
                  controller: _startController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm xuất phát (lat, lng)',
                    prefixIcon: Icon(Icons.my_location, color: Colors.green),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _endController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm đích (lat, lng)',
                    prefixIcon: Icon(Icons.location_on, color: Colors.red),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _findRoute,
                    icon: _isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.directions),
                    label: Text(_isLoading ? 'Đang tìm...' : 'Tìm đường đi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialPosition,
                  markers: _markers,
                  polylines: _polylines,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black12,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
