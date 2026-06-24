import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/responsive.dart';

/// Consistent horizontal padding and max-width wrapper for sections.
class SectionWrapper extends StatelessWidget {
  const SectionWrapper({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: padding ??
          EdgeInsets.symmetric(
            vertical: Responsive.sectionPadding(context),
            horizontal: AppConstants.horizontalPadding,
          ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}
