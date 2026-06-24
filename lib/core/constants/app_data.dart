import 'package:flutter/material.dart';

import '../../models/education_item.dart';
import '../../models/experience_item.dart';
import '../../models/project_item.dart';
import '../../models/skill_category.dart';
import '../../models/skill_item.dart';

/// Portfolio content — update this file to change site content easily.
class AppData {
  AppData._();

  static const String name = 'Muhammad Zarrar Muavia';
  static const String title = 'Associate Software Engineer | Flutter Developer';
  static const String heroIntro =
      'I build high-quality, responsive, and scalable mobile applications using Flutter, Dart, REST APIs, and clean architecture.';

  static const List<String> typingRoles = [
    'Flutter Developer',
    'Mobile App Developer',
    'Associate Software Engineer',
  ];

  static const String aboutText =
      'I am a Software Engineering graduate from The Islamia University of Bahawalpur with experience in Flutter mobile app development, REST API integration, responsive UI development, state management, Firebase, and Android development. I enjoy building clean, user-friendly, and production-ready applications.';

  static const List<Map<String, dynamic>> quickStats = [
    {'label': 'Years Experience', 'value': 1, 'suffix': '+'},
    {'label': 'Projects', 'value': 10, 'suffix': '+'},
    {'label': 'Specialization', 'value': 0, 'text': 'Flutter'},
    {'label': 'Degree', 'value': 0, 'text': 'BS Software Eng.'},
  ];

  static const List<Map<String, dynamic>> aboutProgress = [
    {'label': 'Flutter Development', 'value': 0.92},
    {'label': 'REST API Integration', 'value': 0.88},
    {'label': 'UI/UX Implementation', 'value': 0.85},
    {'label': 'Mobile App Deployment', 'value': 0.80},
  ];

  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      title: 'Mobile Development',
      skills: [
        SkillItem(name: 'Flutter', icon: Icons.flutter_dash, proficiency: 92),
        SkillItem(name: 'Dart', icon: Icons.code, proficiency: 90),
        SkillItem(name: 'Android', icon: Icons.android, proficiency: 82),
        SkillItem(name: 'Java', icon: Icons.terminal, proficiency: 75),
        SkillItem(name: 'Responsive UI', icon: Icons.devices, proficiency: 88),
      ],
    ),
    SkillCategory(
      title: 'State Management',
      skills: [
        SkillItem(name: 'Provider', icon: Icons.hub, proficiency: 88),
        SkillItem(name: 'Clean Architecture', icon: Icons.architecture, proficiency: 85),
      ],
    ),
    SkillCategory(
      title: 'Backend / API',
      skills: [
        SkillItem(name: 'REST APIs', icon: Icons.api, proficiency: 90),
        SkillItem(name: 'Firebase', icon: Icons.local_fire_department, proficiency: 85),
        SkillItem(name: 'SQLite', icon: Icons.storage, proficiency: 78),
      ],
    ),
    SkillCategory(
      title: 'Tools & Deployment',
      skills: [
        SkillItem(name: 'Git', icon: Icons.merge_type, proficiency: 88),
        SkillItem(name: 'GitHub', icon: Icons.code, proficiency: 90),
        SkillItem(name: 'TestFlight', icon: Icons.flight_takeoff, proficiency: 75),
        SkillItem(name: 'Android Release Builds', icon: Icons.build_circle, proficiency: 85),
      ],
    ),
  ];

  static const List<ExperienceItem> experiences = [
    ExperienceItem(
      company: 'Nestosh Pvt Ltd',
      role: 'Associate Software Engineer — Flutter',
      period: 'Jun 2026 – Present',
      responsibilities: [
        'Working on production Flutter mobile applications.',
        'Integrating REST APIs and improving app performance.',
        'Handling multi-flavor app builds, localization, UI fixes, and release builds.',
      ],
    ),
    ExperienceItem(
      company: '20Three Digital',
      role: 'Associate Software Engineer',
      period: 'Jul 2025 – Jan 2026',
      responsibilities: [
        'Developed Flutter applications using Dart.',
        'Integrated APIs and created responsive UI screens.',
        'Worked with state management, debugging, and performance improvements.',
      ],
    ),
    ExperienceItem(
      company: 'CAS - Center of Advanced Solutions',
      role: 'Junior Android Developer',
      period: 'Jan 2025 – Jun 2025',
      responsibilities: [
        'Developed Android applications using Java and XML.',
        'Worked with REST APIs, SQLite, and mobile UI development.',
      ],
    ),
  ];

  static const List<ProjectItem> projects = [
    ProjectItem(
      title: 'Oleochemicals Asia Mobile App',
      description:
          'Flutter app with multi-flavor architecture, product modules, market insights, search, localization, shipment tracking, and API integrations.',
      techStack: [
        'Flutter',
        'Dart',
        'Provider',
        'REST APIs',
        'Google Maps',
        'TradingView',
      ],
      imagePath: 'assets/images/project_oleochemicals.png',
      category: 'Flutter',
      gitHubUrl: 'https://github.com/your-username',
      isFeatured: true,
    ),
    ProjectItem(
      title: 'Expense Manager App',
      description:
          'Personal finance management app with expense tracking, categories, reports, and clean UI.',
      techStack: ['Flutter', 'Dart', 'Local Storage'],
      imagePath: 'assets/images/project_expense.png',
      category: 'Flutter',
      gitHubUrl: 'https://github.com/your-username',
    ),
    ProjectItem(
      title: 'Firebase Chat App',
      description:
          'Real-time chat application with authentication and Firestore.',
      techStack: ['Flutter', 'Firebase Auth', 'Firestore'],
      imagePath: 'assets/images/project_chat.png',
      category: 'Firebase',
      gitHubUrl: 'https://github.com/your-username',
    ),
    ProjectItem(
      title: 'Android Notes App',
      description: 'Native Android notes app with offline database support.',
      techStack: ['Java', 'XML', 'SQLite'],
      imagePath: 'assets/images/project_notes.png',
      category: 'Android',
      gitHubUrl: 'https://github.com/your-username',
    ),
  ];

  static const List<EducationItem> education = [
    EducationItem(
      institution: 'The Islamia University of Bahawalpur',
      degree: 'BS Software Engineering',
      period: '2021 – 2025',
      details: 'CGPA: 3.73 / 4.00',
    ),
  ];
}
