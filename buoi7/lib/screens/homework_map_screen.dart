import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/favorite_route.dart';
import '../services/directions_service.dart';
import '../services/sqlite_service.dart';

class HomeworkMapScreen extends StatefulWidget {
  const HomeworkMapScreen({super.key});

  @override
  State<HomeworkMapScreen> createState() => _HomeworkMapScreenState();
}

class _HomeworkMapScreenState extends State<HomeworkMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  final TextEditingController _startAddressController = TextEditingController();
  final TextEditingController _endAddressController = TextEditingController();

  LatLng? _startLatLng;
  LatLng? _endLatLng;
  String _travelMode = 'driving'; // driving, bicycling (xe máy), walking, transit

  String _distanceText = '';
  String _durationText = '';
  bool _isLoading = false;

  List<FavoriteRoute> _favoriteRoutes = [];

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    _startAddressController.text = "227 Nguyễn Văn Cừ, Quận 5, TP.HCM";
    _endAddressController.text = "140 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM";
    _loadFavoriteRoutes();
  }

  Future<void> _loadFavoriteRoutes() async {
    final list = await SqliteService.instance.getAllFavoriteRoutes();
    setState(() {
      _favoriteRoutes = list;
    });
  }

  Color _getPolylineColor(String mode) {
    switch (mode) {
      case 'walking':
        return Colors.green;
      case 'bicycling':
        return Colors.orange;
      case 'transit':
        return Colors.purple;
      case 'driving':
      default:
        return Colors.blueAccent;
    }
  }

  /// 1. Tìm địa chỉ bằng Geocoding API & Tính tuyến đường
  Future<void> _searchAndFindRoute() async {
    String startText = _startAddressController.text.trim();
    String endText = _endAddressController.text.trim();

    if (startText.isEmpty || endText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ địa chỉ xuất phát và điểm đến!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Chuyển địa chỉ -> LatLng bằng Geocoding API / Nominatim
      LatLng? start = await DirectionsService.getCoordinatesFromAddress(startText);
      LatLng? end = await DirectionsService.getCoordinatesFromAddress(endText);

      // Fallback vị trí nếu Geocoding không kết quả
      start ??= const LatLng(10.7626, 106.6823); // Q5, TP.HCM
      end ??= const LatLng(10.8065, 106.6289);   // HUIT Tân Phú

      _startLatLng = start;
      _endLatLng = end;

      final directions = await DirectionsService.getDirections(
        origin: start,
        destination: end,
        mode: _travelMode,
      );

      if (directions != null) {
        setState(() {
          _distanceText = directions.distanceText;
          _durationText = directions.durationText;

          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('start'),
              position: start!,
              infoWindow: InfoWindow(title: 'Xuất phát: $startText'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            ),
          );
          _markers.add(
            Marker(
              markerId: const MarkerId('end'),
              position: end!,
              infoWindow: InfoWindow(title: 'Điểm đến: $endText'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          );

          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route_$_travelMode'),
              points: directions.polylinePoints,
              color: _getPolylineColor(_travelMode),
              width: 6,
            ),
          );
        });

        _moveCamera(start);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi chuyển đổi địa chỉ: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _moveCamera(LatLng position) async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 13));
  }

  /// 2. Lưu tuyến đường vào danh sách yêu thích (SQLite)
  Future<void> _saveRouteToFavorites() async {
    if (_startLatLng == null || _endLatLng == null || _distanceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng tìm tuyến đường trước khi lưu vào Yêu thích!')),
      );
      return;
    }

    final route = FavoriteRoute(
      title: '${_startAddressController.text} ➔ ${_endAddressController.text}',
      startAddress: _startAddressController.text,
      startLat: _startLatLng!.latitude,
      startLng: _startLatLng!.longitude,
      endAddress: _endAddressController.text,
      endLat: _endLatLng!.latitude,
      endLng: _endLatLng!.longitude,
      travelMode: _travelMode,
      distanceText: _distanceText,
      durationText: _durationText,
      createdAt: DateTime.now().toString().substring(0, 16),
    );

    await SqliteService.instance.insertFavoriteRoute(route);
    await _loadFavoriteRoutes();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu tuyến đường vào SQLite Yêu thích!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// 3. Khôi phục tuyến đường đã lưu từ SQLite
  void _loadSavedRoute(FavoriteRoute route) {
    setState(() {
      _startAddressController.text = route.startAddress;
      _endAddressController.text = route.endAddress;
      _travelMode = route.travelMode;
      _distanceText = route.distanceText;
      _durationText = route.durationText;

      _startLatLng = LatLng(route.startLat, route.startLng);
      _endLatLng = LatLng(route.endLat, route.endLng);
    });

    _searchAndFindRoute();
    Navigator.of(context).pop(); // Đóng ModalBottomSheet
  }

  /// 4. Xóa tuyến đường khỏi SQLite
  Future<void> _deleteFavoriteRoute(int id) async {
    await SqliteService.instance.deleteFavoriteRoute(id);
    await _loadFavoriteRoutes();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa tuyến đường khỏi Yêu thích.')),
      );
    }
  }

  /// Mở danh sách tuyến đường yêu thích SQLite
  void _showFavoriteRoutesBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '⭐ Tuyến đường Yêu thích (SQLite)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const Divider(),
                  _favoriteRoutes.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Center(
                            child: Text('Chưa có tuyến đường nào được lưu vào SQLite.'),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _favoriteRoutes.length,
                            itemBuilder: (context, index) {
                              final item = _favoriteRoutes[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: _getPolylineColor(item.travelMode).withValues(alpha: 0.2),
                                    child: Icon(
                                      item.travelMode == 'driving'
                                          ? Icons.directions_car
                                          : item.travelMode == 'bicycling'
                                              ? Icons.two_wheeler
                                              : item.travelMode == 'walking'
                                                  ? Icons.directions_walk
                                                  : Icons.directions_bus,
                                      color: _getPolylineColor(item.travelMode),
                                    ),
                                  ),
                                  title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text('${item.distanceText} • ${item.durationText} (${item.createdAt})'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () async {
                                      await _deleteFavoriteRoute(item.id!);
                                      setModalState(() {});
                                    },
                                  ),
                                  onTap: () => _loadSavedRoute(item),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài Tập Về Nhà: Geocoding & SQLite'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: _showFavoriteRoutesBottomSheet,
            tooltip: 'Tuyến đường yêu thích (SQLite)',
          ),
        ],
      ),
      body: Column(
        children: [
          // Control Panel
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.orange.shade50,
            child: Column(
              children: [
                // Nhập địa chỉ xuất phát bằng chữ (Geocoding API)
                TextField(
                  controller: _startAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ xuất phát (Geocoding API)',
                    prefixIcon: Icon(Icons.search, color: Colors.green),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),

                // Nhập địa chỉ đích đến bằng chữ (Geocoding API)
                TextField(
                  controller: _endAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ điểm đến (Geocoding API)',
                    prefixIcon: Icon(Icons.place, color: Colors.red),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),

                // Chọn loại phương tiện di chuyển
                Row(
                  children: [
                    const Text('Phương tiện: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'driving',
                            label: Text('Ô tô'),
                            icon: Icon(Icons.directions_car, size: 16),
                          ),
                          ButtonSegment(
                            value: 'bicycling',
                            label: Text('Xe máy'),
                            icon: Icon(Icons.two_wheeler, size: 16),
                          ),
                          ButtonSegment(
                            value: 'walking',
                            label: Text('Đi bộ'),
                            icon: Icon(Icons.directions_walk, size: 16),
                          ),
                          ButtonSegment(
                            value: 'transit',
                            label: Text('Xe buýt'),
                            icon: Icon(Icons.directions_bus, size: 16),
                          ),
                        ],
                        selected: {_travelMode},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _travelMode = newSelection.first;
                          });
                          _searchAndFindRoute();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Nút tìm đường & Nút Lưu SQLite
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _searchAndFindRoute,
                        icon: const Icon(Icons.alt_route),
                        label: const Text('Tìm đường & Vẽ Polyline'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: OutlinedButton.icon(
                        onPressed: _saveRouteToFavorites,
                        icon: const Icon(Icons.bookmark_add),
                        label: const Text('Lưu SQLite'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),

                // Thông tin kết quả
                if (_distanceText.isNotEmpty && _durationText.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Quãng đường: $_distanceText', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Thời gian: $_durationText', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Chế độ: ${_travelMode.toUpperCase()}', style: TextStyle(color: Colors.deepOrange[800], fontWeight: FontWeight.bold)),
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
