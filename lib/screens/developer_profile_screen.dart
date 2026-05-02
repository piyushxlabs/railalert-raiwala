import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/translation_service.dart';

// ── Color constants matching UI_DESIGN_SYSTEM.md exactly ────────────────────
const _kPrimary = Color(0xFFE65100);
const _kPrimarySubtle = Color(0xFFFBE9E7);
const _kTextPrimary = Color(0xFF212121);
const _kTextSecondary = Color(0xFF757575);
const _kTextDisabled = Color(0xFFBDBDBD);

// ── Brand colors ─────────────────────────────────────────────────────────────
const _kInstagramStart = Color(0xFF833AB4);
const _kInstagramMid = Color(0xFFE1306C);
const _kInstagramEnd = Color(0xFFF77737);
const _kLinkedIn = Color(0xFF0077B5);
const _kGmailRed = Color(0xFFEA4335);

class DeveloperProfileScreen extends StatefulWidget {
  const DeveloperProfileScreen({super.key});

  @override
  State<DeveloperProfileScreen> createState() => _DeveloperProfileScreenState();
}

class _DeveloperProfileScreenState extends State<DeveloperProfileScreen>
    with TickerProviderStateMixin {

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Could not open link. Please try again later.')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: TranslationService.currentLanguage,
      builder: (context, lang, child) {
        return Scaffold(
          backgroundColor: AppTheme.pageBackground,
          appBar: AppBar(
            title: Text(TranslationService.translate('dev_appbar_title')),
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: _kTextPrimary,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing24,
                vertical: AppTheme.spacing24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Profile Picture ───────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: _kPrimary.withValues(alpha: 0.18),
                          blurRadius: 28,
                          spreadRadius: 8,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: _kPrimarySubtle,
                      backgroundImage: AssetImage('assets/images/piyush.jpg'),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // ── Name ──────────────────────────────────────────────────
                  Text(
                    'Piyush Jaguri',
                    style: AppTheme.textTheme.displayLarge?.copyWith(
                      color: _kTextPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacing12),

                  // ── Premium tagline chip ──────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: _kPrimarySubtle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      TranslationService.translate('dev_tagline'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _kPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing32),

                  // ── Emotional Quote Card ──────────────────────────────────
                  _buildQuoteCard(),
                  const SizedBox(height: 40.0),

                  // ── Social Buttons ────────────────────────────────────────
                  _AnimatedSocialButton(
                    title: TranslationService.translate('dev_btn_instagram_title'),
                    subtitle: TranslationService.translate('dev_btn_instagram_subtitle'),
                    iconGradient: const LinearGradient(
                      colors: [_kInstagramStart, _kInstagramMid, _kInstagramEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    iconWidget: const FaIcon(
                      FontAwesomeIcons.instagram,
                      color: Colors.white,
                      size: 22,
                    ),
                    onTap: () => _launchUrl(
                        context, 'https://www.instagram.com/lost.in.piyush'),
                  ),
                  const SizedBox(height: AppTheme.spacing12),

                  _AnimatedSocialButton(
                    title: TranslationService.translate('dev_btn_linkedin_title'),
                    subtitle: TranslationService.translate('dev_btn_linkedin_subtitle'),
                    iconGradient: null,
                    iconSolidColor: _kLinkedIn,
                    iconWidget: const FaIcon(
                      FontAwesomeIcons.linkedinIn,
                      color: Colors.white,
                      size: 22,
                    ),
                    onTap: () => _launchUrl(
                        context, 'https://www.linkedin.com/in/piyushxlabs'),
                  ),
                  const SizedBox(height: AppTheme.spacing12),

                  _AnimatedSocialButton(
                    title: TranslationService.translate('dev_btn_email_title'),
                    subtitle: TranslationService.translate('dev_btn_email_subtitle'),
                    iconGradient: null,
                    iconSolidColor: _kGmailRed,
                    iconWidget: const FaIcon(
                      FontAwesomeIcons.envelope,
                      color: Colors.white,
                      size: 22,
                    ),
                    onTap: () =>
                        _launchUrl(context, 'mailto:piyushjaguri13@gmail.com'),
                  ),

                  const SizedBox(height: AppTheme.spacing32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: _kPrimary, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            // Large decorative opening quote at top-left
            Positioned(
              top: -8,
              left: -4,
              child: Text(
                '❝',
                style: TextStyle(
                  fontSize: 48,
                  color: _kPrimary.withValues(alpha: 0.2),
                  height: 1,
                ),
              ),
            ),
            // Quote content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Space below decorative quote
                Text(
                  TranslationService.translate('dev_quote'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF424242),
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '— Piyush',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _kPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private tactile animated social button ────────────────────────────────────
class _AnimatedSocialButton extends StatefulWidget {
  const _AnimatedSocialButton({
    required this.title,
    required this.subtitle,
    required this.iconWidget,
    required this.onTap,
    this.iconGradient,
    this.iconSolidColor,
  });

  final String title;
  final String subtitle;
  final Widget iconWidget;
  final VoidCallback onTap;
  final LinearGradient? iconGradient;
  final Color? iconSolidColor;

  @override
  State<_AnimatedSocialButton> createState() => _AnimatedSocialButtonState();
}

class _AnimatedSocialButtonState extends State<_AnimatedSocialButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) =>
      setState(() => _scale = 0.95);

  void _onTapUp(TapUpDetails _) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: _scale < 1.0
            ? const Duration(milliseconds: 100)
            : const Duration(milliseconds: 200),
        child: Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                // Icon container 48×48 with gradient or solid color
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: widget.iconGradient,
                    color: widget.iconGradient == null
                        ? widget.iconSolidColor
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: (widget.iconSolidColor ?? _kInstagramEnd)
                            .withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(child: widget.iconWidget),
                ),
                const SizedBox(width: 16),
                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _kTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _kTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: _kTextDisabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
