import 'package:flutter/material.dart';
import '../services/gate_service.dart';
import '../models/gate_status.dart';
import '../widgets/gate_status_card.dart';
import '../widgets/offline_banner.dart';
import '../widgets/app_logo.dart';
import '../theme/app_theme.dart';
import 'pin_entry_screen.dart';
import 'developer_profile_screen.dart';

class CommuterDashboardScreen extends StatefulWidget {
  const CommuterDashboardScreen({super.key});

  @override
  State<CommuterDashboardScreen> createState() => _CommuterDashboardScreenState();
}

class _CommuterDashboardScreenState extends State<CommuterDashboardScreen>
    with TickerProviderStateMixin {
  final GateService _gateService = GateService();

  // Breathing animation for the Developer Card
  late AnimationController _breathController;
  late Animation<double> _breathAnim;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _breathAnim = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

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
            
            // Developer Profile Card Footer — breathing animation
            ScaleTransition(
              scale: _breathAnim,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                  vertical: AppTheme.spacing8,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const DeveloperProfileScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE65100), Color(0xFFBF360C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE65100).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Profile avatar with white border
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage('assets/images/piyush.jpg'),
                            backgroundColor: Color(0xFFFBE9E7),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Text block
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Meet the Developer 👋',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Made with ❤️ for Raiwala',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xD9FFFFFF), // 85% white
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Say Hi pill button
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Say Hi ➔',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
          ],
        ),
      ),
    );
  }
}
