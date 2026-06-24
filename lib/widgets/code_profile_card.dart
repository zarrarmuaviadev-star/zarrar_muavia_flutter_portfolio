import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import 'glass_card.dart';

/// Animated developer code profile card for hero section.
class CodeProfileCard extends StatelessWidget {
  const CodeProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(0),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withValues(alpha: 0.8),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                _dot(Colors.redAccent),
                const SizedBox(width: 6),
                _dot(Colors.amberAccent),
                const SizedBox(width: 6),
                _dot(Colors.greenAccent),
                const Spacer(),
                Text(
                  'developer.dart',
                  style: GoogleFonts.jetBrainsMono(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _codeLine('class Developer {'),
                _codeLine('  final String name ='),
                _codeLine('    "Muhammad Zarrar Muavia";', highlight: true),
                _codeLine('  final String role ='),
                _codeLine('    "Flutter Developer";', highlight: true),
                _codeLine('  final List<String> skills = ['),
                _codeLine('    "Flutter", "Dart", "Firebase",'),
                _codeLine('    "REST APIs", "Clean Architecture",'),
                _codeLine('  ];'),
                _codeLine('  void buildApps() {'),
                _codeLine('    shipProductionReadyCode();', highlight: true),
                _codeLine('  }'),
                _codeLine('}'),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Available for Flutter roles & freelance projects',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 700.ms)
        .slideX(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  Widget _codeLine(String text, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 13,
          height: 1.5,
          color: highlight ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
