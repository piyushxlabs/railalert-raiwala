import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

// ── Color constants matching Ui_Desgin.md exactly ────────────────────────────
const _kPrimary = Color(0xFFE65100);
const _kPrimarySubtle = Color(0xFFFBE9E7);
const _kTextPrimary = Color(0xFF212121);
const _kTextSecondary = Color(0xFF757575);
const _kTextDisabled = Color(0xFFBDBDBD);

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
    return Scaffold(
      backgroundColor: AppTheme.pageBackground,
      appBar: AppBar(
        title: const Text('About the Developer'),
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
              // ── Profile Picture ────────────────────────────────────────────
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

              // ── Name ───────────────────────────────────────────────────────
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

              // ── Premium tagline chip ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _kPrimarySubtle,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Son of Raiwala • Building for the Community',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kPrimary,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing32),

              // ── Emotional Quote Card ───────────────────────────────────────
              _buildQuoteCard(),
              const SizedBox(height: 40.0),

              // ── Social Buttons ─────────────────────────────────────────────
              _AnimatedSocialButton(
                title: 'Follow the Journey',
                subtitle: '@lost.in.piyush',
                iconGradient: const LinearGradient(
                  colors: [Color(0xFFE1306C), Color(0xFFF77737)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.camera_alt_outlined,
                onTap: () => _launchUrl(
                    context, 'https://www.instagram.com/lost.in.piyush'),
              ),
              const SizedBox(height: AppTheme.spacing8),

              _AnimatedSocialButton(
                title: 'Connect Professionally',
                subtitle: "Let's build together",
                iconGradient: null,
                iconSolidColor: const Color(0xFF0077B5),
                icon: Icons.work_outline,
                onTap: () => _launchUrl(
                    context, 'https://www.linkedin.com/in/piyushxlabs'),
              ),
              const SizedBox(height: AppTheme.spacing8),

              _AnimatedSocialButton(
                title: 'Drop a Message',
                subtitle: 'Feedback & Suggestions',
                iconGradient: null,
                iconSolidColor: const Color(0xFFEA4335),
                icon: Icons.mail_outline,
                onTap: () =>
                    _launchUrl(context, 'mailto:piyushjaguri13@gmail.com'),
              ),

              const SizedBox(height: AppTheme.spacing32),
            ],
          ),
        ),
      ),
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
                const Text(
                  "We've all felt the frustration of being stuck at the Raiwala fatak, watching the clock tick and feeling helpless. I built RailAlert not as an engineer, but as a local who wanted to give our community its time back. This app is my small gift to my hometown. Let's make our everyday journeys a little smoother, together.",
                  style: TextStyle(
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

// ── Private tactile animated social button ─────────────────────────────────
class _AnimatedSocialButton extends StatefulWidget {
  const _AnimatedSocialButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconGradient,
    this.iconSolidColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
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
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon container 42×42
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: widget.iconGradient,
                    color: widget.iconGradient == null
                        ? widget.iconSolidColor
                        : null,
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 22),
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
                      const SizedBox(height: 2),
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
