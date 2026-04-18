import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../config/app_constants.dart';

class AppLogo extends StatefulWidget {
  final VoidCallback onAdminTrigger;

  const AppLogo({
    super.key,
    required this.onAdminTrigger,
  });

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _handleTap() {
    final now = DateTime.now();

    if (_lastTapTime != null) {
      final difference = now.difference(_lastTapTime!);
      if (difference.inMilliseconds > AppConstants.adminTapWindowMs) {
        // Reset counter if tap exceeds the window gap
        _tapCount = 0;
      }
    }

    _lastTapTime = now;
    _tapCount++;

    if (_tapCount >= AppConstants.adminTapCountThreshold) {
      _tapCount = 0; // Reset before triggering to prevent double-fire
      widget.onAdminTrigger();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 64x64px visible UI wrapped in an 88x88px invisible touch layer
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        // Padding provides the requested invisible expanded touch area 
        // 88 - 64 = 24 / 2 = 12 on all sides
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: 64.0,
          height: 64.0,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.directions_railway, // Locomotive design
            color: AppTheme.primary,
            size: 32.0,
          ),
        ),
      ),
    );
  }
}
