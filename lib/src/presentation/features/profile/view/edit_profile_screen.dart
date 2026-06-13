import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../core/theme/src/theme_extensions/src/gradients.dart';
import '../riverpod/customer_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _picker = ImagePicker();
  bool _initialized = false;
  bool _saving = false;
  File? _pickedImage;
  String? _uploadedImageUrl;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(customerProfileProvider);

    profileAsync.whenData((profile) {
      if (!_initialized) {
        _nameController.text = profile.name;
        _initialized = true;
      }
    });

    final phone = profileAsync.maybeWhen(
      data: (p) => p.phone.isNotEmpty ? p.phone : '+88 01710 00221144',
      orElse: () => '+88 01710 00221144',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: _buildAvatar()),
                  const Gap(16),
                  Opacity(
                    opacity: 0.4,
                    child: _buildField(
                      label: 'Phone Number',
                      hint: phone,
                      controller: null,
                      readOnly: true,
                    ),
                  ),
                  const Gap(16),
                  _buildField(
                    label: 'Your Name',
                    hint: 'Enter Name',
                    controller: _nameController,
                    readOnly: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildSaveButton(),
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
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Color(0xFF1C1B1F),
                  ),
                ),
              ),
              const Gap(16),
              const Text(
                'Edit Profile',
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

  Future<void> _pickImage() async {
    final xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
    );
    if (xFile == null) return;
    setState(() => _pickedImage = File(xFile.path));
  }

  Widget _buildAvatar() {
    final profileAsync = ref.watch(customerProfileProvider);
    final existingUrl = profileAsync.asData?.value.profileImage;

    Widget photoWidget;
    if (_pickedImage != null) {
      photoWidget = Image.file(_pickedImage!, fit: BoxFit.cover);
    } else if (existingUrl != null && existingUrl.isNotEmpty) {
      photoWidget = Image.network(
        existingUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            const Icon(Icons.person, color: Colors.white, size: 48),
      );
    } else {
      photoWidget = const Icon(Icons.person, color: Colors.white, size: 48);
    }

    return SizedBox(
      width: 114,
      height: 114,
      child: Stack(
        children: [
          Container(
            width: 114,
            height: 114,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xAAFFFFFF),
            ),
            child: ClipOval(child: photoWidget),
          ),
          if (_pickedImage == null)
            Positioned.fill(
              child: CustomPaint(painter: _DashedCirclePainter()),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _saving ? null : _pickImage,
              child: Container(
                width: 41,
                height: 41,
                decoration: const BoxDecoration(
                  color: Color(0xFF0156A7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController? controller,
    required bool readOnly,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF040707),
          ),
        ),
        const Gap(10),
        TextField(
          controller: controller,
          readOnly: readOnly,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
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
      ],
    );
  }

  Widget _buildSaveButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: GestureDetector(
          onTap: _saving ? null : _save,
          child: Container(
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryRadial,
              borderRadius: BorderRadius.circular(4),
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final dio = ref.read(dioProvider);

      // Upload image first if user picked one
      if (_pickedImage != null) {
        final formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            _pickedImage!.path,
            filename: 'profile.jpg',
          ),
          'category': 'profile',
        });
        final uploadRes = await dio.post('upload/single', data: formData);
        final uploadBody = uploadRes.data as Map<String, dynamic>;
        final uploadData = uploadBody['data'] as Map<String, dynamic>?;
        _uploadedImageUrl = uploadData?['url'] as String?;
      }

      // Update profile
      final updatePayload = <String, dynamic>{'name': name};
      if (_uploadedImageUrl != null) {
        updatePayload['profileImage'] = _uploadedImageUrl;
      }
      await dio.put('users/profile/update', data: updatePayload);

      if (mounted) {
        ref.invalidate(customerProfileProvider);
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0156A7)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 1;
    const dashCount = 28;
    const dashAngle = 0.08;
    const gapAngle = (2 * 3.14159265) / dashCount - dashAngle;

    double angle = 0;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        angle,
        dashAngle,
        false,
        paint,
      );
      angle += dashAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter _) => false;
}
