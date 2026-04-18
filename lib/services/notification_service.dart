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
    if (Secrets.fcmServerKey == "REPLACE_WITH_REAL_KEY" || Secrets.fcmServerKey.isEmpty) {
      debugPrint("FCM Server Key not configured, skipping HTTP push delivery.");
      return;
    }

    String title;
    String body;
    if (newStatus == GateStatus.alert) {
      title = "⚠️ Raiwala Gate — Train Coming";
      body = "Gate closing soon. Plan your route now.";
    } else if (newStatus == GateStatus.closed) {
      title = "🔴 Raiwala Gate Closed";
      body = "Gate is closed. Expect delays.";
    } else {
      title = "🟢 Raiwala Gate Open";
      body = "Gate is open. You can proceed.";
    }

    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=${Secrets.fcmServerKey}',
        },
        body: jsonEncode({
          'to': '/topics/${AppConstants.fcmTopicGateStatus}',
          'notification': {
            'title': title,
            'body': body,
          },
          'priority': 'high'
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("FCM successfully sent from client.");
      } else {
        debugPrint("Failed to send FCM: Code ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      debugPrint("FCM REST exception: $e");
    }
  }
}
