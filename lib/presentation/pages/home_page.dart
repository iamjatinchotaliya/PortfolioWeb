import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/data_repository.dart';
import '../../core/constants/app_constants.dart';
import '../blocs/portfolio/portfolio_bloc.dart';
import '../blocs/portfolio/portfolio_event.dart';
import '../blocs/portfolio/portfolio_state.dart';
import '../widgets/navigation/custom_navbar.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/skills_section.dart';
import '../widgets/sections/projects_section.dart';
import '../widgets/sections/experience_section.dart';
import '../widgets/sections/blog_section.dart';
import '../widgets/sections/contact_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PortfolioBloc(repository: DataRepository())..add(const LoadPortfolioData()),
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final Map<String, GlobalKey> sectionKeys = {
      AppConstants.homeSectionId: GlobalKey(),
      AppConstants.aboutSectionId: GlobalKey(),
      AppConstants.skillsSectionId: GlobalKey(),
      AppConstants.projectsSectionId: GlobalKey(),
      AppConstants.experienceSectionId: GlobalKey(),
      AppConstants.blogSectionId: GlobalKey(),
      AppConstants.contactSectionId: GlobalKey(),
    };

    void scrollToSection(String sectionId) {
      final key = sectionKeys[sectionId];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(key!.currentContext!, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
      }
    }

    return Scaffold(
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          if (state is PortfolioLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PortfolioError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Failed to load portfolio data', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(state.message, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PortfolioBloc>().add(const LoadPortfolioData());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PortfolioLoaded) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    // Hero Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: sectionKeys[AppConstants.homeSectionId],
                        child: HeroSection(personalInfo: state.personalInfo, onNavigate: scrollToSection),
                      ),
                    ),

                    // About Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: sectionKeys[AppConstants.aboutSectionId],
                        child: AboutSection(personalInfo: state.personalInfo),
                      ),
                    ),

                    // Skills Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: sectionKeys[AppConstants.skillsSectionId],
                        child: SkillsSection(skillCategories: state.skillCategories),
                      ),
                    ),

                    // Projects Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: sectionKeys[AppConstants.projectsSectionId],
                        child: ProjectsSection(projects: state.projects),
                      ),
                    ),

                    // Experience Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: sectionKeys[AppConstants.experienceSectionId],
                        child: ExperienceSection(experiences: state.experiences),
                      ),
                    ),

                    // Blog Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: sectionKeys[AppConstants.blogSectionId],
                        child: BlogSection(blogPosts: state.blogPosts),
                      ),
                    ),

                    // Contact Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: sectionKeys[AppConstants.contactSectionId],
                        child: ContactSection(contact: state.contact),
                      ),
                    ),
                  ],
                ),

                // Navigation Bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CustomNavBar(scrollController: scrollController, onNavItemTap: scrollToSection),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
