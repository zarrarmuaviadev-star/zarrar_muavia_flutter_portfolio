import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/app_data.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../models/project_item.dart';
import '../widgets/animated_section.dart';
import '../widgets/project_card.dart';
import '../widgets/section_title.dart';
import '../widgets/section_wrapper.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _activeFilter = 'All';

  List<ProjectItem> get _filtered {
    if (_activeFilter == 'All') return AppData.projects;
    return AppData.projects.where((p) => p.category == _activeFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = Responsive.gridCrossAxisCount(context);
    final filtered = _filtered;

    return SectionWrapper(
      backgroundColor: AppColors.surface.withValues(alpha: 0.35),
      child: AnimatedSection(
        visibilityKey: 'projects',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              tag: 'Portfolio',
              title: 'Featured Projects',
              subtitle: 'Case studies and applications I\'ve built.',
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppConstants.projectFilters.map((filter) {
                final active = _activeFilter == filter;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => setState(() => _activeFilter = filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: active ? AppColors.ctaGradient : null,
                        color: active ? null : AppColors.card,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: active ? Colors.transparent : AppColors.border,
                        ),
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 16,
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        filter,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: active ? AppColors.background : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 36),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: filtered.isEmpty
                  ? Center(
                      key: const ValueKey('empty'),
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Text(
                          'No projects in this category yet.',
                          style: GoogleFonts.inter(color: AppColors.textMuted),
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      key: ValueKey(_activeFilter),
                      builder: (context, constraints) {
                        final spacing = 24.0;
                        final cardWidth = crossAxisCount == 1
                            ? constraints.maxWidth
                            : (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                                crossAxisCount;
                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: filtered.asMap().entries.map((entry) {
                            return SizedBox(
                              width: cardWidth,
                              child: ProjectCard(
                                project: entry.value,
                                index: entry.key,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
