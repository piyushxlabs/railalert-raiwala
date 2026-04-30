import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/gate_status.dart';
import '../theme/app_theme.dart';
import '../services/translation_service.dart';

class GateStatusCard extends StatefulWidget {
  final GateStatusModel? statusModel;

  const GateStatusCard({super.key, required this.statusModel});

  @override
  State<GateStatusCard> createState() => _GateStatusCardState();
}

class _GateStatusCardState extends State<GateStatusCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 1500),
    );
    // scale 1.0 -> 1.08 -> 1.0 loop
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08).chain(CurveTween(curve: Curves.easeOut)), weight: 50.0),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 50.0),
    ]).animate(_pulseController);

    _checkAnimationState();
  }

  @override
  void didUpdateWidget(covariant GateStatusCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkAnimationState();
  }

  void _checkAnimationState() {
    if (widget.statusModel != null && widget.statusModel!.status == GateStatus.alert) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat();
      }
    } else {
      if (_pulseController.isAnimating) {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.statusModel == null) {
      return _buildSkeleton();
    }
    
    if (!widget.statusModel!.gatemanActive) {
      return _buildPausedState();
    }

    return _buildActiveState();
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppTheme.borderDefault,
      highlightColor: AppTheme.pageBackground,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppTheme.borderRadiusLarge,
          border: Border.all(color: AppTheme.borderDefault, width: 2),
        ),
      ),
    );
  }

  Widget _buildPausedState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacing32),
      decoration: BoxDecoration(
        color: AppTheme.pageBackground,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: AppTheme.borderDefault, width: 2),
      ),
      child: Column(
        children: [
          const Icon(Icons.pause_circle_filled, size: 48, color: AppTheme.textDisabled),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            TranslationService.translate('service_paused'), 
            style: AppTheme.textTheme.headlineLarge?.copyWith(color: AppTheme.textDisabled),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            TranslationService.translate('service_paused_subtitle'), 
            style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveState() {
    final status = widget.statusModel!.status;
    Color bgColor;
    Color borderColor;
    Color primaryColor;
    String label;
    String subtitle;
    IconData iconData;

    switch (status) {
      case GateStatus.open:
        bgColor = AppTheme.successSubtle;
        borderColor = AppTheme.successBorder;
        primaryColor = AppTheme.success;
        label = TranslationService.translate('gate_open');
        subtitle = TranslationService.translate('gate_open_subtitle');
        iconData = Icons.check_circle;
        break;
      case GateStatus.alert:
        bgColor = AppTheme.warningSubtle;
        borderColor = AppTheme.warningBorder;
        primaryColor = AppTheme.warning;
        label = TranslationService.translate('gate_alert');
        subtitle = TranslationService.translate('gate_alert_subtitle');
        iconData = Icons.warning;
        break;
      case GateStatus.closed:
        bgColor = AppTheme.dangerSubtle;
        borderColor = AppTheme.dangerBorder;
        primaryColor = AppTheme.danger;
        label = TranslationService.translate('gate_closed');
        subtitle = TranslationService.translate('gate_closed_subtitle');
        iconData = Icons.cancel;
        break;
    }

    Widget statusIcon = Icon(iconData, size: 48, color: primaryColor);
    
    if (status == GateStatus.alert) {
      statusIcon = ScaleTransition(scale: _pulseAnimation, child: statusIcon);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacing32),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4, // elevation 2 proxy
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          statusIcon,
          const SizedBox(height: AppTheme.spacing16),
          // We wrap the display Large text in a fitted box in case it wraps too wildly on narrow screens
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label, 
              style: AppTheme.textTheme.displayLarge?.copyWith(color: primaryColor), 
              textAlign: TextAlign.center
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            subtitle, 
            style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary), 
            textAlign: TextAlign.center
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            widget.statusModel!.relativeTimeLabel, 
            style: AppTheme.textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center
          ),
        ],
      ),
    );
  }
}
