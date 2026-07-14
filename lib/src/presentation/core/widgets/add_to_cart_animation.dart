import 'package:flutter/material.dart';

/// "Fly to cart" feedback: a copy of [image] (or [fallbackIcon] if there's
/// no image) animates from [startCenter] to wherever the widget behind
/// [cartKey] currently sits on screen, shrinking + fading as it lands.
///
/// Reads the cart target's real on-screen position via [cartKey] instead of
/// hardcoding an end offset — this is what lets one implementation serve
/// screens with different bottom-bar layouts (product detail pages with a
/// persistent bottom bar vs. plain grid screens) without per-screen tuning.
/// No-ops if [cartKey] isn't currently mounted (e.g. the target FAB is
/// hidden because the cart was empty before this add).
void runAddToCartAnimation({
  required BuildContext context,
  required GlobalKey cartKey,
  required Offset startCenter,
  String? image,
  IconData fallbackIcon = Icons.shopping_bag_outlined,
  double startSize = 140,
}) {
  final cartRenderObject = cartKey.currentContext?.findRenderObject();
  if (cartRenderObject is! RenderBox || !cartRenderObject.attached) return;

  final overlayState = Overlay.of(context);
  final cartCenter = cartRenderObject.localToGlobal(
    cartRenderObject.size.center(Offset.zero),
  );
  final endSize = cartRenderObject.size.shortestSide;

  final startLeft = startCenter.dx - startSize / 2;
  final startTop = startCenter.dy - startSize / 2;
  final endLeft = cartCenter.dx - endSize / 2;
  final endTop = cartCenter.dy - endSize / 2;

  OverlayEntry? entry;
  entry = OverlayEntry(
    builder: (context) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
        onEnd: () => entry?.remove(),
        builder: (context, value, child) {
          final currentSize = startSize + (endSize - startSize) * value;
          final top = startTop + (endTop - startTop) * value;
          final left = startLeft + (endLeft - startLeft) * value;
          final opacity = value > 0.85 ? 1.0 - (value - 0.85) / 0.15 : 1.0;
          return Positioned(
            top: top,
            left: left,
            child: Opacity(
              opacity: opacity,
              child: Container(
                width: currentSize,
                height: currentSize,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(currentSize / 2),
                  child: image != null && image.isNotEmpty
                      ? Image.network(image, fit: BoxFit.cover)
                      : Icon(fallbackIcon, color: const Color(0xFFC0C0C0)),
                ),
              ),
            ),
          );
        },
      );
    },
  );

  overlayState.insert(entry);
}
