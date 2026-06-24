import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../widgets/animated_section.dart';
import '../widgets/section_title.dart';
import '../widgets/section_wrapper.dart';
import '../widgets/tech_stack_orbit.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      backgroundColor: AppColors.surface.withValues(alpha: 0.35),
      child: AnimatedSection(
        visibilityKey: 'skills',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              tag: 'Skills',
              title: 'Technical Expertise',
              subtitle: Responsive.isMobile(context)
                  ? 'Tap an icon or pick from All Skills below.'
                  : 'Hover an icon or pick from All Skills below.',
              align: Responsive.isMobile(context) ? TextAlign.center : TextAlign.start,
            ),
            const Center(child: TechStackOrbit()),
          ],
        ),
      ),
    );
  }
}
