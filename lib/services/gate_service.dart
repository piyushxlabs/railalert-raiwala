import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import '../models/gate_status.dart';
import '../config/app_constants.dart';
import 'notification_service.dart';

class GateService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final NotificationService _notificationService = NotificationService();

  Stream<GateStatusModel?> get statusStream {
    final statusRef = _db.ref(AppConstants.databaseNodeGateStatus);
    final configRef = _db.ref(AppConstants.databaseNodeAppConfig);

    final statusStream = statusRef.onValue.map((event) => event.snapshot.value as Map<dynamic, dynamic>?);
    final configStream = configRef.onValue.map((event) => event.snapshot.value as Map<dynamic, dynamic>?);

    return Rx.combineLatest2(statusStream, configStream, (statusData, configData) {
      if (statusData == null) return null;
      
      bool gatemanActive = true;
      if (configData != null && configData['gateman_active'] != null) {
        gatemanActive = configData['gateman_active'] == true;
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

      // Spark Plan Client-Side Validation Logic
      bool isValid = false;
      if (currentStatus == GateStatus.open && newStatus == GateStatus.alert) isValid = true;
      if (currentStatus == GateStatus.alert && newStatus == GateStatus.closed) isValid = true;
      if (currentStatus == GateStatus.closed && newStatus == GateStatus.open) isValid = true;

      if (!isValid && currentStatus != newStatus) {
        throw Exception("Invalid state transition from $currentStatus to $newStatus.");
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
