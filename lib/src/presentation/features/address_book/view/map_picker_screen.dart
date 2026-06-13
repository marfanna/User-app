import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const _kGeocodingApiKey = 'AIzaSyBU7GqUxT98kSlVbD0iFMijQOQFZUbgA7Q';

class MapPickerResult {
  const MapPickerResult({
    required this.lat,
    required this.lng,
    required this.address,
    this.city = '',
    this.district = '',
    this.division = '',
  });
  final double lat;
  final double lng;
  final String address;
  final String city;
  final String district;
  final String division;
}

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({
    super.key,
    this.initialLat,
    this.initialLng,
  });
  final double? initialLat;
  final double? initialLng;

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? _mapController;
  late LatLng _center;
  bool _reverseGeocoding = false;
  String _currentAddress = '';
  String _city = '';
  String _district = '';
  String _division = '';
  final _dio = Dio();

  static const _defaultCenter = LatLng(23.8103, 90.4125);

  @override
  void initState() {
    super.initState();
    _center = (widget.initialLat != null && widget.initialLng != null)
        ? LatLng(widget.initialLat!, widget.initialLng!)
        : _defaultCenter;
    _reverseGeocode(_center);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _dio.close();
    super.dispose();
  }

  Future<void> _reverseGeocode(LatLng position) async {
    setState(() => _reverseGeocoding = true);
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'latlng': '${position.latitude},${position.longitude}',
          'key': _kGeocodingApiKey,
          'language': 'en',
        },
      );
      final results = response.data['results'] as List?;
      if (results != null && results.isNotEmpty && mounted) {
        final first = results.first as Map;
        final components =
            first['address_components'] as List? ?? [];
        String city = '';
        String district = '';
        String division = '';
        for (final comp in components) {
          final types = (comp['types'] as List?)?.cast<String>() ?? [];
          final name = comp['long_name'] as String? ?? '';
          if (types.contains('locality')) city = name;
          if (types.contains('administrative_area_level_2')) district = name;
          if (types.contains('administrative_area_level_1')) division = name;
        }
        setState(() {
          _currentAddress =
              first['formatted_address'] as String? ?? '';
          _city = city;
          _district = district;
          _division = division;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _currentAddress =
              '${position.latitude.toStringAsFixed(5)}, '
              '${position.longitude.toStringAsFixed(5)}';
        });
      }
    } finally {
      if (mounted) setState(() => _reverseGeocoding = false);
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() => _center = position.target);
  }

  void _onCameraIdle() {
    _reverseGeocode(_center);
  }

  void _confirm() {
    Navigator.of(context).pop(MapPickerResult(
      lat: _center.latitude,
      lng: _center.longitude,
      address: _currentAddress,
      city: _city,
      district: _district,
      division: _division,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _center, zoom: 16),
            onMapCreated: (c) => _mapController = c,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Fixed center pin — tip at exact map center
          IgnorePointer(
            child: Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: const Icon(
                  Icons.location_on,
                  color: Color(0xFFE53935),
                  size: 48,
                ),
              ),
            ),
          ),

          // Header bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 8),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Color(0xFF1C1B1F),
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 8),
                        ],
                      ),
                      child: const Text(
                        'Move map to pin your location',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF040707),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom confirm panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFE53935),
                        size: 18,
                      ),
                      const Gap(6),
                      if (_reverseGeocoding)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF0156A7),
                          ),
                        )
                      else
                        Expanded(
                          child: Text(
                            _currentAddress.isNotEmpty
                                ? _currentAddress
                                : '${_center.latitude.toStringAsFixed(5)}, '
                                    '${_center.longitude.toStringAsFixed(5)}',
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF040707),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  const Gap(12),
                  GestureDetector(
                    onTap: _reverseGeocoding ? null : _confirm,
                    child: Container(
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: _reverseGeocoding
                            ? null
                            : const RadialGradient(
                                center: Alignment(-0.27, -0.27),
                                radius: 1.53,
                                colors: [
                                  Color(0xFF0156A7),
                                  Color(0xFF2E3293),
                                ],
                              ),
                        color: _reverseGeocoding
                            ? const Color(0xFFB0BEC5)
                            : null,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Confirm Location',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
