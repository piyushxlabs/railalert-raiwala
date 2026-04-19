import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/session_manager.dart';
import '../models/gate_status.dart';
import '../services/gate_service.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_action_button.dart';
import '../widgets/status_snackbar.dart';
import 'commuter_dashboard_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GateService _gateService = GateService();

  // Simple loading flag — no optimistic status.
  // The UI is 100% driven by the Firebase stream via StreamBuilder.
  bool _isLoading = false;

  Future<void> _handleLogout() async {
    await SessionManager.setGatemanLoggedIn(false);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const CommuterDashboardScreen()),
      (route) => false,
    );
  }

  Future<void> _handleAction(GateStatus targetStatus) async {
    // Convert enum to the capitalized display string for the snackbar
    final String nextLabel;
    switch (targetStatus) {
      case GateStatus.open:
        nextLabel = "GATE OPEN";
        break;
      case GateStatus.alert:
        nextLabel = "TRAIN COMING";
        break;
      case GateStatus.closed:
        nextLabel = "GATE CLOSED";
        break;
    }

    setState(() => _isLoading = true);

    try {
      await _gateService.updateStatus(targetStatus);
      if (mounted) {
        StatusSnackbar.showSuccess(context, "Status updated to $nextLabel");
      }
    } catch (e) {
      if (mounted) {
        StatusSnackbar.showError(context, "Update failed — tap again to retry");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _colorForStatus(GateStatus status) {
    switch (status) {
      case GateStatus.open:
        return AppTheme.success;
      case GateStatus.alert:
        return AppTheme.warning;
      case GateStatus.closed:
        return AppTheme.danger;
    }
  }

  String _labelForStatus(GateStatus status) {
    switch (status) {
      case GateStatus.open:
        return "GATE OPEN";
      case GateStatus.alert:
        return "TRAIN COMING (ALERT)";
      case GateStatus.closed:
        return "GATE CLOSED";
    }
  }


  Widget _buildStatusOption({required GateStatus targetStatus, required GateStatus currentStatus}) {
    final bool isCurrent = targetStatus == currentStatus;
    
    return Opacity(
      opacity: isCurrent ? 0.4 : 1.0,
      child: AdminActionButton(
        targetStatus: targetStatus,
        isLoading: _isLoading && !isCurrent, // Only show loader on the target button
        // Disable tap if it's already the current state, or if another state is loading
        onPressed: (isCurrent || _isLoading)
            ? null
            : () {
                HapticFeedback.heavyImpact();
                _handleAction(targetStatus);
              },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Log Out',
            icon: const Icon(Icons.logout_rounded, color: AppTheme.textSecondary),
            onPressed: _handleLogout,
          ),
        ],
      ),
      // StreamBuilder is the SOLE source of truth for the UI state.
      // No local status variable. No optimistic updates.
      body: StreamBuilder<GateStatusModel?>(
        stream: _gateService.statusStream,
        builder: (context, snapshot) {
          // While waiting for first Firebase emission, show a loader
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentStatus = snapshot.data?.status ?? GateStatus.open;
          final statusColor = _colorForStatus(currentStatus);
          final statusLabel = _labelForStatus(currentStatus);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing24,
                vertical: AppTheme.spacing32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Gateman Control",
                    style: AppTheme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppTheme.spacing8),

                  // Current status badge — driven 100% by stream
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing12,
                          vertical: AppTheme.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: AppTheme.borderRadiusSmall,
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 8, color: statusColor),
                            const SizedBox(width: AppTheme.spacing8),
                            Text(
                              "Current: $statusLabel",
                              style: AppTheme.textTheme.labelSmall?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Action buttons — Free selection of any state
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatusOption(
                              targetStatus: GateStatus.alert,
                              currentStatus: currentStatus,
                            ),
                            const SizedBox(height: 16.0),
                            _buildStatusOption(
                              targetStatus: GateStatus.closed,
                              currentStatus: currentStatus,
                            ),
                            const SizedBox(height: 16.0),
                            _buildStatusOption(
                              targetStatus: GateStatus.open,
                              currentStatus: currentStatus,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Exit button
                  Center(
                    child: TextButton(
                      onPressed: _handleLogout,
                      child: Text(
                        "Exit Admin",
                        style: AppTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
