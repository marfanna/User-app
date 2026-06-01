import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

const _kGoogleApiKey = 'AIzaSyBU7GqUxT98kSlVbD0iFMijQOQFZUbgA7Q';

class _PlaceSuggestion {
  const _PlaceSuggestion({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });
  final String placeId;
  final String mainText;
  final String secondaryText;
}

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isDefault = true;
  bool _loadingLocation = false;
  String? _locationError;

  // Autocomplete
  final _dio = Dio();
  List<_PlaceSuggestion> _suggestions = [];
  bool _suggestionsLoading = false;
  Timer? _debounce;
  bool _suppressAutocomplete = false; // true after GPS fill or suggestion pick

  // Coordinates from GPS or place selection
  double? _lat;
  double? _lng;

  static const _titleSuggestions = [
    ('🏠', 'Home'),
    ('🏢', 'Office'),
    ('📍', 'Other'),
  ];

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _debounce?.cancel();
    _dio.close();
    super.dispose();
  }

  // ── GPS location ──────────────────────────────────────────────────────────

  Future<void> _fetchLocation() async {
    setState(() {
      _loadingLocation = true;
      _locationError = null;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          _locationError = 'Location permission denied. Enter address manually.';
          _loadingLocation = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _lat = position.latitude;
      _lng = position.longitude;

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final p = placemarks.first;
        final parts = [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
        ].where((s) => s != null && s.isNotEmpty).toList();

        _suppressAutocomplete = true;
        _addressController.text = parts.join(', ');
        _suggestions = [];
      }
    } catch (e) {
      if (mounted) {
        setState(() => _locationError = 'Could not get location. Enter manually.');
      }
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  // ── Places Autocomplete ───────────────────────────────────────────────────

  void _onAddressChanged(String value) {
    if (_suppressAutocomplete) {
      _suppressAutocomplete = false;
      return;
    }
    _lat = null;
    _lng = null;

    _debounce?.cancel();
    if (value.trim().length < 3) {
      setState(() => _suggestions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _fetchSuggestions(value.trim());
    });
  }

  Future<void> _fetchSuggestions(String input) async {
    setState(() => _suggestionsLoading = true);
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': input,
          'key': _kGoogleApiKey,
          'components': 'country:BD',
          'location': '23.8103,90.4125',
          'radius': '200000',
          'language': 'en',
        },
      );
      final predictions = response.data['predictions'] as List<dynamic>? ?? [];
      if (mounted) {
        setState(() {
          _suggestions = predictions.map((p) {
            final structured = p['structured_formatting'] as Map?;
            return _PlaceSuggestion(
              placeId: p['place_id'] as String,
              mainText: structured?['main_text'] as String? ?? p['description'] as String,
              secondaryText: structured?['secondary_text'] as String? ?? '',
            );
          }).toList();
        });
      }
    } catch (_) {
      if (mounted) setState(() => _suggestions = []);
    } finally {
      if (mounted) setState(() => _suggestionsLoading = false);
    }
  }

  Future<void> _selectSuggestion(_PlaceSuggestion s) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _suggestions = [];
      _suggestionsLoading = false;
    });

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': s.placeId,
          'fields': 'formatted_address,geometry',
          'key': _kGoogleApiKey,
        },
      );
      final result = response.data['result'] as Map?;
      if (result != null && mounted) {
        final location = result['geometry']?['location'];
        if (location != null) {
          _lat = (location['lat'] as num).toDouble();
          _lng = (location['lng'] as num).toDouble();
        }
        _suppressAutocomplete = true;
        _addressController.text =
            result['formatted_address'] as String? ??
            '${s.mainText}, ${s.secondaryText}';
      }
    } catch (_) {
      _suppressAutocomplete = true;
      _addressController.text = '${s.mainText}, ${s.secondaryText}';
    }
  }

  // ── Title chips ───────────────────────────────────────────────────────────

  void _selectTitle(String title) {
    setState(() => _titleController.text = title);
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  void _saveAddress() {
    final title = _titleController.text.trim();
    final address = _addressController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title for this address')),
      );
      return;
    }
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full address')),
      );
      return;
    }
    Navigator.of(context).pop();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: _buildFormCard(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildSaveButton(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1C1B1F)),
                ),
              ),
              const Gap(16),
              const Text(
                'Add Address',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  height: 1.0,
                  letterSpacing: -0.5,
                  color: Color(0xFF040707),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 100,
              width: double.infinity,
              color: const Color(0xFFE8F0FE),
              child: Stack(
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, 100),
                    painter: _MapGridPainter(),
                  ),
                  Center(
                    child: _loadingLocation
                        ? const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF0156A7),
                                ),
                              ),
                              Gap(6),
                              Text(
                                'Getting location…',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0156A7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFFE53935), size: 36),
                              if (_lat != null && _lng != null)
                                Text(
                                  '${_lat!.toStringAsFixed(4)}, ${_lng!.toStringAsFixed(4)}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF0156A7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                  ),
                  if (_locationError != null && !_loadingLocation)
                    Positioned(
                      bottom: 6,
                      right: 8,
                      child: GestureDetector(
                        onTap: _fetchLocation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0156A7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (_locationError != null) ...[
            const Gap(8),
            Text(
              _locationError!,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                color: Color(0xFFE53935),
              ),
            ),
          ],

          const Gap(16),

          // Title
          _buildFieldLabel('Title'),
          const Gap(10),
          Row(
            children: _titleSuggestions.map((s) {
              final emoji = s.$1;
              final label = s.$2;
              final selected = _titleController.text == label;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => _selectTitle(label),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF0156A7) : const Color(0xFFF5F7FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? const Color(0xFF0156A7) : const Color(0xFFD2D3D6),
                      ),
                    ),
                    child: Text(
                      '$emoji $label',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: selected ? Colors.white : const Color(0xFF040707),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const Gap(10),
          _buildTextField(
            controller: _titleController,
            hint: 'Or type a custom title…',
          ),
          const Gap(16),

          // Full address with autocomplete
          _buildFieldLabel('Full Address'),
          const Gap(10),
          _buildAddressField(),
          const Gap(16),

          // Default toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Default Shipping Address',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.71,
                  letterSpacing: -0.5,
                  color: Color(0xFF2D3340),
                ),
              ),
              Switch(
                value: _isDefault,
                onChanged: (v) => setState(() => _isDefault = v),
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF0156A7),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFD2D3D6),
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: _addressController,
              maxLines: 2,
              onChanged: _onAddressChanged,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                letterSpacing: -0.5,
                color: Color(0xFF040707),
              ),
              decoration: InputDecoration(
                hintText: 'Search or enter your address',
                hintStyle: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  letterSpacing: -0.5,
                  color: Color(0xFF737780),
                ),
                contentPadding: const EdgeInsets.fromLTRB(16, 14, 48, 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFFD2D3D6)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFFD2D3D6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFF0156A7)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _loadingLocation || _suggestionsLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0156A7)),
                    )
                  : GestureDetector(
                      onTap: _fetchLocation,
                      child: const Tooltip(
                        message: 'Use my location',
                        child: Icon(Icons.my_location, size: 20, color: Color(0xFF0156A7)),
                      ),
                    ),
            ),
          ],
        ),

        // Suggestions dropdown
        if (_suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFD2D3D6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, i) {
                final s = _suggestions[i];
                return InkWell(
                  onTap: () => _selectSuggestion(s),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF0156A7)),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.mainText,
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Color(0xFF040707),
                                ),
                              ),
                              if (s.secondaryText.isNotEmpty)
                                Text(
                                  s.secondaryText,
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                    color: Color(0xFF737780),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        // Coordinates confirmation
        if (_lat != null && _lng != null && _suggestions.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 14, color: Color(0xFF2E7D32)),
                const Gap(4),
                Text(
                  'Location pinned (${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)})',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.5,
        color: Color(0xFF040707),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        letterSpacing: -0.5,
        color: Color(0xFF040707),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w400,
          fontSize: 16,
          letterSpacing: -0.5,
          color: Color(0xFF737780),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFD2D3D6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFD2D3D6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF0156A7)),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: GestureDetector(
          onTap: _saveAddress,
          child: Container(
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                center: Alignment(-0.27, -0.27),
                radius: 1.53,
                colors: [Color(0xFF0156A7), Color(0xFF2E3293)],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Save Address',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                height: 1.5,
                letterSpacing: -0.5,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    final minorPaint = Paint()
      ..color = const Color(0xFFD4E1F7)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minorPaint);
    }
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minorPaint);
    }
    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), roadPaint);
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.65, 0), Offset(size.width * 0.65, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(_MapGridPainter _) => false;
}
