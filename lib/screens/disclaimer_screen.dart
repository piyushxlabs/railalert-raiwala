import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'commuter_dashboard_screen.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  Future<void> _acceptTerms(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_agreed_to_disclaimer', true);

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const CommuterDashboardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBackground,
      appBar: AppBar(
        title: const Text("Disclaimer / अस्वीकरण"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      "1. Not Official App / आधिकारिक ऐप नहीं",
                      "This is NOT an official app of Indian Railways.\n"
                      "यह भारतीय रेलवे का आधिकारिक ऐप नहीं है।",
                      context,
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                    _buildSection(
                      "2. Community Driven / समुदाय संचालित",
                      "This is a community-driven app for commuter convenience only.\n"
                      "यह केवल यात्रियों की सुविधा के लिए एक समुदाय संचालित ऐप है।",
                      context,
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                    _buildSection(
                      "3. No Liability / कोई कानूनी जिम्मेदारी नहीं",
                      "The developer is NOT responsible for any accidents, delays, or physical harm caused by relying on this app.\n"
                      "इस ऐप पर निर्भर रहने के कारण होने वाली किसी भी दुर्घटना, देरी या शारीरिक नुकसान के लिए डेवलपर जिम्मेदार नहीं है।",
                      context,
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                    _buildSection(
                      "4. Gateman Duty / गेटमैन का मुख्य कर्तव्य",
                      "For the Gateman: Updating this app is a secondary task. The primary duty is physical gate operation and safety.\n"
                      "गेटमैन के लिए: इस ऐप को अपडेट करना एक द्वितीयक कार्य है। आपकी पहली प्राथमिकता गेट का सुरक्षित संचालन है।",
                      context,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusDefault),
                  ),
                  onPressed: () => _acceptTerms(context),
                  child: Text(
                    "I Agree / मैं सहमत हूँ",
                    style: AppTheme.textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.textTheme.titleMedium?.copyWith(color: AppTheme.danger)),
        const SizedBox(height: AppTheme.spacing8),
        Text(body, style: AppTheme.textTheme.bodyLarge?.copyWith(height: 1.5)),
      ],
    );
  }
}
