import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/scroll_helper.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/education_section.dart';
import '../sections/experience_section.dart';
import '../sections/hero_section.dart';
import '../sections/projects_section.dart';
import '../sections/resume_section.dart';
import '../sections/skills_section.dart';
import '../widgets/background_decorations.dart';
import '../widgets/footer.dart';
import '../widgets/nav_bar.dart';
import '../widgets/section_anchor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  String _activeSection = AppConstants.sectionHome;

  final _sectionKeys = <String, GlobalKey>{
    AppConstants.sectionHome: GlobalKey(),
    AppConstants.sectionAbout: GlobalKey(),
    AppConstants.sectionSkills: GlobalKey(),
    AppConstants.sectionExperience: GlobalKey(),
    AppConstants.sectionProjects: GlobalKey(),
    AppConstants.sectionEducation: GlobalKey(),
    AppConstants.sectionResume: GlobalKey(),
    AppConstants.sectionContact: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    for (final entry in _sectionKeys.entries) {
      final context = entry.value.currentContext;
      if (context == null) continue;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      final offset = box.localToGlobal(Offset.zero).dy;
      if (offset < 200 && offset > -box.size.height + 100) {
        if (_activeSection != entry.key) {
          setState(() => _activeSection = entry.key);
        }
        break;
      }
    }
  }

  void _navigateToSection(String sectionId) {
    final key = _sectionKeys[sectionId];
    if (key == null) return;
    setState(() => _activeSection = sectionId);
    ScrollHelper.scrollToSection(key: key, controller: _scrollController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: NavBar(
        onSectionTap: _navigateToSection,
        activeSection: _activeSection,
      ),
      endDrawer: NavBar.buildDrawer(
        onSectionTap: _navigateToSection,
        activeSection: _activeSection,
        onClose: () => Navigator.of(context).pop(),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: BackgroundDecorations()),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SectionAnchor(
                  sectionKey: _sectionKeys[AppConstants.sectionHome]!,
                  child: HeroSection(
                    onViewProjects: () =>
                        _navigateToSection(AppConstants.sectionProjects),
                    onContact: () =>
                        _navigateToSection(AppConstants.sectionContact),
                  ),
                ),
                SectionAnchor(
                  sectionKey: _sectionKeys[AppConstants.sectionAbout]!,
                  child: const AboutSection(),
                ),
                SectionAnchor(
                  sectionKey: _sectionKeys[AppConstants.sectionSkills]!,
                  child: const SkillsSection(),
                ),
                SectionAnchor(
                  sectionKey: _sectionKeys[AppConstants.sectionExperience]!,
                  child: const ExperienceSection(),
                ),
                SectionAnchor(
                  sectionKey: _sectionKeys[AppConstants.sectionProjects]!,
                  child: const ProjectsSection(),
                ),
                SectionAnchor(
                  sectionKey: _sectionKeys[AppConstants.sectionEducation]!,
                  child: const EducationSection(),
                ),
                SectionAnchor(
                  sectionKey: _sectionKeys[AppConstants.sectionResume]!,
                  child: const ResumeSection(),
                ),
                SectionAnchor(
                  sectionKey: _sectionKeys[AppConstants.sectionContact]!,
                  child: const ContactSection(),
                ),
                SiteFooter(onSectionTap: _navigateToSection),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
