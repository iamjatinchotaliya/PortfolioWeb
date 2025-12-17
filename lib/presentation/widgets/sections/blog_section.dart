import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/models/blog_post.dart';
import '../../blocs/filter/filter_bloc.dart';
import '../../blocs/filter/filter_event.dart';
import '../../blocs/filter/filter_state.dart';
import '../common/animated_card.dart';
import '../common/scroll_reveal_widget.dart';
import 'package:go_router/go_router.dart';

class BlogSection extends StatelessWidget {
  final List<BlogPost> blogPosts;

  const BlogSection({super.key, required this.blogPosts});

  List<String> _extractCategories() {
    final uniqueCategories = blogPosts.where((post) => post.published).map((post) => post.category).toSet().toList();
    return ['All', ...uniqueCategories];
  }

  List<BlogPost> _filterPosts(String selectedCategory) {
    if (selectedCategory == 'All' || selectedCategory.isEmpty) {
      return blogPosts.where((post) => post.published).toList();
    }
    return blogPosts.where((post) => post.published && post.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final categories = _extractCategories();

    return BlocProvider(
      create: (context) => FilterBloc(),
      child: Container(
        width: double.infinity,
        padding: ResponsiveHelper.getResponsivePadding(context).copyWith(top: isMobile ? 60 : 100, bottom: isMobile ? 60 : 100),
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: AppConstants.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                ScrollRevealWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Blog & Articles', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        height: 4,
                        width: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 24),

                // Subtitle
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Thoughts, tutorials, and insights on web development',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  ),
                ),
                SizedBox(height: isMobile ? 32 : 48),

                // Category Filter
                ScrollRevealWidget(delay: const Duration(milliseconds: 300), child: _buildCategoryFilter(context, categories)),
                SizedBox(height: isMobile ? 32 : 48),

                // Blog Posts Grid
                ScrollRevealWidget(delay: const Duration(milliseconds: 400), child: _buildBlogGrid(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context, List<String> categories) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        final selectedCategory = state.selectedCategory.isEmpty ? 'All' : state.selectedCategory;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () {
                    context.read<FilterBloc>().add(ChangeCategory(category));
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      category,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildBlogGrid(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        final filteredPosts = _filterPosts(state.selectedCategory);

        if (filteredPosts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Text(
                'No blog posts found',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
              ),
            ),
          );
        }

        return AnimationLimiter(
          child: GridView.builder(
            key: ValueKey(state.selectedCategory),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: isMobile ? 0.9 : 0.75,
            ),
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: isMobile ? 1 : (isTablet ? 2 : 3),
                child: SlideAnimation(verticalOffset: 50.0, child: FadeInAnimation(child: _buildBlogCard(context, post))),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBlogCard(BuildContext context, BlogPost post) {
    return AnimatedCard(
      onTap: () {
        context.go('${AppConstants.routeBlogDetail}/${post.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppConstants.borderRadius),
                topRight: Radius.circular(AppConstants.borderRadius),
              ),
              child: Stack(
                children: [
                  // Network Image with Modern Loader
                  Image.network(
                    post.coverImage,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      // Modern Shimmer Loader
                      return Shimmer.fromColors(
                        baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        highlightColor: Theme.of(context).colorScheme.surface,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.image, size: 48, color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback gradient when image fails to load
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(FontAwesomeIcons.newspaper, size: 48, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                        ),
                      );
                    },
                  ),

                  // Featured Badge
                  if (post.featured)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: const Text(
                          'Featured',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      post.category,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Expanded(
                    child: Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Excerpt
                  Text(
                    post.excerpt,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Meta Info
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.clock, size: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Text(
                        post.readTime,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                      ),
                      const SizedBox(width: 16),
                      Icon(FontAwesomeIcons.eye, size: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Text(
                        '${post.views}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
