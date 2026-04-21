import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';
import '../config/secrets.dart';
import '../models/gate_status.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    try {
      NotificationSettings settings = await _fcm.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await _fcm.subscribeToTopic(AppConstants.fcmTopicGateStatus);
        debugPrint("Subscribed to FCM topic: ${AppConstants.fcmTopicGateStatus}");
      } else {
        debugPrint("FCM Permission denied/ignored");
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Foreground messages: We rely on the DB Realtime listeners for data updates.
        // Step 17 will introduce StatusSnackbar to hook into this foreground UI later.
        debugPrint("Foreground message received: ${message.notification?.title}");
      });
    } catch (e) {
      debugPrint("Error initializing FCM: $e");
    }
  }

  Future<void> sendDirectPushNotification(GateStatus newStatus) async {
    // Guard: skip if secret key is unconfigured (dev environment)
    if (Secrets.vercelSecretKey == 'REPLACE_WITH_VERCEL_SECRET_KEY' ||
        Secrets.vercelSecretKey.isEmpty) {
      debugPrint('[NotificationService] Vercel secret not configured — skipping push.');
      return;
    }

    // Convert enum to the string the Vercel backend expects
    final String statusStr;
    if (newStatus == GateStatus.alert) {
      statusStr = 'ALERT';
    } else if (newStatus == GateStatus.closed) {
      statusStr = 'CLOSED';
    } else {
      statusStr = 'OPEN';
    }

    // Fire-and-forget: UI must never block or crash on notification failure
    try {
      final response = await http.post(
        Uri.parse(AppConstants.vercelNotifyUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'newStatus': statusStr,
          'secret_key': Secrets.vercelSecretKey,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('[NotificationService] Vercel FCM dispatch OK for status=$statusStr');
      } else {
        debugPrint(
          '[NotificationService] Vercel responded ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      // Never rethrow — a notification failure must not affect gate status UX
      debugPrint('[NotificationService] Vercel POST exception: $e');
    }
  }
}
