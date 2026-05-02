import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';
import '../config/secrets.dart';
import '../models/gate_status.dart';

/// NotificationService handles FCM topic subscription and consent logging.
///
/// The actual local notification display logic has been moved to main.dart
/// so it can be shared safely between the foreground (onMessage) and the
/// background isolate (_firebaseMessagingBackgroundHandler).
///
/// This service is intentionally kept lightweight — it does NOT call
/// flutter_local_notifications directly; that runs in main.dart.
class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Request permission and subscribe to the gate-status FCM topic.
  /// Called explicitly after the user accepts the legal disclaimer.
  Future<void> initFCM() async {
    try {
      final NotificationSettings settings = await _fcm.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await _fcm.subscribeToTopic(AppConstants.fcmTopicGateStatus);
        debugPrint('[NotificationService] Subscribed to FCM topic: ${AppConstants.fcmTopicGateStatus}');
      } else {
        debugPrint('[NotificationService] FCM permission denied/ignored by user.');
      }
    } catch (e) {
      debugPrint('[NotificationService] Error in initFCM: $e');
    }
  }

  /// Log FCM consent token to Firebase Realtime Database.
  Future<void> logConsent() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        await FirebaseDatabase.instance.ref().child('consent_logs').push().set({
          'fcm_token': token,
          'agreed_at': ServerValue.timestamp,
          'platform': 'android',
        });
        debugPrint('[NotificationService] Consent logged for FCM token.');
      }
    } catch (e) {
      debugPrint('[NotificationService] Silent fail: Could not log consent — $e');
    }
  }

  /// Trigger a push notification via the Vercel serverless backend.
  /// Vercel now sends a DATA-ONLY payload so the device's local notification
  /// logic (in main.dart) can select the correct language + sound channel.
  Future<void> sendDirectPushNotification(GateStatus newStatus) async {
    // Guard: skip if secret key is unconfigured (dev environment)
    if (Secrets.vercelSecretKey == 'REPLACE_WITH_VERCEL_SECRET_KEY' ||
        Secrets.vercelSecretKey.isEmpty) {
      debugPrint('[NotificationService] Vercel secret not configured — skipping push.');
      return;
    }

    final String statusStr;
    if (newStatus == GateStatus.alert) {
      statusStr = 'ALERT';
    } else if (newStatus == GateStatus.closed) {
      statusStr = 'CLOSED';
    } else {
      statusStr = 'OPEN';
    }

    // Fire-and-forget: notification failure must never block gate status UX
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
        debugPrint('[NotificationService] Vercel FCM dispatch OK — status=$statusStr');
      } else {
        debugPrint('[NotificationService] Vercel ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('[NotificationService] Vercel POST exception: $e');
    }
  }
}
