import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'config/firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

// ── 6 Notification Channels (Status × Language) ────────────────────────────
// Each channel binds to its own raw .wav file in android/app/src/main/res/raw/

const _channels = <AndroidNotificationChannel>[
  AndroidNotificationChannel(
    'alert_hi',
    'Train Alert (Hindi)',
    description: 'Voice alert in Hindi when a train is approaching',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('alert_hi'),
    playSound: true,
  ),
  AndroidNotificationChannel(
    'alert_en',
    'Train Alert (English)',
    description: 'Voice alert in English when a train is approaching',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('alert_en'),
    playSound: true,
  ),
  AndroidNotificationChannel(
    'closed_hi',
    'Gate Closed (Hindi)',
    description: 'Voice announcement in Hindi when gate closes',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('closed_hi'),
    playSound: true,
  ),
  AndroidNotificationChannel(
    'closed_en',
    'Gate Closed (English)',
    description: 'Voice announcement in English when gate closes',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('closed_en'),
    playSound: true,
  ),
  AndroidNotificationChannel(
    'open_hi',
    'Gate Opened (Hindi)',
    description: 'Voice announcement in Hindi when gate opens',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('open_hi'),
    playSound: true,
  ),
  AndroidNotificationChannel(
    'open_en',
    'Gate Opened (English)',
    description: 'Voice announcement in English when gate opens',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('open_en'),
    playSound: true,
  ),
];

// ── Shared helper: fire local notification using correct channel ───────────
// This runs in BOTH foreground and background contexts.
Future<void> _showLocalNotification(
  FlutterLocalNotificationsPlugin plugin, {
  required String status,
  required String lang,
}) async {
  // Derive channel ID from status + language
  final String channelId;
  final String title;
  final String body;

  final bool isHindi = lang == 'hi';

  switch (status.toUpperCase()) {
    case 'ALERT':
      channelId = isHindi ? 'alert_hi' : 'alert_en';
      title = isHindi ? '⚠ ट्रेन आ रही है' : '⚠ Train Approaching';
      body = isHindi
          ? 'रायवाला फाटक जल्द बंद होगा — अपना रास्ता चुनें'
          : 'Raiwala crossing closing soon — plan your route';
    case 'CLOSED':
      channelId = isHindi ? 'closed_hi' : 'closed_en';
      title = isHindi ? '🚧 गेट बंद हो गया' : '🚧 Gate Closed';
      body = isHindi
          ? 'प्रतीक्षा करें या वैकल्पिक रास्ता लें'
          : 'Wait or take an alternate route';
    default: // OPEN
      channelId = isHindi ? 'open_hi' : 'open_en';
      title = isHindi ? '✅ गेट खुल गया' : '✅ Gate Opened';
      body = isHindi
          ? 'सड़क साफ़ है — सामान्य रूप से आगे बढ़ें'
          : 'Road is clear — proceed normally';
  }

  await plugin.show(
    id: status.hashCode,
    title: title,
    body: body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelId,
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(channelId),
        playSound: true,
      ),
    ),
  );
}

// ── Background message handler (runs in isolated Dart context) ─────────────
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Step 1: Bootstrap Firebase (MANDATORY in background isolate)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('[BG] Background message received: ${message.messageId}');
  debugPrint('[BG] Data payload: ${message.data}');

  // Step 2: Only act on our status data messages (ignore notification-only messages)
  final String? status = message.data['status'] as String?;
  if (status == null || status.isEmpty) {
    debugPrint('[BG] No status in payload — skipping local notification.');
    return;
  }

  // Step 3: Re-initialize SharedPreferences in this isolate to read saved language
  final prefs = await SharedPreferences.getInstance();
  final String lang = prefs.getString('selected_language') ?? 'en';
  debugPrint('[BG] Resolved language: $lang for status: $status');

  // Step 4: Re-initialize flutter_local_notifications in this isolate
  final plugin = FlutterLocalNotificationsPlugin();
  const initSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  await plugin.initialize(settings: initSettings);

  // Step 5: Fire the correct localized voice notification
  await _showLocalNotification(plugin, status: status, lang: lang);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ── Register background handler BEFORE any other FCM setup ────────────────
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ── Create all 6 notification channels on Android ─────────────────────────
  final plugin = FlutterLocalNotificationsPlugin();
  final androidImpl = plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  if (androidImpl != null) {
    for (final channel in _channels) {
      await androidImpl.createNotificationChannel(channel);
      debugPrint('[main] Created notification channel: ${channel.id}');
    }
  }

  // ── Initialize plugin for foreground use ──────────────────────────────────
  const initSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  await plugin.initialize(settings: initSettings);

  // ── Foreground FCM: intercept data-only messages and show local notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint('[FG] Foreground message: ${message.data}');
    final String? status = message.data['status'] as String?;
    if (status == null || status.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final String lang = prefs.getString('selected_language') ?? 'en';

    await _showLocalNotification(plugin, status: status, lang: lang);
  });

  // ── Firebase infrastructure ────────────────────────────────────────────────
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // ignore: unused_local_variable
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  runApp(const RailAlertApp());
}

class RailAlertApp extends StatelessWidget {
  const RailAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RailAlert',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const SplashScreen(),
    );
  }
}
