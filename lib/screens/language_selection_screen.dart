import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/translation_service.dart';
import 'disclaimer_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  void _selectLanguage(BuildContext context, String langCode) {
    TranslationService.setLanguage(langCode);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DisclaimerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.language_rounded,
                size: 80,
                color: AppTheme.primary,
              ),
              const SizedBox(height: AppTheme.spacing24),
              Text(
                'Choose Language\nभाषा चुनें',
                style: AppTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacing48),
              
              _buildLanguageCard(
                context: context,
                title: 'English',
                subtitle: 'Proceed in English',
                langCode: 'en',
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              _buildLanguageCard(
                context: context,
                title: 'हिन्दी',
                subtitle: 'हिंदी में आगे बढ़ें',
                langCode: 'hi',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String langCode,
  }) {
    return InkWell(
      onTap: () => _selectLanguage(context, langCode),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderDefault),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
