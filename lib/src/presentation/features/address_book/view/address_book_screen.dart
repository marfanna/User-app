import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/app_bar/duare_app_bar.dart';
import '../riverpod/address_book_provider.dart';

class AddressBookScreen extends ConsumerWidget {
  const AddressBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressBookProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DuareAppBar(title: 'Delivery Address'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const Gap(16),
                      _buildAddAddressButton(context),
                      const Gap(32),
                      addressState.when(
                        data: (data) {
                          if (data.addresses.isEmpty) {
                            return const Center(child: Text('No addresses found'));
                          }
                          final selectedIndex = ref.watch(selectedAddressIndexProvider)
                              ?? data.defaultAddressIndex;

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.addresses.length,
                            separatorBuilder: (_, _) => const Gap(24),
                            itemBuilder: (context, index) {
                              final address = data.addresses[index];
                              final isDefault = index == data.defaultAddressIndex;
                              final isSelected = index == selectedIndex;
                              final title = [address.street, address.city]
                                  .where((s) => s.isNotEmpty).join(', ');
                              final subtitle = [address.district, address.division]
                                  .where((s) => s.isNotEmpty).join(', ');

                              final type = address.label ?? address.type ?? 'Home';
                              
                              return _buildAddressCard(
                                type: type,
                                title: title.isNotEmpty ? title : 'My Address',
                                subtitle: subtitle,
                                isDefault: isDefault,
                                isSelected: isSelected,
                                onTap: () {
                                  ref
                                      .read(
                                        selectedAddressIndexProvider.notifier,
                                      )
                                      .set(index);
                                  context.pop();
                                },
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(child: Text('Error: $error')),
                      ),
                      const Gap(32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddAddressButton(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(
        color: const Color(0xFF0156A7),
        strokeWidth: 1,
        gap: 5,
        radius: 6,
      ),
      child: Container(
        height: 114,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.66),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => context.push(Routes.addAddress),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Color(0xFF0156A7), size: 24),
                Gap(10),
                Text(
                  'Add Address',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: -0.5,
                    color: Color(0xFF0156A7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard({
    required String type,
    required String title,
    required String subtitle,
    required bool isDefault,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? const Color(0xFF0156A7) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: title,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF040707),
                          ),
                          children: [
                            if (isDefault)
                              const TextSpan(
                                text: ' (Default)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xFFA0A4AD),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: Color(0xFF0156A7), size: 22)
                    else
                      const Icon(Icons.radio_button_unchecked, color: Color(0xFFD2D3D6), size: 22),
                  ],
                ),
                if (subtitle.isNotEmpty) ...[
                  const Gap(8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: -0.5,
                      color: Color(0xFF737780),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Type badge
          Positioned(
            top: -8,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF0156A7),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                type,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {

  _DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.radius,
  });
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + gap),
          dashedPaint,
        );
        distance += gap * 2;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
