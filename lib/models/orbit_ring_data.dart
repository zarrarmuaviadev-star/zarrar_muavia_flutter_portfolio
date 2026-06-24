import '../models/skill_item.dart';

/// One orbital ring of skills around the center hub.
class OrbitRingData {
  const OrbitRingData({
    required this.skills,
    required this.radiusFactor,
    required this.duration,
    this.clockwise = true,
  });

  final List<SkillItem> skills;
  final double radiusFactor;
  final Duration duration;
  final bool clockwise;
}

/// Orbit layout — update skill names to match [AppData] entries.
class SkillOrbitConfig {
  SkillOrbitConfig._();

  static const String centerTitle = 'Flutter Developer';

  static const List<List<String>> orbitSkillNames = [
    ['Flutter', 'Dart', 'Provider'],
    ['REST APIs', 'Firebase', 'Android', 'Java', 'SQLite', 'Responsive UI'],
    ['Git', 'GitHub', 'Clean Architecture', 'TestFlight', 'Android Release Builds'],
  ];

  static const List<Duration> orbitDurations = [
    Duration(seconds: 28),
    Duration(seconds: 40),
    Duration(seconds: 52),
  ];

  static const List<bool> orbitClockwise = [true, false, true];

  static const List<double> orbitRadiusFactors = [0.26, 0.42, 0.58];
}
