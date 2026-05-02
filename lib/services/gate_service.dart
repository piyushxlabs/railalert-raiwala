import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import '../models/gate_status.dart';
import '../config/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GateService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Stream<bool> get connectionStream {
    return _db.ref('.info/connected').onValue.map((event) => event.snapshot.value == true);
  }

  Stream<GateStatusModel?> get statusStream {
    final statusRef = _db.ref(AppConstants.databaseNodeGateStatus);
    final configRef = _db.ref(AppConstants.databaseNodeAppConfig);

    final statusStream = statusRef.onValue.map((event) {
      try {
        final val = event.snapshot.value;
        if (val is Map) return val;
        return null;
      } catch (e) {
        debugPrint("Error parsing status node: $e");
        return null;
      }
    });

    // startWith(null) makes it emit immediately so combineLatest2 can fire 
    // as soon as statusStream delivers its first value.
    final configStream = configRef.onValue.map((event) {
      try {
        final val = event.snapshot.value;
        if (val is Map) return val;
        return null;
      } catch (e) {
        debugPrint("Error parsing config node: $e");
        return null;
      }
    }).startWith(null);

    return Rx.combineLatest2(statusStream, configStream, (Map? statusData, Map? configData) {
      bool gatemanActive = true;
      if (configData != null && configData['gateman_active'] != null) {
        gatemanActive = configData['gateman_active'] == true;
      }

      // If the Firebase database is completely empty (no /gate_status node),
      // returning null here would cause the Commuter Dashboard to show a
      // shimmering skeleton forever. Instead, seed a default 'OPEN' model locally.
      if (statusData == null) {
        return GateStatusModel(
          status: GateStatus.open,
          updatedAt: DateTime.now(),
          gatemanActive: gatemanActive,
        );
      }

      final safeStatusData = Map<dynamic, dynamic>.from(statusData);
      return GateStatusModel.fromJson(safeStatusData, isGatemanActive: gatemanActive);
    });
  }

  Future<void> updateStatus(GateStatus newStatus) async {
    try {
      final statusRef = _db.ref(AppConstants.databaseNodeGateStatus);
      final snapshot = await statusRef.get();
      
      GateStatus currentStatus = GateStatus.open;
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final str = data['status'] as String?;
        if (str == 'ALERT') currentStatus = GateStatus.alert;
        if (str == 'CLOSED') currentStatus = GateStatus.closed;
      }

      if (currentStatus == newStatus) return; // Prevent duplicate network dispatches

      String statusStr = 'OPEN';
      if (newStatus == GateStatus.alert) statusStr = 'ALERT';
      if (newStatus == GateStatus.closed) statusStr = 'CLOSED';

      final payload = {
        'status': statusStr,
        'updated_at': ServerValue.timestamp,
        'previous_status': currentStatus == GateStatus.open ? 'OPEN' 
            : (currentStatus == GateStatus.alert ? 'ALERT' : 'CLOSED'),
      };

      await statusRef.set(payload);
      
      // Trigger Vercel Notification Serverless Function
      await _triggerVercelNotification(statusStr);
      
    } catch (e) {
      debugPrint("GateService updateStatus Error: $e");
      rethrow; // Surges back to UI for StatusSnackbar display
    }
  }

  Future<void> _triggerVercelNotification(String status) async {
    try {
      final url = Uri.parse('https://project-bwg1z.vercel.app/api/notify');
      final body = jsonEncode({
        "newStatus": status,
        "secret_key": "PiyushRaiwala2026",
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Vercel Notification Sent: ${response.body}");
      } else {
        debugPrint("Vercel Notification Failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      debugPrint("Vercel HTTP call Error: $e");
      // Not rethrowing to prevent app crash if notification fails
    }
  }
}
