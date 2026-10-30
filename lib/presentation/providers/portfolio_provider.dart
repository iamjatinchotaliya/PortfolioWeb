import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/blog_post.dart';
import '../../data/models/contact.dart';
import '../../data/models/experience.dart';
import '../../data/models/personal_info.dart';
import '../../data/models/project.dart';
import '../../data/models/skill.dart';
import '../../data/repositories/data_repository.dart';

final dataRepositoryProvider = Provider<DataRepository>((ref) {
  final repository = DataRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

// Loading and errors are represented by AsyncValue. The UI offers an explicit
// retry, matching the existing portfolio loading behavior.
final portfolioProvider = FutureProvider.autoDispose<PortfolioData>((
  ref,
) async {
  final repository = ref.watch(dataRepositoryProvider);
  final results = await (
    repository.getPersonalInfo(),
    repository.getSkills(),
    repository.getProjects(),
    repository.getExperience(),
    repository.getBlogPosts(),
    repository.getContactInfo(),
  ).wait;

  return PortfolioData(
    personalInfo: results.$1,
    skillCategories: results.$2,
    projects: results.$3,
    experiences: results.$4,
    blogPosts: results.$5,
    contact: results.$6,
  );
}, retry: (retryCount, error) => null);

class PortfolioData {
  const PortfolioData({
    required this.personalInfo,
    required this.skillCategories,
    required this.projects,
    required this.experiences,
    required this.blogPosts,
    required this.contact,
  });

  final PersonalInfo personalInfo;
  final List<SkillCategory> skillCategories;
  final List<Project> projects;
  final List<Experience> experiences;
  final List<BlogPost> blogPosts;
  final ContactInfo contact;
}
