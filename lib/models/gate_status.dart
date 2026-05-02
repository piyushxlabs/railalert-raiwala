enum GateStatus { open, alert, closed }

class GateStatusModel {
  final GateStatus status;
  final DateTime updatedAt;
  final bool gatemanActive;

  GateStatusModel({
    required this.status,
    required this.updatedAt,
    this.gatemanActive = true,
  });

  factory GateStatusModel.fromJson(Map<dynamic, dynamic> statusJson, {bool isGatemanActive = true}) {
    GateStatus parsedStatus = GateStatus.open;
    final statusStr = (statusJson['status'] as String?)?.toLowerCase();
    if (statusStr == 'alert') parsedStatus = GateStatus.alert;
    if (statusStr == 'closed') parsedStatus = GateStatus.closed;

    final timestamp = statusJson['updated_at'] as int?;
    final updatedAt = timestamp != null 
        ? DateTime.fromMillisecondsSinceEpoch(timestamp) 
        : DateTime.now();

    return GateStatusModel(
      status: parsedStatus,
      updatedAt: updatedAt,
      gatemanActive: isGatemanActive,
    );
  }

  String get relativeTimeLabel {
    final diff = DateTime.now().difference(updatedAt);
    if (diff.inMinutes < 1) return "Updated just now";
    if (diff.inMinutes < 60) return "Updated ${diff.inMinutes} min ago";
    return "Updated ${updatedAt.hour.toString().padLeft(2, '0')}:${updatedAt.minute.toString().padLeft(2, '0')}";
  }
}
