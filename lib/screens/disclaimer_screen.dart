import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/notification_service.dart';
import '../services/translation_service.dart';
import 'commuter_dashboard_screen.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _isLoading = false;

  Future<void> _handleAgree() async {
    setState(() {
      _isLoading = true;
    });

    // Request permissions and hook into background topic streams ONLY AFTER explicit user approval
    await NotificationService().initFCM();
    
    // Log explicit token consent natively
    await NotificationService().logConsent();

    if (!mounted) return;
    
    // Explicit route push overriding standard flows
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CommuterDashboardScreen()),
    );
  }

  void _handleDisagree() {
    // Explicit System Abort
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBackground,
      appBar: AppBar(
        title: Text(TranslationService.translate('disclaimer_appbar_title')),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppTheme.borderDefault, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppTheme.spacing16),
                    const Icon(
                      Icons.gavel_rounded,
                      color: Color(0xFFC62828), // CLOSED / Danger color
                      size: 72,
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                    Text(
                      TranslationService.translate('disclaimer_notice_title'),
                      style: AppTheme.textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFFC62828),
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacing32),
                    Text(
                      TranslationService.translate('disclaimer_body_1'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE), // Subtle background
                        border: Border.all(color: const Color(0xFFEF9A9A), width: 2), // Danger Border
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        TranslationService.translate('disclaimer_body_2'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFC62828),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing32),
                    Text(
                      TranslationService.translate('disclaimer_body_3'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            // Explicit Consent Footer
            Container(
              padding: const EdgeInsets.only(
                left: AppTheme.spacing24,
                right: AppTheme.spacing24,
                bottom: AppTheme.spacing32,
                top: AppTheme.spacing24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppTheme.borderDefault, width: 1.0),
                ),
              ),
              child: Column(
                children: [
                  // Primary Agree Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleAgree,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary, // #E65100
                        disabledBackgroundColor: AppTheme.primary.withValues(alpha: 0.6),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading 
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              TranslationService.translate('agree_button'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacing16),
                  
                  // Secondary Outline Disagree Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _handleDisagree,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC62828), // Danger Text
                        side: const BorderSide(color: Color(0xFFC62828), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        TranslationService.translate('disagree_button'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
