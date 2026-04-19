import 'package:flutter/material.dart';
import '../models/gate_status.dart';
import '../theme/app_theme.dart';

class AdminActionButton extends StatelessWidget {
  final GateStatus targetStatus;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AdminActionButton({
    super.key,
    required this.targetStatus,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color? rippleColor;
    String label;
    String subLabel;
    IconData iconData;

    // The targetStatus determines the visual color and role of the button
    switch (targetStatus) {
      case GateStatus.alert:
        backgroundColor = AppTheme.warning;
        rippleColor = AppTheme.primaryHover;
        label = "TRAIN COMING";
        subLabel = "Tap when train is ~10 min away";
        iconData = Icons.warning_rounded;
        break;
      case GateStatus.closed:
        backgroundColor = AppTheme.danger;
        rippleColor = Colors.white.withValues(alpha: 0.2); 
        label = "GATE CLOSED";
        subLabel = "Tap when gate is physically closed";
        iconData = Icons.lock_rounded;
        break;
      case GateStatus.open:
        backgroundColor = AppTheme.success;
        rippleColor = Colors.white.withValues(alpha: 0.2); 
        label = "GATE OPENED";
        subLabel = "Tap when gate is open again";
        iconData = Icons.check_circle_rounded;
        break;
    }

    return Opacity(
      opacity: isLoading ? 0.6 : 1.0,
      child: Material(
        color: backgroundColor,
        borderRadius: AppTheme.borderRadiusLarge,
        elevation: 6,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          splashColor: rippleColor,
          highlightColor: rippleColor.withValues(alpha: 0.5),
          borderRadius: AppTheme.borderRadiusLarge,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 100.0),
            padding: const EdgeInsets.all(24.0),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(iconData, size: 36, color: Colors.white),
                          const SizedBox(width: AppTheme.spacing12),
                          Text(
                            label,
                            style: AppTheme.textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        subLabel,
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
