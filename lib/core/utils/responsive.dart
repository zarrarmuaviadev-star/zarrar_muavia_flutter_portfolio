import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Responsive layout helpers for desktop, tablet, and mobile.
class Responsive {
  Responsive._();

  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static bool isMobile(BuildContext context) =>
      screenWidth(context) < AppConstants.mobileBreakpoint;

  static bool useCompactNav(BuildContext context) =>
      screenWidth(context) < AppConstants.tabletBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= AppConstants.mobileBreakpoint &&
        width < AppConstants.tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      screenWidth(context) >= AppConstants.tabletBreakpoint;

  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  static int gridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  static int skillsCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }

  static double sectionPadding(BuildContext context) =>
      isMobile(context)
          ? AppConstants.sectionVerticalPaddingMobile
          : AppConstants.sectionVerticalPadding;
}
