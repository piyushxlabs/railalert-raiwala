import 'package:flutter/material.dart';
import '../config/session_manager.dart';
import '../theme/app_theme.dart';
import 'admin_screen.dart';
import 'commuter_dashboard_screen.dart';
import 'disclaimer_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();

    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    // Wait for the splash to be fully visible before checking session
    await Future.delayed(const Duration(milliseconds: 3500));

    if (!mounted) return;

    final gatemanLoggedIn = await SessionManager.isGatemanLoggedIn();
    final hasAcceptedTC = await SessionManager.hasAcceptedTC();

    if (!mounted) return;

    Widget destination;
    if (gatemanLoggedIn) {
      destination = const AdminScreen();
    } else if (hasAcceptedTC) {
      destination = const CommuterDashboardScreen();
    } else {
      destination = const DisclaimerScreen();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, _, _) => destination,
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              // Top spacer
              const Spacer(flex: 3),

              // Logo + Branding
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo circle
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.directions_railway_rounded,
                        color: AppTheme.primary,
                        size: 56,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // App Name
                  Text(
                    'RailAlert',
                    style: AppTheme.textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),

                  // Subtitle
                  Text(
                    'Raiwala Crossing',
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Loading indicator
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.7)),
                ),
              ),

              const SizedBox(height: AppTheme.spacing48),

              // Footer
              Text(
                'Powered by Piyush',
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.55),
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: AppTheme.spacing32),
            ],
          ),
        ),
      ),
    ),
  );
}
}
