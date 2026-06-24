import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_data.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';
import 'animated_counter.dart';

/// Premium animated digital book for the About Me section.
class AboutBook extends StatefulWidget {
  const AboutBook({super.key});

  @override
  State<AboutBook> createState() => _AboutBookState();
}

class _AboutBookState extends State<AboutBook> with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _flipController;
  late final AnimationController _shimmerController;
  late final AnimationController _coverPulseController;
  int _currentPage = 0;
  static const _pageCount = 4;

  static const _statThemes = [
    _StatTheme(
      icon: Icons.work_history_rounded,
      colors: [AppColors.primary, AppColors.accentSecondary],
      accent: AppColors.primary,
    ),
    _StatTheme(
      icon: Icons.rocket_launch_rounded,
      colors: [AppColors.accentGreen, AppColors.primary],
      accent: AppColors.accentGreen,
    ),
    _StatTheme(
      icon: Icons.flutter_dash_rounded,
      colors: [AppColors.accent, AppColors.primaryLight],
      accent: AppColors.accent,
    ),
    _StatTheme(
      icon: Icons.school_rounded,
      colors: [AppColors.accentSecondary, AppColors.accent],
      accent: AppColors.accentSecondary,
    ),
  ];

  static const _barThemes = [
    [AppColors.primary, AppColors.accentSecondary],
    [AppColors.accentGreen, AppColors.primary],
    [AppColors.accent, AppColors.primaryLight],
    [AppColors.accentSecondary, AppColors.accentGreen],
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _coverPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flipController.dispose();
    _shimmerController.dispose();
    _coverPulseController.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int page) async {
    if (page < 0 || page >= _pageCount || page == _currentPage) return;
    await _flipController.forward(from: 0);
    if (_pageController.hasClients) {
      await _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    }
    setState(() => _currentPage = page);
    await _flipController.reverse();
  }

  void _next() => _goToPage(_currentPage + 1);
  void _prev() => _goToPage(_currentPage - 1);

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final bookHeight = isMobile ? 540.0 : 580.0;

    return Column(
      children: [
        _bookShell(
          height: bookHeight,
          child: isMobile ? _mobilePages() : _desktopSpread(),
        ),
        const SizedBox(height: 28),
        _navigationControls(isMobile),
      ],
    );
  }

  Widget _bookShell({required double height, required Widget child}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1240), Color(0xFF0A0E1C), Color(0xFF0D1530)],
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.2),
            blurRadius: 48,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 32,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(child: child),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.4),
                      AppColors.accent.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mobilePages() {
    return PageView(
      controller: _pageController,
      onPageChanged: (i) => setState(() => _currentPage = i),
      children: [
        _pageCover(fullPage: true),
        _pageStory(),
        _pageStats(),
        _pageStrengths(),
      ],
    );
  }

  Widget _desktopSpread() {
    return AnimatedBuilder(
      animation: _flipController,
      builder: (context, _) {
        final tilt = _flipController.value * 0.05;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(tilt),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.04, 0),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Row(
              key: ValueKey(_currentPage),
              children: [
                Expanded(child: _leftPageForSpread(_currentPage)),
                _bookSpine(),
                Expanded(child: _rightPageForSpread(_currentPage)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _leftPageForSpread(int spread) => switch (spread) {
        0 => _pageCover(fullPage: false),
        1 => _pageStory(),
        2 => _pageStats(),
        _ => _pageStrengths(),
      };

  Widget _rightPageForSpread(int spread) => switch (spread) {
        0 => _pageStory(),
        1 => _pageStats(),
        2 => _pageStrengths(),
        _ => _pageEnd(),
      };

  Widget _bookSpine() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, _) {
        return Container(
          width: 16,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.accent.withValues(alpha: 0.3 + _shimmerController.value * 0.2),
                AppColors.primary.withValues(alpha: 0.5),
                AppColors.accent.withValues(alpha: 0.3 + _shimmerController.value * 0.2),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bookPage({
    required Widget child,
    required int pageNumber,
    required _PageStyle style,
    bool isLeft = true,
  }) {
    return Container(
      decoration: BoxDecoration(gradient: style.gradient),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _PageGridPainter(style.accent))),
          Positioned(
            top: -40,
            right: isLeft ? -40 : null,
            left: isLeft ? null : -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: style.accent.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 36, 28, 48),
            child: child,
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: style.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: style.accent.withValues(alpha: 0.25)),
                ),
                child: Text(
                  'Page $pageNumber',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: style.accent.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chapterBadge(String chapter, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.25),
            accent.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Text(
        chapter,
        style: GoogleFonts.inter(
          fontSize: 10,
          letterSpacing: 2,
          color: accent,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _pageHeader({
    required String chapter,
    required String title,
    required Color accent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _chapterBadge(chapter, accent),
        const SizedBox(height: 22),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 48,
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accent, accent.withValues(alpha: 0.2)],
            ),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(color: accent.withValues(alpha: 0.4), blurRadius: 8),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _pageCover({required bool fullPage}) {
    return _bookPage(
      pageNumber: 1,
      style: _PageStyle.cover,
      child: AnimatedBuilder(
        animation: _coverPulseController,
        builder: (context, _) {
          final pulse = 1 + _coverPulseController.value * 0.06;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: pulse,
                  child: Container(
                    width: fullPage ? 120 : 100,
                    height: fullPage ? 120 : 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.ctaGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.45),
                          blurRadius: 28 * pulse,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          blurRadius: 40,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 56,
                      color: AppColors.background,
                    ),
                  ),
                ),
                SizedBox(height: fullPage ? 28 : 22),
                ShaderMask(
                  shaderCallback: (b) => AppColors.accentGradient.createShader(b),
                  child: Text(
                    'About Me',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: fullPage ? 38 : 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppData.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: fullPage ? 15 : 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.2),
                        AppColors.accent.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    'Flutter Specialist',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
                if (fullPage) ...[
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swipe_rounded, size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Text(
                        'Swipe to explore',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.96, 0.96));
  }

  Widget _pageStory() {
    return _bookPage(
      pageNumber: 2,
      style: _PageStyle.story,
      isLeft: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pageHeader(
            chapter: 'CHAPTER I',
            title: 'My Story',
            accent: _PageStyle.story.accent,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                AppData.aboutText,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  height: 1.85,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageStats() {
    return _bookPage(
      pageNumber: 3,
      style: _PageStyle.stats,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pageHeader(
            chapter: 'CHAPTER II',
            title: 'At a Glance',
            accent: _PageStyle.stats.accent,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: AppData.quickStats.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final stat = AppData.quickStats[index];
                final theme = _statThemes[index % _statThemes.length];
                return _statCard(stat, theme, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(Map<String, dynamic> stat, _StatTheme theme, int index) {
    final textValue = stat['text'] as String?;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colors[0].withValues(alpha: 0.15),
            theme.colors[1].withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.accent.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: theme.accent.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: theme.colors),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(theme.icon, color: AppColors.background, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (textValue != null)
                  ShaderMask(
                    shaderCallback: (b) => LinearGradient(colors: theme.colors).createShader(b),
                    child: Text(
                      textValue,
                      style: GoogleFonts.inter(
                        fontSize: textValue.length > 12 ? 15 : 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  )
                else
                  AnimatedCounter(
                    value: stat['value'] as int,
                    suffix: stat['suffix'] as String? ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      foreground: Paint()
                        ..shader = LinearGradient(colors: theme.colors).createShader(
                          const Rect.fromLTWH(0, 0, 80, 40),
                        ),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  stat['label'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: (index * 120).ms)
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.08, end: 0);
  }

  Widget _pageStrengths() {
    return _bookPage(
      pageNumber: 4,
      style: _PageStyle.strengths,
      isLeft: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pageHeader(
            chapter: 'CHAPTER III',
            title: 'Core Strengths',
            accent: _PageStyle.strengths.accent,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: AppData.aboutProgress.length,
              separatorBuilder: (context, index) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final item = AppData.aboutProgress[index];
                final colors = _barThemes[index % _barThemes.length];
                return _glowProgressBar(
                  label: item['label'] as String,
                  value: item['value'] as double,
                  colors: colors,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowProgressBar({
    required String label,
    required double value,
    required List<Color> colors,
    required int index,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colors[0].withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors[0].withValues(alpha: 0.35)),
              ),
              child: Text(
                '${(value * 100).toInt()}%',
                style: GoogleFonts.inter(
                  color: colors[0],
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, _) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value),
              duration: Duration(milliseconds: 1200 + index * 250),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) {
                return Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.border.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: v.clamp(0.0, 1.0),
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(colors: colors),
                          boxShadow: [
                            BoxShadow(
                              color: colors[0].withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (v > 0.05)
                      Positioned(
                        left: (v * 280 * _shimmerController.value).clamp(0.0, 200.0),
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0),
                                Colors.white.withValues(alpha: 0.35),
                                Colors.white.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ],
    ).animate(delay: (index * 100).ms).fadeIn(duration: 450.ms);
  }

  Widget _pageEnd() {
    return _bookPage(
      pageNumber: 5,
      style: _PageStyle.end,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.25),
                    AppColors.accent.withValues(alpha: 0.25),
                  ],
                ),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.auto_stories_rounded, size: 44, color: AppColors.primary),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.08, 1.08),
                  duration: 1800.ms,
                ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (b) => AppColors.accentGradient.createShader(b),
              child: Text(
                'The End',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Thank you for reading my story.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '— ${AppData.name}',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navigationControls(bool isMobile) {
    final labels = isMobile
        ? ['Cover', 'Story', 'Stats', 'Skills']
        : ['Cover & Story', 'Story & Stats', 'Stats & Skills', 'Finale'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _navButton(icon: Icons.chevron_left_rounded, onTap: _currentPage > 0 ? _prev : null),
        const SizedBox(width: 20),
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_pageCount, (i) {
                final active = i == _currentPage;
                return GestureDetector(
                  onTap: () => _goToPage(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: active ? AppColors.accentGradient : null,
                      color: active ? null : AppColors.border,
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.5),
                                blurRadius: 10,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Text(
              labels[_currentPage.clamp(0, labels.length - 1)],
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(width: 20),
        _navButton(
          icon: Icons.chevron_right_rounded,
          onTap: _currentPage < _pageCount - 1 ? _next : null,
        ),
      ],
    );
  }

  Widget _navButton({required IconData icon, VoidCallback? onTap}) {
    final enabled = onTap != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: enabled
                ? LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.accent.withValues(alpha: 0.15),
                    ],
                  )
                : null,
            color: enabled ? null : AppColors.surface,
            border: Border.all(
              color: enabled ? AppColors.primary.withValues(alpha: 0.6) : AppColors.border,
            ),
            boxShadow: enabled
                ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 14)]
                : [],
          ),
          child: Icon(icon, color: enabled ? AppColors.primary : AppColors.textMuted),
        ),
      ),
    );
  }
}

class _StatTheme {
  const _StatTheme({
    required this.icon,
    required this.colors,
    required this.accent,
  });

  final IconData icon;
  final List<Color> colors;
  final Color accent;
}

class _PageStyle {
  const _PageStyle({required this.gradient, required this.accent});

  final LinearGradient gradient;
  final Color accent;

  static final cover = _PageStyle(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF1A0F35),
        const Color(0xFF0F1A3D),
        const Color(0xFF12102A),
      ],
    ),
    accent: AppColors.accent,
  );

  static final story = _PageStyle(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [const Color(0xFF0F1629), const Color(0xFF131D38)],
    ),
    accent: AppColors.primary,
  );

  static final stats = _PageStyle(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [const Color(0xFF101828), const Color(0xFF0D1F2D)],
    ),
    accent: AppColors.accentGreen,
  );

  static final strengths = _PageStyle(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [const Color(0xFF141030), const Color(0xFF0F1830)],
    ),
    accent: AppColors.accentSecondary,
  );

  static final end = _PageStyle(
    gradient: LinearGradient(
      colors: [const Color(0xFF120F28), const Color(0xFF0A1020)],
    ),
    accent: AppColors.primary,
  );
}

class _PageGridPainter extends CustomPainter {
  _PageGridPainter(this.accent);

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = accent.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.8, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PageGridPainter oldDelegate) =>
      oldDelegate.accent != accent;
}
