import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/url_helper.dart';

/// Social icon button with hover glow.
class SocialIconButton extends StatefulWidget {
  const SocialIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  State<SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<SocialIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: _hovered
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.surface,
              border: Border.all(
                color: _hovered ? AppColors.primary : AppColors.border,
              ),
              boxShadow: _hovered
                  ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16)]
                  : [],
            ),
            child: Icon(widget.icon, size: 20, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

class SocialIconRow extends StatelessWidget {
  const SocialIconRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SocialIconButton(
          icon: FontAwesomeIcons.github,
          tooltip: 'GitHub',
          onTap: () => UrlHelper.openUrl(AppConstants.gitHubUrl),
        ),
        const SizedBox(width: 12),
        SocialIconButton(
          icon: FontAwesomeIcons.linkedin,
          tooltip: 'LinkedIn',
          onTap: () => UrlHelper.openUrl(AppConstants.linkedInUrl),
        ),
        const SizedBox(width: 12),
        SocialIconButton(
          icon: FontAwesomeIcons.envelope,
          tooltip: 'Email',
          onTap: () => UrlHelper.openEmail(AppConstants.email),
        ),
      ],
    );
  }
}
