import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/app_data.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../core/utils/url_helper.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, required this.onSectionTap});

  final void Function(String sectionId) onSectionTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 48,
        horizontal: Responsive.isMobile(context) ? 24 : 48,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.6),
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
          child: isMobile ? _mobileLayout() : _desktopLayout(),
        ),
      ),
    );
  }

  Widget _desktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _brand()),
        Expanded(child: _quickLinks()),
        Expanded(child: _social()),
      ],
    );
  }

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _brand(),
        const SizedBox(height: 32),
        _quickLinks(),
        const SizedBox(height: 32),
        _social(),
      ],
    );
  }

  Widget _brand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.logo,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppData.name,
          style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Text(
          '© 2026 ${AppData.name}. All rights reserved.',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _quickLinks() {
    final links = [
      ('Home', AppConstants.sectionHome),
      ('About', AppConstants.sectionAbout),
      ('Projects', AppConstants.sectionProjects),
      ('Contact', AppConstants.sectionContact),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Links', style: _heading()),
        const SizedBox(height: 16),
        ...links.map(
          (l) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onSectionTap(l.$2),
              child: Text(l.$1, style: GoogleFonts.inter(color: AppColors.textSecondary)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _social() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Connect', style: _heading()),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          children: [
            _socialBtn(FontAwesomeIcons.github, () => UrlHelper.openUrl(AppConstants.gitHubUrl)),
            _socialBtn(FontAwesomeIcons.linkedin, () => UrlHelper.openUrl(AppConstants.linkedInUrl)),
            _socialBtn(FontAwesomeIcons.envelope, () => UrlHelper.openEmail(AppConstants.email)),
          ],
        ),
      ],
    );
  }

  TextStyle _heading() =>
      GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.textPrimary);

  Widget _socialBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: FaIcon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
