import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/models/skill.dart';
import '../../blocs/filter/filter_bloc.dart';
import '../../blocs/filter/filter_event.dart';
import '../../blocs/filter/filter_state.dart';
import '../common/animated_card.dart';
import '../common/scroll_reveal_widget.dart';

class SkillsSection extends StatelessWidget {
  final List<SkillCategory> skillCategories;

  const SkillsSection({super.key, required this.skillCategories});

  IconData _getCategoryIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'web':
        return FontAwesomeIcons.laptopCode;
      case 'backend':
        return FontAwesomeIcons.server;
      case 'mobile':
        return FontAwesomeIcons.mobileScreen;
      case 'tools':
        return FontAwesomeIcons.screwdriverWrench;
      case 'database':
        return FontAwesomeIcons.database;
      case 'cloud':
        return FontAwesomeIcons.cloud;
      default:
        return FontAwesomeIcons.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return BlocProvider(
      create: (context) => FilterBloc(),
      child: Container(
        width: double.infinity,
        padding: ResponsiveHelper.getResponsivePadding(context).copyWith(top: isMobile ? 60 : 100, bottom: isMobile ? 60 : 100),
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
                      Text('Skills & Expertise', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
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
                SizedBox(height: isMobile ? 32 : 48),

                // Category Tabs
                ScrollRevealWidget(delay: const Duration(milliseconds: 200), child: _buildCategoryTabs(context, skillCategories)),
                SizedBox(height: isMobile ? 32 : 48),

                // Skills Grid
                ScrollRevealWidget(delay: const Duration(milliseconds: 400), child: _buildSkillsGrid(context, skillCategories)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context, List<SkillCategory> categories) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        if (isMobile) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                categories.length,
                (index) =>
                    Padding(padding: const EdgeInsets.only(right: 12), child: _buildCategoryTab(context, index, categories, state.selectedCategory)),
              ),
            ),
          );
        }

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(categories.length, (index) => _buildCategoryTab(context, index, categories, state.selectedCategory)),
        );
      },
    );
  }

  Widget _buildCategoryTab(BuildContext context, int index, List<SkillCategory> categories, String selectedCategory) {
    final category = categories[index];
    final isSelected = selectedCategory.isEmpty ? index == 0 : category.name == selectedCategory;

    return InkWell(
      onTap: () {
        context.read<FilterBloc>().add(ChangeCategory(category.name));
      },
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getCategoryIcon(category.icon), size: 18, color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsGrid(BuildContext context, List<SkillCategory> categories) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        final selectedIndex = categories.indexWhere((cat) => cat.name == state.selectedCategory);
        final currentIndex = selectedIndex == -1 ? 0 : selectedIndex;
        final selectedCategory = categories[currentIndex];

        return AnimationLimiter(
          child: GridView.builder(
            key: ValueKey(selectedCategory.name),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: isMobile ? 2.5 : 3,
            ),
            itemCount: selectedCategory.skills.length,
            itemBuilder: (context, index) {
              final skill = selectedCategory.skills[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: isMobile ? 1 : (isTablet ? 2 : 3),
                child: SlideAnimation(verticalOffset: 50.0, child: FadeInAnimation(child: _buildSkillCard(context, skill))),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSkillCard(BuildContext context, Skill skill) {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: _parseColor(skill.color, context).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(FontAwesomeIcons.code, size: 20, color: _parseColor(skill.color, context)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(skill.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Text(
                  '${skill.level}%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressBar(context, skill),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, Skill skill) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: skill.level / 100),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surface,
                valueColor: AlwaysStoppedAnimation<Color>(_parseColor(skill.color, context)),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _parseColor(String colorString, BuildContext context) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Theme.of(context).colorScheme.primary;
    }
  }
}
