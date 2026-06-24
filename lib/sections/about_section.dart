import 'package:flutter/material.dart';

import '../widgets/animated_section.dart';
import '../widgets/section_title.dart';
import '../widgets/section_wrapper.dart';
import '../widgets/about_book.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: AnimatedSection(
        visibilityKey: 'about',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              tag: 'About',
              title: 'About Me',
              subtitle: 'Turn the pages — each chapter has its own color theme.',
            ),
            const AboutBook(),
          ],
        ),
      ),
    );
  }
}
