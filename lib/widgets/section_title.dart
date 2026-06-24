import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';

/// Premium section heading with tag, title, and optional description.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.tag,
    this.subtitle,
    this.align = TextAlign.start,
  });

  final String title;
  final String? tag;
  final String? subtitle;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final crossAlign = align == TextAlign.center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        if (tag != null)
          Text(
            tag!.toUpperCase(),
            textAlign: align,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
              color: AppColors.primary,
            ),
          ),
        if (tag != null) const SizedBox(height: 10),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.accentGradient.createShader(bounds),
          child: Text(
            title,
            textAlign: align,
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 72,
          height: 4,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          Text(
            subtitle!,
            textAlign: align,
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: 48),
      ],
    );
  }
}
