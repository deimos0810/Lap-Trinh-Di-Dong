import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/directions_service.dart';

class PoiCategory {
  final String name;
  final IconData icon;
  final String type;
  final BitmapDescriptor markerIcon;

  PoiCategory({
    required this.name,
    required this.icon,
    required this.type,
    required this.markerIcon,
  });
}

class Bai4InClassScreen extends StatefulWidget {
  const Bai4InClassScreen({super.key});

  @override
  State<Bai4InClassScreen> createState() => _Bai4InClassScreenState();
}

class _Bai4InClassScreenState extends State<Bai4InClassScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  LatLng? _startLatLng;
  LatLng? _endLatLng;
  LatLng? _currentLocation;

  String _distanceText = '';
  String _durationText = '';
  bool _isLoading = false;
  String _selectedPoiCategory = 'All';

  // Chọn chế độ chọn điểm khi click bản đồ: 'start' hoặc 'end'
  String _mapClickTarget = 'end';

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        if (_startLatLng == null) {
          _startLatLng = _currentLocation;
          _startController.text = "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
        }
        // Mặc định điểm đến là Trường ĐH Công Thương TP.HCM (HUIT)
        if (_endLatLng == null) {
          _endLatLng = const LatLng(10.8065, 106.6289);
          _endController.text = "10.8065, 106.6289"; // ĐH Công Thương TP.HCM
        }
        _updateMarkers();
      });
    } catch (_) {
      // Vị trí giả định nếu chưa có GPS
      setState(() {
        _currentLocation = const LatLng(10.7769, 106.7009);
        if (_startLatLng == null) {
          _startLatLng = _currentLocation;
          _startController.text = "10.7769, 106.7009";
        }
        if (_endLatLng == null) {
          _endLatLng = const LatLng(10.8065, 106.6289);
          _endController.text = "10.8065, 106.6289";
        }
        _updateMarkers();
      });
    }
  }

  /// Nút 1: Lấy vị trí hiện tại làm điểm ĐÍCH
  Future<void> _setCurrentLocationAsDestination() async {
    await _fetchCurrentLocation();
    if (_currentLocation != null) {
      setState(() {
        _endLatLng = _currentLocation;
        _endController.text =
            "${_currentLocation!.latitude.toStringAsFixed(4)}, ${_currentLocation!.longitude.toStringAsFixed(4)}";
        _updateMarkers();
      });
      _moveCamera(_currentLocation!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã chọn vị trí hiện tại làm điểm đích!')),
        );
      }
    }
  }

  /// Nút 2: Lấy vị trí hiện tại làm điểm XUẤT PHÁT
  Future<void> _setCurrentLocationAsStart() async {
    await _fetchCurrentLocation();
    if (_currentLocation != null) {
      setState(() {
        _startLatLng = _currentLocation;
        _startController.text =
            "${_currentLocation!.latitude.toStringAsFixed(4)}, ${_currentLocation!.longitude.toStringAsFixed(4)}";
        _updateMarkers();
      });
      _moveCamera(_currentLocation!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã chọn vị trí hiện tại làm điểm xuất phát!')),
        );
      }
    }
  }

  /// Click chọn điểm trên bản đồ
  void _onMapTapped(LatLng position) {
    setState(() {
      if (_mapClickTarget == 'start') {
        _startLatLng = position;
        _startController.text =
            "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã chọn điểm xuất phát từ bản đồ: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}')),
        );
      } else {
        _endLatLng = position;
        _endController.text =
            "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã chọn điểm đích từ bản đồ: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}')),
        );
      }
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    _markers.removeWhere((m) => m.markerId.value == 'start' || m.markerId.value == 'end');

    if (_startLatLng != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: _startLatLng!,
          infoWindow: const InfoWindow(title: 'Điểm xuất phát'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    if (_endLatLng != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: _endLatLng!,
          infoWindow: const InfoWindow(title: 'Điểm đích'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  Future<void> _moveCamera(LatLng position) async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 14));
  }

  /// Tìm đường đi & lấy thông tin Distance, Duration từ Directions API
  Future<void> _findRoute() async {
    if (_startLatLng == null || _endLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn cả điểm xuất phát và điểm đích!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await DirectionsService.getDirections(
      origin: _startLatLng!,
      destination: _endLatLng!,
      mode: 'driving',
    );

    if (result != null) {
      setState(() {
        _distanceText = result.distanceText;
        _durationText = result.durationText;

        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('inclass_route'),
            points: result.polylinePoints,
            color: Colors.deepPurple,
            width: 5,
          ),
        );
      });
    }

    setState(() => _isLoading = false);
  }

  /// Tìm kiếm & hiển thị địa điểm lân cận POI (Khách sạn, Quán ăn, Bệnh viện, Trường học)
  void _loadPoiMarkers(String category) {
    setState(() {
      _selectedPoiCategory = category;
      _markers.removeWhere((m) => m.markerId.value.startsWith('poi_'));

      if (category == 'None') return;

      // Danh sách POI thực tế tại khu vực TP. Hồ Chí Minh
      List<Map<String, dynamic>> allPois = [
        // Quán ăn
        {
          'name': 'Bún bò Huế 72 Tân Phú',
          'cat': 'Quán ăn',
          'lat': 10.8012, 'lng': 106.6331,
          'hue': BitmapDescriptor.hueOrange,
          'info': 'Quán ăn truyền thống - Gần ĐH Công Thương',
        },
        {
          'name': 'Cơm tấm Thủ Đức',
          'cat': 'Quán ăn',
          'lat': 10.8098, 'lng': 106.6241,
          'hue': BitmapDescriptor.hueOrange,
          'info': 'Cơm tấm Sài Gòn đặc trưng',
        },
        {
          'name': 'Phở Hùng - Tân Phú',
          'cat': 'Quán ăn',
          'lat': 10.8033, 'lng': 106.6198,
          'hue': BitmapDescriptor.hueOrange,
          'info': 'Phở bò, phở gà nổi tiếng',
        },
        {
          'name': 'Quán cơm Bà Cả Đọi',
          'cat': 'Quán ăn',
          'lat': 10.8120, 'lng': 106.6350,
          'hue': BitmapDescriptor.hueOrange,
          'info': 'Cơm bình dân ngon - gần HUIT',
        },
        // Khách sạn
        {
          'name': 'Khách sạn Kim Anh',
          'cat': 'Khách sạn',
          'lat': 10.8010, 'lng': 106.6320,
          'hue': BitmapDescriptor.hueViolet,
          'info': 'Khách sạn 2 sao - Gần trung tâm Tân Phú',
        },
        {
          'name': 'Mường Thanh Sài Gòn',
          'cat': 'Khách sạn',
          'lat': 10.7700, 'lng': 106.6900,
          'hue': BitmapDescriptor.hueViolet,
          'info': 'Khách sạn 3 sao - Quận 1',
        },
        {
          'name': 'Khách sạn Tân Phú Plaza',
          'cat': 'Khách sạn',
          'lat': 10.8055, 'lng': 106.6270,
          'hue': BitmapDescriptor.hueViolet,
          'info': 'Gần Đại học Công Thương',
        },
        // Bệnh viện
        {
          'name': 'Bệnh viện Chợ Rẫy',
          'cat': 'Bệnh viện',
          'lat': 10.7555, 'lng': 106.6687,
          'hue': BitmapDescriptor.hueRose,
          'info': 'BV Chợ Rẫy - 201B Nguyễn Chí Thanh, Quận 5',
        },
        {
          'name': 'BV Nhi Đồng 1',
          'cat': 'Bệnh viện',
          'lat': 10.7664, 'lng': 106.6737,
          'hue': BitmapDescriptor.hueRose,
          'info': 'Bệnh viện nhi lớn nhất TP.HCM',
        },
        {
          'name': 'BV Quận Tân Phú',
          'cat': 'Bệnh viện',
          'lat': 10.8006, 'lng': 106.6244,
          'hue': BitmapDescriptor.hueRose,
          'info': '161 Lũy Bán Bích, Tân Phú',
        },
        // Trường học
        {
          'name': 'ĐH Công Thương TP.HCM (HUIT)',
          'cat': 'Trường học',
          'lat': 10.8065, 'lng': 106.6289,
          'hue': BitmapDescriptor.hueAzure,
          'info': '140 Lê Trọng Tấn, Tây Thạnh, Tân Phú',
        },
        {
          'name': 'ĐH Bách Khoa TP.HCM',
          'cat': 'Trường học',
          'lat': 10.7726, 'lng': 106.6583,
          'hue': BitmapDescriptor.hueAzure,
          'info': '268 Lý Thường Kiệt, Quận 10',
        },
        {
          'name': 'ĐH Sư phạm TP.HCM',
          'cat': 'Trường học',
          'lat': 10.7621, 'lng': 106.6829,
          'hue': BitmapDescriptor.hueAzure,
          'info': '280 An Dương Vương, Quận 5',
        },
      ];

      for (int i = 0; i < allPois.length; i++) {
        final poi = allPois[i];
        if (category == 'All' || poi['cat'] == category) {
          final poiPos = LatLng(poi['lat'], poi['lng']);
          _markers.add(
            Marker(
              markerId: MarkerId('poi_$i'),
              position: poiPos,
              infoWindow: InfoWindow(
                title: poi['name'],
                snippet: '${poi['info']} • Nhấn để chọn điểm đích',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(poi['hue']),
              onTap: () {
                setState(() {
                  _endLatLng = poiPos;
                  _endController.text = "${poiPos.latitude.toStringAsFixed(4)}, ${poiPos.longitude.toStringAsFixed(4)}";
                  _updateMarkers();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã chọn: ${poi['name']} làm điểm đích')),
                );
              },
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 4 (Trên Lớp): Maps & POI & Tap'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Control panel
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.teal.shade50,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _startController,
                        decoration: const InputDecoration(
                          labelText: 'Xuất phát (lat, lng)',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filledTonal(
                      onPressed: _setCurrentLocationAsStart,
                      icon: const Icon(Icons.my_location),
                      tooltip: 'Vị trí hiện tại -> Xuất phát',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _endController,
                        decoration: const InputDecoration(
                          labelText: 'Đích đến (lat, lng)',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filledTonal(
                      onPressed: _setCurrentLocationAsDestination,
                      icon: const Icon(Icons.flag),
                      tooltip: 'Lấy vị trí hiện tại làm ĐÍCH',
                      style: IconButton.styleFrom(backgroundColor: Colors.amber.shade200),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Chọn mục đích khi Tap bản đồ
                Row(
                  children: [
                    const Text('Chế độ tap bản đồ: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ChoiceChip(
                      label: const Text('Chọn Điểm Đích'),
                      selected: _mapClickTarget == 'end',
                      onSelected: (val) => setState(() => _mapClickTarget = 'end'),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: const Text('Chọn Xuất Phát'),
                      selected: _mapClickTarget == 'start',
                      onSelected: (val) => setState(() => _mapClickTarget = 'start'),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Lọc POI (Địa điểm)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text('Tìm địa điểm: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      FilterChip(
                        label: const Text('Tất cả POI'),
                        selected: _selectedPoiCategory == 'All',
                        onSelected: (_) => _loadPoiMarkers('All'),
                      ),
                      const SizedBox(width: 4),
                      FilterChip(
                        label: const Text('Quán ăn'),
                        selected: _selectedPoiCategory == 'Quán ăn',
                        onSelected: (_) => _loadPoiMarkers('Quán ăn'),
                      ),
                      const SizedBox(width: 4),
                      FilterChip(
                        label: const Text('Khách sạn'),
                        selected: _selectedPoiCategory == 'Khách sạn',
                        onSelected: (_) => _loadPoiMarkers('Khách sạn'),
                      ),
                      const SizedBox(width: 4),
                      FilterChip(
                        label: const Text('Bệnh viện'),
                        selected: _selectedPoiCategory == 'Bệnh viện',
                        onSelected: (_) => _loadPoiMarkers('Bệnh viện'),
                      ),
                      const SizedBox(width: 4),
                      FilterChip(
                        label: const Text('Trường học'),
                        selected: _selectedPoiCategory == 'Trường học',
                        onSelected: (_) => _loadPoiMarkers('Trường học'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Button tìm đường
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _findRoute,
                    icon: const Icon(Icons.navigation),
                    label: const Text('Tính khoảng cách & Thời gian di chuyển'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

                // Thẻ hiển thị khoảng cách và thời gian
                if (_distanceText.isNotEmpty && _durationText.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.straighten, color: Colors.teal),
                            const SizedBox(width: 6),
                            Text('Khoảng cách: $_distanceText', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.teal),
                            const SizedBox(width: 6),
                            Text('Thời gian: $_durationText', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
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
                  onMapCreated: (controller) => _controller.complete(controller),
                  onTap: _onMapTapped,
                  myLocationEnabled: true,
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black26,
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
