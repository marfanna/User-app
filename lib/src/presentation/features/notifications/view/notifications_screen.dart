import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../riverpod/notifications_provider.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch on first mount
    Future.microtask(() {
      ref.read(notificationsProvider.notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsProvider);
    final unread = state.unreadCount;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              _buildHeader(context, unread),

              // ── Content ─────────────────────────────────────────────────
              Expanded(child: _buildBody(state)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, int unread) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          const RoundedBackButton.primary(),
          const Gap(16),
          Expanded(
            child: Text(
              unread > 0 ? 'Notifications ($unread)' : 'Notifications',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                height: 1.28,
                color: Color(0xFF040707),
              ),
            ),
          ),
          // Mark all read button
          if (unread > 0)
            GestureDetector(
              onTap: () =>
                  ref.read(notificationsProvider.notifier).markAllRead(),
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Color(0xFF0156A7),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody(NotificationsState state) {
    if (state.isLoading) return _buildSkeleton();

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Color(0xFFD0D0D0)),
            const Gap(12),
            const Text(
              'Failed to load notifications',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: Color(0xFF737780),
              ),
            ),
            const Gap(12),
            GestureDetector(
              onTap: () => ref.read(notificationsProvider.notifier).fetch(),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF0156A7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.notifications.isEmpty) return _buildEmpty();

    return RefreshIndicator(
      color: const Color(0xFF0156A7),
      onRefresh: () => ref.read(notificationsProvider.notifier).fetch(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: state.notifications.length,
        separatorBuilder: (_, _) => const Gap(10),
        itemBuilder: (_, i) {
          final notif = state.notifications[i];
          return NotificationTile(
            notification: notif,
            onTap: () {
              // Mark as read on tap
              if (!notif.read) {
                ref.read(notificationsProvider.notifier).markRead(notif.id);
              }
              // Navigate to order if applicable
              if (notif.orderId != null && notif.orderId!.isNotEmpty) {
                context.pushNamed(
                  Routes.trackOrder,
                  pathParameters: {'id': notif.orderId!},
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFE6EFFC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 40,
              color: Color(0xFF0156A7),
            ),
          ),
          const Gap(16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF363A33),
            ),
          ),
          const Gap(6),
          const Text(
            'You\'re all caught up! Order updates\nwill appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              height: 1.6,
              color: Color(0xFF60655C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: 5,
      separatorBuilder: (_, _) => const Gap(10),
      itemBuilder: (_, _) => const NotificationTileSkeleton(),
    );
  }
}
