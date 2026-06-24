class ExperienceItem {
  const ExperienceItem({
    required this.company,
    required this.role,
    required this.period,
    required this.responsibilities,
  });

  final String company;
  final String role;
  final String period;
  final List<String> responsibilities;
}
