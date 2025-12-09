import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/url_helper.dart';
import '../../../data/models/experience.dart';
import '../common/animated_card.dart';
import '../common/scroll_reveal_widget.dart';

class ExperienceSection extends StatelessWidget {
  final List<Experience> experiences;

  const ExperienceSection({super.key, required this.experiences});

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Present';
    try {
      final parts = dateString.split('-');
      if (parts.length >= 2) {
        final year = parts[0];
        final month = int.parse(parts[1]);
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return '${months[month - 1]} $year';
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  String _calculateDuration(String startDate, String? endDate) {
    try {
      final start = DateTime.parse('$startDate-01');
      final end = endDate != null ? DateTime.parse('$endDate-01') : DateTime.now();
      final months = (end.year - start.year) * 12 + end.month - start.month;
      final years = months ~/ 12;
      final remainingMonths = months % 12;

      if (years > 0 && remainingMonths > 0) {
        return '$years yr ${remainingMonths} mo';
      } else if (years > 0) {
        return '$years ${years == 1 ? 'year' : 'years'}';
      } else {
        return '$remainingMonths ${remainingMonths == 1 ? 'month' : 'months'}';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
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
                    Text('Work Experience', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
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
                  'My professional journey and career highlights',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                ),
              ),
              SizedBox(height: isMobile ? 40 : 60),

              // Experience Timeline
              _buildTimeline(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: experiences.length,
        itemBuilder: (context, index) {
          final experience = experiences[index];
          final isLast = index == experiences.length - 1;

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: ScrollRevealWidget(
                  delay: Duration(milliseconds: 200 * index),
                  child: _buildTimelineItem(context, experience, isLast),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, Experience experience, bool isLast) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line
          SizedBox(
            width: 60,
            child: Column(
              children: [
                // Circle
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: experience.current ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).colorScheme.surface, width: 3),
                    boxShadow: experience.current
                        ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)]
                        : null,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Theme.of(context).colorScheme.outline, Theme.of(context).colorScheme.outline.withOpacity(0.3)],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : (isMobile ? 40 : 60)),
              child: AnimatedCard(
                onTap: experience.website.isNotEmpty ? () => UrlHelper.launchURL(experience.website) : null,
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 20 : 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo placeholder
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(FontAwesomeIcons.building, size: 24, color: Theme.of(context).colorScheme.primary),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  experience.position,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, height: 1.2),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  experience.company,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          if (experience.current)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Current',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Meta Info
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          _buildMetaItem(
                            context,
                            FontAwesomeIcons.calendar,
                            '${_formatDate(experience.startDate)} - ${_formatDate(experience.endDate)}',
                          ),
                          _buildMetaItem(context, FontAwesomeIcons.clock, _calculateDuration(experience.startDate, experience.endDate)),
                          _buildMetaItem(context, FontAwesomeIcons.locationDot, experience.location),
                          _buildMetaItem(context, FontAwesomeIcons.briefcase, experience.type),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Description
                      Text(
                        experience.description,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(height: 1.6, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 20),

                      // Responsibilities
                      if (experience.responsibilities.isNotEmpty) ...[
                        Text('Key Responsibilities', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ...experience.responsibilities.take(3).map((responsibility) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(FontAwesomeIcons.circleCheck, size: 16, color: Theme.of(context).colorScheme.primary),
                                const SizedBox(width: 12),
                                Expanded(child: Text(responsibility, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5))),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                      ],

                      // Achievements
                      if (experience.achievements.isNotEmpty) ...[
                        Text('Key Achievements', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ...experience.achievements.map((achievement) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(FontAwesomeIcons.trophy, size: 16, color: Colors.amber),
                                const SizedBox(width: 12),
                                Expanded(child: Text(achievement, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5))),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                      ],

                      // Technologies
                      if (experience.technologies.isNotEmpty) ...[
                        Text('Technologies', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: experience.technologies.map((tech) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                              ),
                              child: Text(
                                tech,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(width: 6),
        Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
      ],
    );
  }
}
