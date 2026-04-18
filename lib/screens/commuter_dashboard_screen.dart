import 'package:flutter/material.dart';
import '../services/gate_service.dart';
import '../models/gate_status.dart';
import '../widgets/gate_status_card.dart';
import '../widgets/offline_banner.dart';
import '../widgets/app_logo.dart';
import '../theme/app_theme.dart';
import 'pin_entry_screen.dart';

class CommuterDashboardScreen extends StatefulWidget {
  const CommuterDashboardScreen({super.key});

  @override
  State<CommuterDashboardScreen> createState() => _CommuterDashboardScreenState();
}

class _CommuterDashboardScreenState extends State<CommuterDashboardScreen> {
  final GateService _gateService = GateService();

  void _handleAdminTrigger() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PinEntryScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Connection Stream hooking into Offline Banner constraint
            StreamBuilder<bool>(
              stream: _gateService.connectionStream,
              initialData: true, // Prevents artifact flash on immediate build
              builder: (context, snapshot) {
                final isConnected = snapshot.data ?? false;
                return OfflineBanner(isOffline: !isConnected);
              },
            ),
            
            // Custom App Bar strictly matching Ui_Design.md
            Container(
              height: 56.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppTheme.borderDefault, width: 1)),
              ),
              child: Row(
                children: [
                  AppLogo(onAdminTrigger: _handleAdminTrigger),
                  Expanded(
                    child: Text(
                      "Raiwala Crossing",
                      style: AppTheme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    width: 64, // Mirrors logo width to lock title perfectly centered
                    child: Center(
                      child: Icon(Icons.notifications_outlined, size: 24, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            
            // Scrollable Master Layout
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppTheme.spacing16,
                  right: AppTheme.spacing16,
                  top: AppTheme.spacing16,
                  bottom: AppTheme.spacing24,
                ),
                child: StreamBuilder<GateStatusModel?>(
                  stream: _gateService.statusStream,
                  builder: (context, snapshot) {
                    return GateStatusCard(statusModel: snapshot.data);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
