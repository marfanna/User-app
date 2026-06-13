import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../models/notification_model.dart';


class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.read;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isUnread
              ? Border.all(color: const Color(0xFF0156A7).withValues(alpha: 0.2))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon avatar
            _NotificationAvatar(type: notification.type),
            const Gap(12),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            height: 1.7,
                            color: Color(0xFF363A33),
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 6, top: 4),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0156A7),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const Gap(2),
                  Text(
                    notification.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 1.6,
                      color: Color(0xFF60655C),
                    ),
                  ),
                  const Gap(4),
                  Text(
                    notification.timeAgo,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.7,
                      color: Color(0xFF60655C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Avatar: circular icon that changes by notification type
// ---------------------------------------------------------------------------

class _NotificationAvatar extends StatelessWidget {
  const _NotificationAvatar({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      'delivery' => Icons.delivery_dining_rounded,
      'promotion' || 'offer' => Icons.local_offer_rounded,
      'payment' => Icons.payment_rounded,
      'system' => Icons.info_outline_rounded,
      _ => Icons.receipt_long_rounded, // order + default
    };

    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFFE6EFFC),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color(0xFF0156A7), size: 22),
    );
  }
}

// ---------------------------------------------------------------------------
// Skeleton tile for loading state
// ---------------------------------------------------------------------------

class NotificationTileSkeleton extends StatelessWidget {
  const NotificationTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bone(48, 48, radius: 24),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bone(double.infinity, 16),
                const Gap(6),
                _bone(double.infinity, 12),
                const Gap(4),
                _bone(80, 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bone(double w, double h, {double radius = 4}) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
