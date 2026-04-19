import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import '../models/gate_status.dart';
import '../config/app_constants.dart';
import 'notification_service.dart';

class GateService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final NotificationService _notificationService = NotificationService();

  Stream<bool> get connectionStream {
    return _db.ref('.info/connected').onValue.map((event) => event.snapshot.value == true);
  }

  Stream<GateStatusModel?> get statusStream {
    final statusRef = _db.ref(AppConstants.databaseNodeGateStatus);
    final configRef = _db.ref(AppConstants.databaseNodeAppConfig);

    final statusStream = statusRef.onValue.map(
      (event) => event.snapshot.value as Map<dynamic, dynamic>?,
    );

    // startWith(null) is CRITICAL: if /app_config node does not exist in Firebase,
    // the configStream never emits — and combineLatest2 blocks forever, causing
    // the blank grey dashboard bug. startWith(null) makes it emit immediately so
    // combineLatest2 can fire as soon as statusStream delivers its first value.
    final configStream = configRef.onValue
        .map((event) => event.snapshot.value as Map<dynamic, dynamic>?)
        .startWith(null);

    return Rx.combineLatest2(statusStream, configStream, (statusData, configData) {
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

      return GateStatusModel.fromJson(statusData, isGatemanActive: gatemanActive);
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

      // Trigger temporary FCM Push directly from client due to lack of functions
      await _notificationService.sendDirectPushNotification(newStatus);
      
    } catch (e) {
      debugPrint("GateService updateStatus Error: $e");
      rethrow; // Surges back to UI for StatusSnackbar display
    }
  }
}
