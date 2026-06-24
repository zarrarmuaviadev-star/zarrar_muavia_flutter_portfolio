import 'package:flutter/material.dart';

import '../core/constants/app_data.dart';
import '../widgets/animated_section.dart';
import '../widgets/section_title.dart';
import '../widgets/section_wrapper.dart';
import '../widgets/timeline_card.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: AnimatedSection(
        visibilityKey: 'experience',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              tag: 'Experience',
              title: 'Work Experience',
              subtitle: 'My professional journey in mobile and Flutter development.',
            ),
            ...AppData.experiences.asMap().entries.map(
                  (e) => TimelineCard(
                    experience: e.value,
                    index: e.key,
                    isLast: e.key == AppData.experiences.length - 1,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
