import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';

/// Animated number counter for stats.
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    this.suffix = '',
    this.text,
    this.style,
    this.duration = const Duration(milliseconds: 1400),
  });

  final int value;
  final String suffix;
  final String? text;
  final TextStyle? style;
  final Duration duration;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> {
  @override
  Widget build(BuildContext context) {
    if (widget.text != null) {
      return Text(
        widget.text!,
        style: widget.style ??
            GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: widget.value.toDouble()),
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      builder: (context, val, _) {
        return Text(
          '${val.round()}${widget.suffix}',
          style: widget.style ??
              GoogleFonts.inter(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                foreground: Paint()
                  ..shader = AppColors.accentGradient.createShader(
                    const Rect.fromLTWH(0, 0, 120, 50),
                  ),
              ),
        );
      },
    );
  }
}
