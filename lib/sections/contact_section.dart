import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../core/utils/url_helper.dart';
import '../widgets/animated_section.dart';
import '../widgets/contact_form.dart';
import '../widgets/contact_info_card.dart';
import '../widgets/section_title.dart';
import '../widgets/section_wrapper.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return SectionWrapper(
      child: AnimatedSection(
        visibilityKey: 'contact',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              tag: 'Contact',
              title: 'Let\'s Work Together',
              subtitle: 'Open to full-time roles, freelance projects, and collaborations.',
            ),
            if (isMobile)
              Column(
                children: [
                  _infoColumn(),
                  const SizedBox(height: 24),
                  const ContactForm(),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _infoColumn()),
                  const SizedBox(width: 32),
                  const Expanded(flex: 2, child: ContactForm()),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn() {
    return Column(
      children: [
        Text(
          'Get in Touch',
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'Feel free to reach out for collaborations, opportunities, or a friendly hello.',
          style: GoogleFonts.inter(fontSize: 14, height: 1.6, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        ContactInfoCard(
          icon: Icons.email_outlined,
          label: 'Email',
          value: AppConstants.email,
          onTap: () => UrlHelper.openEmail(AppConstants.email),
        ),
        const SizedBox(height: 14),
        ContactInfoCard(
          icon: Icons.link_rounded,
          label: 'LinkedIn',
          value: 'View Profile',
          onTap: () => UrlHelper.openUrl(AppConstants.linkedInUrl),
        ),
        const SizedBox(height: 14),
        ContactInfoCard(
          icon: Icons.code_rounded,
          label: 'GitHub',
          value: 'View Repositories',
          onTap: () => UrlHelper.openUrl(AppConstants.gitHubUrl),
        ),
        const SizedBox(height: 14),
        ContactInfoCard(
          icon: Icons.location_on_outlined,
          label: 'Location',
          value: AppConstants.location,
        ),
      ],
    );
  }
}
