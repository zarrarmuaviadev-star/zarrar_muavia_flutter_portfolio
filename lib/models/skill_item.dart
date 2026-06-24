import 'package:flutter/material.dart';

class SkillItem {
  const SkillItem({
    required this.name,
    required this.icon,
    required this.proficiency,
  });

  final String name;
  final IconData icon;
  final double proficiency;
}
