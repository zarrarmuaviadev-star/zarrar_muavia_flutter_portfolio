import 'package:flutter/material.dart';

/// Premium dark palette with cyan / purple accents.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF050810);
  static const Color backgroundMid = Color(0xFF0A0F1E);
  static const Color surface = Color(0xFF0F1629);
  static const Color surfaceLight = Color(0xFF151D35);
  static const Color card = Color(0xFF121A2E);
  static const Color glass = Color(0x1AFFFFFF);
  static const Color border = Color(0xFF243049);
  static const Color borderGlow = Color(0xFF3D5AFE);

  static const Color primary = Color(0xFF00D4FF);
  static const Color primaryLight = Color(0xFF66E5FF);
  static const Color accent = Color(0xFF7C4DFF);
  static const Color accentSecondary = Color(0xFF448AFF);
  static const Color accentGreen = Color(0xFF00E676);

  static const Color textPrimary = Color(0xFFF5F8FF);
  static const Color textSecondary = Color(0xFF9AA8C7);
  static const Color textMuted = Color(0xFF6B7A99);

  static const Color error = Color(0xFFFF5252);

  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [background, backgroundMid, Color(0xFF0D1225)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF050810),
      Color(0xFF0A1028),
      Color(0xFF101B3A),
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primary, accent],
  );

  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0066FF), accent, primary],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF151D35),
      Color(0xFF0F1629),
    ],
  );
}
