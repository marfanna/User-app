import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../models/notification_model.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class NotificationsState {
  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
  });

  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  int get unreadCount => notifications.where((n) => !n.read).length;
}

// ---------------------------------------------------------------------------
// Notifier (Riverpod 2.x)
// ---------------------------------------------------------------------------

class NotificationsNotifier extends Notifier<NotificationsState> {
  @override
  NotificationsState build() => const NotificationsState();

  Future<void> fetch() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final client = ref.read(restClientServiceProvider);
      final response = await client.getNotifications(50);

      final body = response.data;
      List<dynamic> list = [];

      if (body is List) {
        list = body;
      } else if (body is Map) {
        final data = body['data'];
        if (data is List) list = data;
      }

      final items = list
          .whereType<Map<String, dynamic>>()
          .map(NotificationModel.fromJson)
          .toList();

      state = state.copyWith(notifications: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> markRead(String id) async {
    // Optimistic update
    state = state.copyWith(
      notifications: state.notifications
          .map((n) => n.id == id ? n.copyWith(read: true) : n)
          .toList(),
    );
    try {
      await ref.read(restClientServiceProvider).markNotificationRead(id);
    } catch (_) {
      // Revert on failure
      state = state.copyWith(
        notifications: state.notifications
            .map((n) => n.id == id ? n.copyWith(read: false) : n)
            .toList(),
      );
    }
  }

  Future<void> markAllRead() async {
    // Optimistic update
    state = state.copyWith(
      notifications:
          state.notifications.map((n) => n.copyWith(read: true)).toList(),
    );
    try {
      await ref.read(restClientServiceProvider).markAllNotificationsRead();
    } catch (_) {
      await fetch(); // Re-fetch to restore correct state
    }
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final notificationsProvider =
    NotifierProvider.autoDispose<NotificationsNotifier, NotificationsState>(
  NotificationsNotifier.new,
);
