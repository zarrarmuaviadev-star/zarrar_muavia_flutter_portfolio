import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_data.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import '../models/orbit_ring_data.dart';
import '../models/skill_item.dart';

/// Premium tech-stack orbit with icon nodes and an All Skills reference bar.
class TechStackOrbit extends StatefulWidget {
  const TechStackOrbit({super.key});

  @override
  State<TechStackOrbit> createState() => _TechStackOrbitState();
}

class _TechStackOrbitState extends State<TechStackOrbit>
    with TickerProviderStateMixin {
  static const _nodeSize = 52.0;

  late final List<AnimationController> _controllers;
  final Set<int> _pausedOrbits = {};
  String? _hoveredSkill;

  List<OrbitRingData> get _rings => _buildRings();

  SkillItem? get _activeSkill {
    if (_hoveredSkill == null) return null;
    for (final ring in _rings) {
      for (final s in ring.skills) {
        if (s.name == _hoveredSkill) return s;
      }
    }
    return null;
  }

  int? get _activeOrbitIndex {
    if (_hoveredSkill == null) return null;
    for (var i = 0; i < _rings.length; i++) {
      if (_rings[i].skills.any((s) => s.name == _hoveredSkill)) return i;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      SkillOrbitConfig.orbitDurations.length,
      (i) => AnimationController(
        vsync: this,
        duration: SkillOrbitConfig.orbitDurations[i],
      )..repeat(),
    );
    for (var i = 0; i < _controllers.length; i++) {
      if (!SkillOrbitConfig.orbitClockwise[i]) {
        _controllers[i].value = 1;
        _controllers[i].repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<OrbitRingData> _buildRings() {
    final skillMap = <String, SkillItem>{
      for (final cat in AppData.skillCategories)
        for (final s in cat.skills) s.name: s,
    };

    return List.generate(SkillOrbitConfig.orbitSkillNames.length, (i) {
      final names = SkillOrbitConfig.orbitSkillNames[i];
      final skills = names.map((n) => skillMap[n]).whereType<SkillItem>().toList();
      return OrbitRingData(
        skills: skills,
        radiusFactor: SkillOrbitConfig.orbitRadiusFactors[i],
        duration: SkillOrbitConfig.orbitDurations[i],
        clockwise: SkillOrbitConfig.orbitClockwise[i],
      );
    });
  }

  void _pauseOrbit(int index) {
    _pausedOrbits.add(index);
    _controllers[index].stop();
  }

  void _resumeOrbit(int index) {
    _pausedOrbits.remove(index);
    final ctrl = _controllers[index];
    if (SkillOrbitConfig.orbitClockwise[index]) {
      ctrl.repeat();
    } else {
      ctrl.repeat(reverse: true);
    }
  }

  void _selectSkill(String name, int orbitIndex) {
    setState(() => _hoveredSkill = name);
    _pauseOrbit(orbitIndex);
  }

  void _clearSkill(int orbitIndex) {
    setState(() => _hoveredSkill = null);
    _resumeOrbit(orbitIndex);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final size = isMobile ? 360.0 : 540.0;

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final side = math.min(constraints.maxWidth, constraints.maxHeight);
                return Center(
                  child: SizedBox(
                    width: side,
                    height: side,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        ...List.generate(_rings.length, (i) => _orbitRing(i, side)),
                        _centerHub(isMobile),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: isMobile ? 40 : 56),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 0),
          child: _skillInspector(isMobile),
        ),
        SizedBox(height: isMobile ? 24 : 28),
        _skillQuickReference(isMobile),
        const SizedBox(height: 20),
        _legend(),
      ],
    );
  }

  Widget _orbitRing(int orbitIndex, double side) {
    final ring = _rings[orbitIndex];
    final radius = side * ring.radiusFactor;

    return AnimatedBuilder(
      animation: _controllers[orbitIndex],
      builder: (context, _) {
        final rotation = _controllers[orbitIndex].value * 2 * math.pi;
        final angleOffset = orbitIndex.isOdd ? math.pi / 6 : 0.0;

        return CustomPaint(
          size: Size(side, side),
          painter: _OrbitTrackPainter(radius: radius, orbitIndex: orbitIndex),
          child: Stack(
            clipBehavior: Clip.none,
            children: List.generate(ring.skills.length, (i) {
              final skill = ring.skills[i];
              final angle =
                  angleOffset + (2 * math.pi * i / ring.skills.length) + rotation;
              final x = side / 2 + radius * math.cos(angle) - _nodeSize / 2;
              final y = side / 2 + radius * math.sin(angle) - _nodeSize / 2;
              final isHovered = _hoveredSkill == skill.name;

              // Counter-rotate so icons stay upright while orbiting.
              return Positioned(
                left: x,
                top: y,
                child: Transform.rotate(
                  angle: -rotation,
                  child: _skillNode(
                    skill: skill,
                    orbitIndex: orbitIndex,
                    isHovered: isHovered,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _skillNode({
    required SkillItem skill,
    required int orbitIndex,
    required bool isHovered,
  }) {
    return MouseRegion(
      onEnter: (_) => _selectSkill(skill.name, orbitIndex),
      onExit: (_) => _clearSkill(orbitIndex),
      child: GestureDetector(
        onTap: () => _selectSkill(skill.name, orbitIndex),
        child: AnimatedScale(
          scale: isHovered ? 1.18 : 1.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: isHovered ? 52 : 46,
            height: isHovered ? 52 : 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isHovered
                  ? AppColors.ctaGradient
                  : LinearGradient(
                      colors: [AppColors.surfaceLight, AppColors.card],
                    ),
              border: Border.all(
                color: isHovered ? AppColors.primary : AppColors.border,
                width: isHovered ? 2 : 1,
              ),
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.45),
                        blurRadius: 18,
                        spreadRadius: 1,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 6,
                      ),
                    ],
            ),
            child: Icon(
              skill.icon,
              size: isHovered ? 24 : 20,
              color: isHovered ? AppColors.background : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  /// Detail card — shows hovered skill or a helpful default message.
  Widget _skillInspector(bool isMobile) {
    final skill = _activeSkill;
    final orbit = _activeOrbitIndex;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: isMobile ? 360 : 480),
      margin: const EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 24,
        vertical: isMobile ? 18 : 22,
      ),
      decoration: BoxDecoration(
        gradient: skill != null
            ? LinearGradient(
                colors: [
                  AppColors.surfaceLight,
                  AppColors.card,
                ],
              )
            : null,
        color: skill == null ? AppColors.surface.withValues(alpha: 0.5) : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: skill != null
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.border,
        ),
        boxShadow: skill != null
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 24,
                ),
              ]
            : [],
      ),
      child: skill == null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app_outlined, size: 20, color: AppColors.textMuted),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    isMobile
                        ? 'Tap any skill to see details'
                        : 'Hover any orbiting skill to inspect proficiency',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(skill.icon, color: AppColors.background, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              skill.name,
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (orbit != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _orbitColor(orbit).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _orbitColor(orbit).withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                'Orbit ${orbit + 1}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _orbitColor(orbit),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: skill.proficiency / 100,
                                minHeight: 7,
                                backgroundColor: AppColors.border,
                                valueColor: AlwaysStoppedAnimation(_orbitColor(orbit ?? 0)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${skill.proficiency.toInt()}%',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w800,
                              color: _orbitColor(orbit ?? 0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// Scrollable chip bar — always-visible icon + name reference for every skill.
  Widget _skillQuickReference(bool isMobile) {
    final allSkills = _rings.expand((r) => r.skills).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Skills',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: allSkills.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final skill = allSkills[index];
              final isActive = _hoveredSkill == skill.name;
              return MouseRegion(
                onEnter: (_) {
                  final orbitIdx = _activeOrbitIndexFor(skill.name);
                  if (orbitIdx != null) _selectSkill(skill.name, orbitIdx);
                },
                onExit: (_) {
                  final orbitIdx = _activeOrbitIndexFor(skill.name);
                  if (orbitIdx != null) _clearSkill(orbitIdx);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        skill.icon,
                        size: 16,
                        color: isActive ? AppColors.primary : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        skill.name,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? AppColors.primaryLight : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  int? _activeOrbitIndexFor(String name) {
    for (var i = 0; i < _rings.length; i++) {
      if (_rings[i].skills.any((s) => s.name == name)) return i;
    }
    return null;
  }

  Color _orbitColor(int index) => const [
        AppColors.primary,
        AppColors.accentSecondary,
        AppColors.accent,
      ][index % 3];

  Widget _centerHub(bool isMobile) {
    final hubSize = isMobile ? 108.0 : 132.0;

    return Container(
      width: hubSize,
      height: hubSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.accentGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flutter_dash_rounded,
            size: isMobile ? 34 : 42,
            color: AppColors.background,
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              SkillOrbitConfig.centerTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 10 : 12,
                fontWeight: FontWeight.w800,
                color: AppColors.background,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20,
      runSpacing: 8,
      children: const [
        _LegendItem(color: AppColors.primary, label: 'Orbit 1 · Core Stack'),
        _LegendItem(color: AppColors.accentSecondary, label: 'Orbit 2 · Mobile & API'),
        _LegendItem(color: AppColors.accent, label: 'Orbit 3 · Tools & Deploy'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _OrbitTrackPainter extends CustomPainter {
  _OrbitTrackPainter({required this.radius, required this.orbitIndex});

  final double radius;
  final int orbitIndex;

  static const _colors = [
    AppColors.primary,
    AppColors.accentSecondary,
    AppColors.accent,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final color = _colors[orbitIndex % _colors.length];

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawCircle(center, radius, glowPaint);

    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const dashCount = 60;
    const dashSweep = 2 * math.pi / dashCount * 0.45;
    for (var i = 0; i < dashCount; i++) {
      final start = 2 * math.pi * i / dashCount;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        dashSweep,
        false,
        trackPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitTrackPainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.orbitIndex != orbitIndex;
}
