import 'package:flutter/material.dart';

/// Smooth scroll utility for section navigation.
class ScrollHelper {
  ScrollHelper._();

  static Future<void> scrollToSection({
    required GlobalKey key,
    required ScrollController controller,
    Duration duration = const Duration(milliseconds: 800),
  }) async {
    final context = key.currentContext;
    if (context == null) return;

    await Scrollable.ensureVisible(
      context,
      duration: duration,
      curve: Curves.easeInOutCubic,
      alignment: 0.05,
    );
  }
}
