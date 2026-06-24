/// Layout breakpoints and shared constants.
class AppConstants {
  AppConstants._();

  static const String logo = 'Zarrar.dev';

  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double maxContentWidth = 1200;

  static const double sectionVerticalPadding = 96;
  static const double sectionVerticalPaddingMobile = 64;
  static const double horizontalPadding = 24;

  static const String sectionHome = 'home';
  static const String sectionAbout = 'about';
  static const String sectionSkills = 'skills';
  static const String sectionExperience = 'experience';
  static const String sectionProjects = 'projects';
  static const String sectionEducation = 'education';
  static const String sectionResume = 'resume';
  static const String sectionContact = 'contact';

  static const String resumeAssetPath =
      'assets/resume/Muhammad_Zarrar_Muavia_Resume.pdf';
  static const String resumeFileName = 'Muhammad_Zarrar_Muavia_Resume.pdf';

  static const String linkedInUrl =
      'https://www.linkedin.com/in/muhammad-zarrar-muavia-451456415';
  static const String gitHubUrl = 'https://github.com/your-username';
  static const String email = 'zarrarmuavia.dev@gmail.com';
  static const String location = 'Pakistan';

  /// Get a free key at https://web3forms.com using [email] — messages arrive in your inbox.
  static const String web3FormsAccessKey = '6f8b4c56-38b5-4256-84af-2afbf8c40178';

  static const List<String> projectFilters = [
    'All',
    'Flutter',
    'Firebase',
    'Android',
  ];
}
