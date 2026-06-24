import 'package:flutter/material.dart';

/// Wraps a section with a [GlobalKey] for smooth scroll navigation.
class SectionAnchor extends StatelessWidget {
  const SectionAnchor({
    super.key,
    required this.sectionKey,
    required this.child,
  });

  final GlobalKey sectionKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: sectionKey,
      child: child,
    );
  }
}
