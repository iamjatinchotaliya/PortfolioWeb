import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/navigation/custom_navbar.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/skills_section.dart';
import '../widgets/sections/projects_section.dart';
import '../widgets/sections/experience_section.dart';
import '../widgets/sections/blog_section.dart';
import '../widgets/sections/contact_section.dart';
import '../widgets/common/portfolio_loader.dart';
import '../widgets/common/animated_background.dart';
import '../widgets/common/cursor_glow.dart';
import '../widgets/common/scroll_progress_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePageView();
  }
}

class HomePageView extends ConsumerStatefulWidget {
  const HomePageView({super.key});

  @override
  ConsumerState<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends ConsumerState<HomePageView> {
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollToSection(String sectionId) {
    final key = sectionKeys[sectionId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = ref.watch(portfolioProvider);
    return Scaffold(
      body: TweenAnimationBuilder<double>(
        key: ValueKey(
          portfolio.isLoading
              ? 'loading'
              : portfolio.hasError
              ? 'error'
              : 'content',
        ),
        tween: Tween(begin: portfolio.hasValue ? 0.0 : 1.0, end: 1.0),
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        builder: (context, opacity, child) =>
            Opacity(opacity: opacity, child: child),
        child: portfolio.when(
          skipLoadingOnRefresh: false,
          loading: () => const PortfolioLoader(),
          error: (error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load portfolio data',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error loading data: $error',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(dataRepositoryProvider).clearCache();
                      ref.invalidate(portfolioProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          },
          data: (state) {
            return AnimatedBackground(
              child: CursorGlow(
                child: Stack(
                  children: [
                    RepaintBoundary(
                      child: CustomScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        cacheExtent: 1000, // Cache for smoother scrolling
                        slivers: [
                          // Hero Section
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: Container(
                                key: sectionKeys[AppConstants.homeSectionId],
                                child: HeroSection(
                                  personalInfo: state.personalInfo,
                                  onNavigate: scrollToSection,
                                ),
                              ),
                            ),
                          ),

                          // About Section
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: Container(
                                key: sectionKeys[AppConstants.aboutSectionId],
                                child: AboutSection(
                                  personalInfo: state.personalInfo,
                                ),
                              ),
                            ),
                          ),

                          // Skills Section
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: Container(
                                key: sectionKeys[AppConstants.skillsSectionId],
                                child: SkillsSection(
                                  skillCategories: state.skillCategories,
                                ),
                              ),
                            ),
                          ),

                          // Projects Section
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: Container(
                                key:
                                    sectionKeys[AppConstants.projectsSectionId],
                                child: ProjectsSection(
                                  projects: state.projects,
                                ),
                              ),
                            ),
                          ),

                          // Experience Section
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: Container(
                                key:
                                    sectionKeys[AppConstants
                                        .experienceSectionId],
                                child: ExperienceSection(
                                  experiences: state.experiences,
                                ),
                              ),
                            ),
                          ),

                          // Blog Section
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: Container(
                                key: sectionKeys[AppConstants.blogSectionId],
                                child: BlogSection(blogPosts: state.blogPosts),
                              ),
                            ),
                          ),

                          // Contact Section
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: Container(
                                key: sectionKeys[AppConstants.contactSectionId],
                                child: ContactSection(contact: state.contact),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Navigation Bar
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: RepaintBoundary(
                        child: CustomNavBar(
                          scrollController: scrollController,
                          onNavItemTap: scrollToSection,
                        ),
                      ),
                    ),

                    // Scroll Progress Indicator
                    ScrollProgressIndicator(scrollController: scrollController),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
