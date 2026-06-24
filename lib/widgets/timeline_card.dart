import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../models/experience_item.dart';
import 'glass_card.dart';

/// Alternating timeline card for experience section.
class TimelineCard extends StatefulWidget {
  const TimelineCard({
    super.key,
    required this.experience,
    required this.index,
    required this.isLast,
  });

  final ExperienceItem experience;
  final int index;
  final bool isLast;

  @override
  State<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<TimelineCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isLeft = widget.index.isEven;

    final card = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 250),
        child: GlassCard(
          enableHoverGlow: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.experience.company,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      widget.experience.period,
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.primaryLight),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                widget.experience.role,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ...widget.experience.responsibilities.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.accentGreen),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.55,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (!isDesktop) {
      return _mobileTimeline(card);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: isLeft ? card : const SizedBox()),
          _timelineDot(),
          Expanded(child: isLeft ? const SizedBox() : card),
        ],
      ),
    );
  }

  Widget _mobileTimeline(Widget card) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _dot(),
            if (!widget.isLast)
              Container(width: 2, height: 120, color: AppColors.border),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 24), child: card)),
      ],
    );
  }

  Widget _timelineDot() {
    return SizedBox(
      width: 48,
      child: Column(
        children: [
          _dot(),
          if (!widget.isLast) Expanded(child: Container(width: 2, color: AppColors.border)),
        ],
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.accentGradient,
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 12),
        ],
      ),
    );
  }
}
