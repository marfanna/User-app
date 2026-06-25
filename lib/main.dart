import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/gen/l10n/app_localizations.dart';
import 'src/core/logger/riverpod_log.dart';
import 'src/presentation/core/application_state/localization_provider/localization_provider.dart';
import 'src/presentation/core/router/router.dart';
import 'src/presentation/core/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'src/core/services/fcm_service.dart';
import 'src/core/services/order_tracking_notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await OrderTrackingNotificationService.initialize();

  final data = message.data;
  final type = data['type'] as String?;
  if (type == 'order_updated' || type == 'order_assigned') {
    final orderId = data['order_id'] as String?;
    final orderNumber = data['orderNumber'] as String? ?? orderId ?? '';
    final status = data['status'] as String? ??
        (type == 'order_assigned' ? 'assigned' : '');
    if (orderId != null && status.isNotEmpty) {
      await OrderTrackingNotificationService.showOrUpdate(
        orderId: orderId,
        orderNumber: orderNumber,
        status: status,
        shopName: data['shopName'] as String?,
        etaText: data['eta'] as String?,
        riderName: data['riderName'] as String?,
        riderPhone: data['riderPhone'] as String?,
      );
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    ProviderScope(
      observers: [RiverpodObserver()],
      retry: (retryCount, error) => null,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize FCM to get token and listen to token refreshes
    Future.microtask(() {
      ref.read(fcmServiceProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.5,
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: ref.watch(localizationProvider),
        theme: context.lightTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        routerConfig: ref.read(goRouterProvider),
      ),
    );
  }
}
