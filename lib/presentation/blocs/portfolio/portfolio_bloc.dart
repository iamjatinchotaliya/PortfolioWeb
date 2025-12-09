import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/data_repository.dart';
import '../../../data/models/personal_info.dart';
import '../../../data/models/skill.dart';
import '../../../data/models/project.dart';
import '../../../data/models/experience.dart';
import '../../../data/models/blog_post.dart';
import '../../../data/models/contact.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final DataRepository repository;

  PortfolioBloc({required this.repository}) : super(const PortfolioInitial()) {
    on<LoadPortfolioData>(_onLoadPortfolioData);
  }

  Future<void> _onLoadPortfolioData(LoadPortfolioData event, Emitter<PortfolioState> emit) async {
    emit(const PortfolioLoading());

    try {
      final results = await Future.wait([
        repository.getPersonalInfo(),
        repository.getSkills(),
        repository.getProjects(),
        repository.getExperience(),
        repository.getBlogPosts(),
        repository.getContactInfo(),
      ]);

      emit(
        PortfolioLoaded(
          personalInfo: results[0] as PersonalInfo,
          skillCategories: results[1] as List<SkillCategory>,
          projects: results[2] as List<Project>,
          experiences: results[3] as List<Experience>,
          blogPosts: results[4] as List<BlogPost>,
          contact: results[5] as ContactInfo,
        ),
      );
    } catch (e) {
      emit(PortfolioError('Error loading data: ${e.toString()}'));
    }
  }
}
