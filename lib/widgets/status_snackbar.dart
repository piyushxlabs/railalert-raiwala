import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusSnackbar {
  static void _show(BuildContext context, String message, Color bgColor, IconData icon) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Text(
                message,
                style: AppTheme.textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppTheme.spacing16),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadiusSmall,
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, AppTheme.success, Icons.check_circle_outline);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, AppTheme.danger, Icons.error_outline);
  }
}
