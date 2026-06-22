import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class OrderTrackingNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const _channelId = 'order_tracking';
  static const _channelName = 'Order Tracking';

  // Separate high-importance channel for promotional/campaign pushes so they
  // alert (sound + heads-up) instead of the silent order-tracking channel.
  static const _campaignChannelId = 'campaign_promotions';
  static const _campaignChannelName = 'Offers & Updates';

  // Set by FCMService after router is ready so taps can navigate.
  static void Function(String orderId)? onNotificationTapped;
  // campaignId, actionUrl
  static void Function(String campaignId, String actionUrl)? onCampaignTapped;

  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onTap,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: 'Live updates while your order is on its way',
            importance: Importance.low,
            playSound: false,
            enableVibration: false,
          ),
        );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _campaignChannelId,
            _campaignChannelName,
            description: 'Offers, rewards and announcements',
            importance: Importance.high,
          ),
        );

    _initialized = true;
  }

  static void _onTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;
    // Campaign payloads are encoded as "campaign|<campaignId>|<actionUrl>".
    if (payload.startsWith('campaign|')) {
      final parts = payload.split('|');
      final campaignId = parts.length > 1 ? parts[1] : '';
      final actionUrl = parts.length > 2 ? parts.sublist(2).join('|') : '';
      onCampaignTapped?.call(campaignId, actionUrl);
      return;
    }
    onNotificationTapped?.call(payload);
  }

  /// Show a one-off promotional/campaign notification (foreground display).
  static Future<void> showCampaign({
    required String title,
    required String body,
    String campaignId = '',
    String actionUrl = '',
  }) async {
    await initialize();

    final notifId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    final androidDetails = AndroidNotificationDetails(
      _campaignChannelId,
      _campaignChannelName,
      channelDescription: 'Offers, rewards and announcements',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(body, contentTitle: title),
      ticker: title,
    );

    await _plugin.show(
      notifId,
      title,
      body,
      NotificationDetails(android: androidDetails),
      payload: 'campaign|$campaignId|$actionUrl',
    );
  }

  static Future<void> showOrUpdate({
    required String orderId,
    required String orderNumber,
    required String status,
  }) async {
    await initialize();

    final (step, label) = _statusToStep(status);

    if (step == -1) {
      await dismiss(orderId);
      return;
    }

    const maxProgress = 3;
    final notifId = orderId.hashCode.abs() % 100000;

    final body = _buildProgressText(step);

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Live updates while your order is on its way',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: maxProgress,
      progress: step,
      indeterminate: false,
      playSound: false,
      enableVibration: false,
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: 'Order #$orderNumber',
        summaryText: label,
      ),
      ticker: label,
    );

    await _plugin.show(
      notifId,
      'Order #$orderNumber',
      label,
      NotificationDetails(android: androidDetails),
      payload: orderId,
    );
  }

  static Future<void> dismiss(String orderId) async {
    await _plugin.cancel(orderId.hashCode.abs() % 100000);
  }

  static (int step, String label) _statusToStep(String status) {
    return switch (status) {
      'pending' => (0, 'Order placed, waiting for confirmation...'),
      'confirmed' || 'preparing' || 'assigned' || 'ready_for_pickup' =>
        (1, 'Restaurant is preparing your order'),
      'picked_up' || 'on_way' => (2, 'Rider is on the way to you'),
      'delivered' => (3, 'Your order has been delivered!'),
      'cancelled' || 'rejected' || 'refunded' => (-1, ''),
      _ => (0, 'Processing your order...'),
    };
  }

  static String _buildProgressText(int step) {
    const steps = ['Order Placed', 'Preparing', 'On the Way', 'Delivered'];
    final parts = <String>[];
    for (int i = 0; i < steps.length; i++) {
      if (i < step) {
        parts.add('✓ ${steps[i]}');
      } else if (i == step) {
        parts.add('● ${steps[i]}');
      } else {
        parts.add('○ ${steps[i]}');
      }
    }
    return parts.join('  →  ');
  }
}
