class ProjectItem {
  const ProjectItem({
    required this.title,
    required this.description,
    required this.techStack,
    required this.imagePath,
    required this.category,
    this.gitHubUrl,
    this.detailsUrl,
    this.isFeatured = false,
  });

  final String title;
  final String description;
  final List<String> techStack;
  final String imagePath;
  final String category;
  final String? gitHubUrl;
  final String? detailsUrl;
  final bool isFeatured;
}
