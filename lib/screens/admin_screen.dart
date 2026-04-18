import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/gate_status.dart';
import '../services/gate_service.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_action_button.dart';
import '../widgets/status_snackbar.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GateService _gateService = GateService();
  bool _isLoading = false;

  Future<void> _handleAction(GateStatus currentStatus) async {
    GateStatus nextStatus;
    if (currentStatus == GateStatus.open) {
      nextStatus = GateStatus.alert;
    } else if (currentStatus == GateStatus.alert) {
      nextStatus = GateStatus.closed;
    } else {
      nextStatus = GateStatus.open;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _gateService.updateStatus(nextStatus);
      if (mounted) {
        StatusSnackbar.showSuccess(context, "Status updated to ${nextStatus.name.toUpperCase()}");
      }
    } catch (e) {
      if (mounted) {
        StatusSnackbar.showError(context, "Update failed — tap again to retry");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24, vertical: AppTheme.spacing32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Gateman Control", style: AppTheme.textTheme.headlineLarge),
              const SizedBox(height: AppTheme.spacing8),
              
              StreamBuilder<GateStatusModel?>(
                stream: _gateService.statusStream,
                builder: (context, snapshot) {
                  final status = snapshot.data?.status ?? GateStatus.open;
                  
                  Color statusColor;
                  String label;
                  switch (status) {
                    case GateStatus.open:
                      statusColor = AppTheme.success;
                      label = "GATE OPEN";
                      break;
                    case GateStatus.alert:
                      statusColor = AppTheme.warning;
                      label = "TRAIN COMING (ALERT)";
                      break;
                    case GateStatus.closed:
                      statusColor = AppTheme.danger;
                      label = "GATE CLOSED";
                      break;
                  }

                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12, vertical: AppTheme.spacing4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: AppTheme.borderRadiusSmall,
                          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 8, color: statusColor),
                            const SizedBox(width: AppTheme.spacing8),
                            Text(
                              "Current: $label",
                              style: AppTheme.textTheme.labelSmall?.copyWith(
                                color: statusColor, fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              
              const Spacer(),
              
              StreamBuilder<GateStatusModel?>(
                stream: _gateService.statusStream,
                builder: (context, snapshot) {
                  final currentStatus = snapshot.data?.status ?? GateStatus.open;
                  
                  GateStatus targetButtonStatus;
                  if (currentStatus == GateStatus.open) {
                    targetButtonStatus = GateStatus.alert;
                  } else if (currentStatus == GateStatus.alert) {
                    targetButtonStatus = GateStatus.closed;
                  } else {
                    targetButtonStatus = GateStatus.open;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
                    child: AdminActionButton(
                      targetStatus: targetButtonStatus,
                      isLoading: _isLoading,
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        _handleAction(currentStatus);
                      },
                    ),
                  );
                },
              ),
              
              const Spacer(),
              
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Exit Admin", style: AppTheme.textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
