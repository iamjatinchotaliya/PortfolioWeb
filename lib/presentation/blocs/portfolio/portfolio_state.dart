import 'package:equatable/equatable.dart';
import '../../../data/models/personal_info.dart';
import '../../../data/models/skill.dart';
import '../../../data/models/project.dart';
import '../../../data/models/experience.dart';
import '../../../data/models/blog_post.dart';
import '../../../data/models/contact.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

class PortfolioLoaded extends PortfolioState {
  final PersonalInfo personalInfo;
  final List<SkillCategory> skillCategories;
  final List<Project> projects;
  final List<Experience> experiences;
  final List<BlogPost> blogPosts;
  final ContactInfo contact;

  const PortfolioLoaded({
    required this.personalInfo,
    required this.skillCategories,
    required this.projects,
    required this.experiences,
    required this.blogPosts,
    required this.contact,
  });

  @override
  List<Object?> get props => [personalInfo, skillCategories, projects, experiences, blogPosts, contact];
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
