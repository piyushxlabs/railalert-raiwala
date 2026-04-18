import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOffline;

  const OfflineBanner({
    super.key,
    required this.isOffline,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isOffline ? 36.0 : 0.0,
      width: double.infinity,
      color: AppTheme.offlineBannerBg,
      // Wrap content in SingleChildScrollView to prevent overflow exceptions
      // while the height shrinks to 0.0 during the animation.
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: 36.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 16.0,
                color: AppTheme.offlineBannerText,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                "Offline — showing last known status",
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.offlineBannerText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
