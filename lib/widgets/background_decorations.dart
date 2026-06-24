import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Subtle dot grid + animated glowing orbs for page background.
class BackgroundDecorations extends StatefulWidget {
  const BackgroundDecorations({super.key});

  @override
  State<BackgroundDecorations> createState() => _BackgroundDecorationsState();
}

class _BackgroundDecorationsState extends State<BackgroundDecorations>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(gradient: AppColors.pageGradient),
              ),
              CustomPaint(
                painter: _DotGridPainter(),
                size: Size.infinite,
              ),
              Positioned(
                top: 80 + _controller.value * 40,
                left: -60,
                child: _glowOrb(220, AppColors.primary.withValues(alpha: 0.12)),
              ),
              Positioned(
                top: 300 - _controller.value * 30,
                right: -80,
                child: _glowOrb(280, AppColors.accent.withValues(alpha: 0.14)),
              ),
              Positioned(
                bottom: 120 + _controller.value * 20,
                left: MediaQuery.sizeOf(context).width * 0.3,
                child: _glowOrb(180, AppColors.accentSecondary.withValues(alpha: 0.1)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _glowOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    const spacing = 32.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
