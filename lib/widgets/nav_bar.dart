import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';

typedef SectionTapCallback = void Function(String sectionId);

/// Sticky glassmorphism navigation bar.
class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({
    super.key,
    required this.onSectionTap,
    required this.activeSection,
  });

  final SectionTapCallback onSectionTap;
  final String activeSection;

  static const List<Map<String, String>> _navItems = [
    {'id': AppConstants.sectionHome, 'label': 'Home'},
    {'id': AppConstants.sectionAbout, 'label': 'About'},
    {'id': AppConstants.sectionSkills, 'label': 'Skills'},
    {'id': AppConstants.sectionExperience, 'label': 'Experience'},
    {'id': AppConstants.sectionProjects, 'label': 'Projects'},
    {'id': AppConstants.sectionEducation, 'label': 'Education'},
    {'id': AppConstants.sectionResume, 'label': 'Resume'},
    {'id': AppConstants.sectionContact, 'label': 'Contact'},
  ];

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final compact = Responsive.useCompactNav(context);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: AppBar(
          backgroundColor: AppColors.background.withValues(alpha: 0.72),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: InkWell(
            onTap: () => onSectionTap(AppConstants.sectionHome),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Z',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      color: AppColors.background,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ShaderMask(
                  shaderCallback: (b) => AppColors.accentGradient.createShader(b),
                  child: Text(
                    AppConstants.logo,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (compact)
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              )
            else
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.52,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: _navItems
                        .map((item) => _NavLink(
                              label: item['label']!,
                              isActive: activeSection == item['id'],
                              onTap: () => onSectionTap(item['id']!),
                            ))
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget buildDrawer({
    required SectionTapCallback onSectionTap,
    required String activeSection,
    required VoidCallback onClose,
  }) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                AppConstants.logo,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Divider(color: AppColors.border),
            Expanded(
              child: ListView(
                children: _navItems.map((item) {
                  final active = activeSection == item['id'];
                  return ListTile(
                    leading: Icon(
                      _iconForSection(item['id']!),
                      color: active ? AppColors.primary : AppColors.textSecondary,
                    ),
                    title: Text(
                      item['label']!,
                      style: GoogleFonts.inter(
                        color: active ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      onClose();
                      onSectionTap(item['id']!);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _iconForSection(String id) => switch (id) {
        AppConstants.sectionHome => Icons.home_outlined,
        AppConstants.sectionAbout => Icons.person_outline,
        AppConstants.sectionSkills => Icons.auto_awesome,
        AppConstants.sectionExperience => Icons.work_outline,
        AppConstants.sectionProjects => Icons.folder_outlined,
        AppConstants.sectionEducation => Icons.school_outlined,
        AppConstants.sectionResume => Icons.description_outlined,
        AppConstants.sectionContact => Icons.mail_outline,
        _ => Icons.circle,
      };
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: active
              ? AppColors.primary.withValues(alpha: 0.15)
              : _hovered
                  ? AppColors.surfaceLight
                  : Colors.transparent,
          border: active
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
              : null,
        ),
        child: TextButton(
          onPressed: widget.onTap,
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active
                  ? AppColors.primary
                  : _hovered
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
