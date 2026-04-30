import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // 64x64px visible UI wrapped in an 88x88px transparent bounds (via padding)
    return Padding(
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
    );
  }
}
