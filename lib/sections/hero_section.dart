import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/app_data.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../core/utils/resume_downloader.dart';
import '../widgets/code_profile_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/section_wrapper.dart';
import '../widgets/social_icon_button.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onViewProjects,
    required this.onContact,
  });

  final VoidCallback onViewProjects;
  final VoidCallback onContact;

  Future<void> _downloadResume() async {
    await downloadResume(
      AppConstants.resumeAssetPath,
      AppConstants.resumeFileName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final isMobile = Responsive.isMobile(context);
    // Clear space below sticky navbar (matches gap above "Available for opportunities").
    const navBarHeight = 76.0;
    const badgeTopGap = 32.0;
    final topPadding = navBarHeight + badgeTopGap + (isMobile ? 12 : 24);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: height * 0.92),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: SectionWrapper(
        padding: EdgeInsets.only(
          top: topPadding,
          bottom: 64,
          left: AppConstants.horizontalPadding,
          right: AppConstants.horizontalPadding,
        ),
        child: isMobile ? _mobile(context) : _desktop(context),
      ),
    );
  }

  Widget _desktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _content(context, isMobile: false)),
        const SizedBox(width: 48),
        const Expanded(child: CodeProfileCard()),
      ],
    );
  }

  Widget _mobile(BuildContext context) {
    return Column(
      children: [
        _content(context, isMobile: true),
        const SizedBox(height: 40),
        const CodeProfileCard(),
      ],
    );
  }

  Widget _content(BuildContext context, {required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
          ),
          child: Text(
            'Available for opportunities',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.primaryLight),
          ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 28),
        Text(
          'Hi, I\'m',
          style: GoogleFonts.inter(fontSize: 20, color: AppColors.textSecondary),
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 8),
        Text(
          AppData.name,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 36 : 52,
            fontWeight: FontWeight.w900,
            height: 1.1,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: AnimatedTextKit(
            animatedTexts: AppData.typingRoles
                .map(
                  (role) => TypewriterAnimatedText(
                    role,
                    textStyle: GoogleFonts.inter(
                      fontSize: isMobile ? 20 : 26,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    speed: const Duration(milliseconds: 80),
                  ),
                )
                .toList(),
            repeatForever: true,
            pause: const Duration(milliseconds: 1800),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppData.heroIntro,
          style: GoogleFonts.inter(
            fontSize: 16,
            height: 1.75,
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 36),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            GradientButton(
              label: 'Download Resume',
              icon: Icons.download_rounded,
              onPressed: _downloadResume,
            ),
            GradientButton(
              label: 'View Projects',
              icon: Icons.work_outline_rounded,
              isOutlined: true,
              onPressed: onViewProjects,
            ),
            GradientButton(
              label: 'Contact Me',
              icon: Icons.mail_outline_rounded,
              isOutlined: true,
              onPressed: onContact,
            ),
          ],
        ).animate().fadeIn(delay: 500.ms),
        const SizedBox(height: 32),
        const SocialIconRow().animate().fadeIn(delay: 600.ms),
      ],
    );
  }
}
