import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/url_helper.dart';
import '../models/project_item.dart';
import 'glass_card.dart';
import 'gradient_button.dart';

/// Premium project case-study card with hover image zoom.
class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project, required this.index});

  final ProjectItem project;
  final int index;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 250),
        child: GlassCard(
          padding: EdgeInsets.zero,
          borderRadius: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Stack(
                  children: [
                    AnimatedScale(
                      scale: _hovered ? 1.08 : 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      child: Image.asset(
                        widget.project.imagePath,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _placeholder(),
                      ),
                    ),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.background.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                    if (widget.project.isFeatured)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: AppColors.ctaGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Featured',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.project.title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.project.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.65,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.project.techStack
                          .map(
                            (tech) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Text(
                                tech,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.primaryLight,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GradientButton(
                            label: 'View Case Study',
                            icon: Icons.auto_stories_outlined,
                            isOutlined: true,
                            onPressed: () => _showCaseStudy(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: widget.project.gitHubUrl != null
                              ? () => UrlHelper.openUrl(widget.project.gitHubUrl!)
                              : null,
                          icon: const Icon(Icons.code_rounded),
                          tooltip: 'GitHub',
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            side: const BorderSide(color: AppColors.border),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (widget.index * 100).ms, duration: 500.ms)
        .slideY(begin: 0.12, end: 0);
  }

  Widget _placeholder() {
    return Container(
      height: 220,
      color: AppColors.surfaceLight,
      child: const Center(
        child: Icon(Icons.phone_iphone_rounded, size: 56, color: AppColors.primary),
      ),
    );
  }

  void _showCaseStudy(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(widget.project.title, style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Text(
          widget.project.description,
          style: GoogleFonts.inter(color: AppColors.textSecondary, height: 1.6),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}
