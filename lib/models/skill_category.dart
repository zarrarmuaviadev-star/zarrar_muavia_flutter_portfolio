import 'skill_item.dart';

class SkillCategory {
  const SkillCategory({
    required this.title,
    required this.skills,
  });

  final String title;
  final List<SkillItem> skills;
}
