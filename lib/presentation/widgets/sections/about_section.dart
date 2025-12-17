import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/url_helper.dart';
import '../../../data/models/personal_info.dart';
import '../common/animated_card.dart';
import '../common/scroll_reveal_widget.dart';
import '../common/flip_card_3d.dart';

class AboutSection extends StatelessWidget {
  final PersonalInfo personalInfo;

  const AboutSection({super.key, required this.personalInfo});

  IconData _getStatIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'work':
        return FontAwesomeIcons.briefcase;
      case 'code':
        return FontAwesomeIcons.code;
      case 'people':
        return FontAwesomeIcons.users;
      case 'commit':
        return FontAwesomeIcons.codeBranch;
      default:
        return FontAwesomeIcons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
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
                    Text('About Me', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
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
              SizedBox(height: isMobile ? 40 : 60),

              // Main Content
              isMobile || isTablet ? _buildMobileLayout(context) : _buildDesktopLayout(context),

              SizedBox(height: isMobile ? 40 : 60),

              // Stats Section
              ScrollRevealWidget(delay: const Duration(milliseconds: 400), child: _buildStats(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        ScrollRevealWidget(child: _buildProfileImage(context)),
        const SizedBox(height: 32),
        ScrollRevealWidget(delay: const Duration(milliseconds: 200), child: _buildBioContent(context)),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: ScrollRevealWidget(child: _buildProfileImage(context))),
        const SizedBox(width: 60),
        Expanded(
          flex: 6,
          child: ScrollRevealWidget(delay: const Duration(milliseconds: 200), child: _buildBioContent(context)),
        ),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedCard(
            child: FlipCard3D(
              imagePath: personalInfo.avatar,
              modelSrc: 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
              width: 400,
              height: 400,
              autoRotate: false,
              cameraOrbit: '0deg 75deg 105%',
              imagefit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBioContent(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          personalInfo.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 8),
        Text(
          personalInfo.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 24),
        Text(
          personalInfo.bio,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 32),

        // Contact Info
        Wrap(
          spacing: 24,
          runSpacing: 16,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _buildContactItem(context, FontAwesomeIcons.envelope, personalInfo.email, () => UrlHelper.launchEmail(personalInfo.email)),
            _buildContactItem(context, FontAwesomeIcons.phone, personalInfo.phone, () => UrlHelper.launchPhone(personalInfo.phone)),
            _buildContactItem(context, FontAwesomeIcons.locationDot, personalInfo.location, null),
          ],
        ),
        const SizedBox(height: 32),

        // Availability Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                personalInfo.availability,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Download Resume Button
        ElevatedButton.icon(
          onPressed: () {
            // In a real app, this would download the resume file
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resume download feature coming soon!')));
          },
          icon: const Icon(FontAwesomeIcons.download),
          label: const Text('Download Resume'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String text, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: isMobile ? 1.2 : 1.5,
        ),
        itemCount: personalInfo.stats.length,
        itemBuilder: (context, index) {
          final stat = personalInfo.stats[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 500),
            columnCount: isMobile ? 2 : 4,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: AnimatedCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_getStatIcon(stat.icon), size: 32, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        stat.value,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stat.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
