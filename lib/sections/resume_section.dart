import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../core/utils/resume_downloader.dart';
import '../widgets/animated_section.dart';
import '../widgets/section_wrapper.dart';

class ResumeSection extends StatefulWidget {
  const ResumeSection({super.key});

  @override
  State<ResumeSection> createState() => _ResumeSectionState();
}

class _ResumeSectionState extends State<ResumeSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _arrowController;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  Future<void> _downloadResume() async {
    await downloadResume(
      AppConstants.resumeAssetPath,
      AppConstants.resumeFileName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return SectionWrapper(
      backgroundColor: AppColors.surface.withValues(alpha: 0.35),
      child: AnimatedSection(
        visibilityKey: 'resume',
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 28 : 48),
          decoration: BoxDecoration(
            gradient: AppColors.ctaGradient,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _content(isMobile),
                )
              : Row(
                  children: _content(isMobile),
                ),
        ),
      ),
    );
  }

  List<Widget> _content(bool isMobile) {
    return [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Want to know more about my experience?',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.w800,
                color: AppColors.background,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Download my resume for a complete overview of my skills, projects, and work history.',
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 1.6,
                color: AppColors.background.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: isMobile ? 0 : 32, height: isMobile ? 24 : 0),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _downloadResume,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.download_rounded, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Download Resume',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          AnimatedBuilder(
            animation: _arrowController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_arrowController.value * 8, 0),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 32,
                  color: AppColors.background.withValues(alpha: 0.9),
                ),
              );
            },
          ),
        ],
      ),
    ];
  }
}
