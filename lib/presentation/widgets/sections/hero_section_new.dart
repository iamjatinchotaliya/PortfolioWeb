import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/url_helper.dart';
import '../../../data/models/personal_info.dart';
import '../../blocs/hero/hero_cubit.dart';
import '../common/animated_button.dart';
import '../common/flip_card_3d.dart';

class HeroSection extends StatelessWidget {
  final PersonalInfo personalInfo;
  final Function(String) onNavigate;

  const HeroSection({super.key, required this.personalInfo, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HeroCubit(),
      child: _HeroSectionContent(personalInfo: personalInfo, onNavigate: onNavigate),
    );
  }
}

class _HeroSectionContent extends StatefulWidget {
  final PersonalInfo personalInfo;
  final Function(String) onNavigate;

  const _HeroSectionContent({required this.personalInfo, required this.onNavigate});

  @override
  State<_HeroSectionContent> createState() => _HeroSectionContentState();
}

class _HeroSectionContentState extends State<_HeroSectionContent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Theme.of(context).scaffoldBackgroundColor, Theme.of(context).colorScheme.primary.withOpacity(0.05)],
        ),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: AppConstants.maxWideContentWidth),
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: isMobile || isTablet ? _buildMobileLayout() : _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [_buildAnimation(), const SizedBox(height: 48), _buildContent()]);
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 6, child: _buildContent()),
        const SizedBox(width: 64),
        Expanded(flex: 5, child: _buildAnimation()),
      ],
    );
  }

  Widget _buildContent() {
    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: ResponsiveHelper.isMobile(context) ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (widget) => SlideAnimation(verticalOffset: 50.0, child: FadeInAnimation(child: widget)),
          children: [
            Text(
              'Hello, I\'m',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
              textAlign: ResponsiveHelper.isMobile(context) ? TextAlign.center : TextAlign.left,
            ),
            const SizedBox(height: 8),
            Text(
              widget.personalInfo.name,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: ResponsiveHelper.getResponsiveValue(context: context, mobile: 36, tablet: 48, desktop: 57),
              ),
              textAlign: ResponsiveHelper.isMobile(context) ? TextAlign.center : TextAlign.left,
            ),
            const SizedBox(height: 16),
            _buildRotatingText(),
            const SizedBox(height: 24),
            Text(
              widget.personalInfo.tagline,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
              textAlign: ResponsiveHelper.isMobile(context) ? TextAlign.center : TextAlign.left,
            ),
            const SizedBox(height: 48),
            _buildActionButtons(),
            const SizedBox(height: 48),
            _buildSocialLinks(),
          ],
        ),
      ),
    );
  }

  Widget _buildRotatingText() {
    return BlocBuilder<HeroCubit, HeroState>(
      builder: (context, state) {
        final heroCubit = context.read<HeroCubit>();
        return SizedBox(
          height: 60,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(animation),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey<int>(state.currentTextIndex),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppTheme.primaryGradient.map((c) => c.withOpacity(0.2)).toList()),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Text(
                heroCubit.rotatingTexts[state.currentTextIndex],
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: ResponsiveHelper.isMobile(context) ? WrapAlignment.center : WrapAlignment.start,
      children: [
        AnimatedButton(text: 'View Projects', onPressed: () => widget.onNavigate('projects'), icon: Icons.work_outline),
        AnimatedButton(text: 'Contact Me', onPressed: () => widget.onNavigate('contact'), isPrimary: false, icon: Icons.email_outlined),
      ],
    );
  }

  Widget _buildSocialLinks() {
    final socialLinks = [
      {'icon': 'github', 'url': widget.personalInfo.social.github},
      {'icon': 'linkedin', 'url': widget.personalInfo.social.linkedin},
      {'icon': 'twitter', 'url': widget.personalInfo.social.twitter},
    ];

    return Row(
      mainAxisAlignment: ResponsiveHelper.isMobile(context) ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: socialLinks.map((link) {
        return _SocialIconButton(onTap: () => UrlHelper.launchURL(link['url']!));
      }).toList(),
    );
  }

  Widget _buildAnimation() {
    final modelSize = ResponsiveHelper.getResponsiveValue(context: context, mobile: 250.0, tablet: 350.0, desktop: 450.0);

    return Container(
      constraints: BoxConstraints(maxHeight: ResponsiveHelper.isMobile(context) ? 350 : 550),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rotating gradient background
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * 3.14159,
                  child: Container(
                    width: ResponsiveHelper.getResponsiveValue(context: context, mobile: 280, tablet: 380, desktop: 480),
                    height: ResponsiveHelper.getResponsiveValue(context: context, mobile: 280, tablet: 380, desktop: 480),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppTheme.primaryGradient.map((c) => c.withOpacity(0.1)).toList()),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),

            // Flip Card: Image -> 3D Model on tap
            FlipCard3D(
              imagePath: widget.personalInfo.avatar,
              modelSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
              width: modelSize,
              height: modelSize,
              autoRotate: true,
              cameraOrbit: '0deg 75deg 105%',
              imagefit: BoxFit.cover,
              isCircle: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SocialIconButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _HoverCubit(),
      child: BlocBuilder<_HoverCubit, bool>(
        builder: (context, isHovered) {
          return MouseRegion(
            onEnter: (_) => context.read<_HoverCubit>().setHovered(true),
            onExit: (_) => context.read<_HoverCubit>().setHovered(false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onTap,
              child: AnimatedContainer(
                duration: AppTheme.animationFast,
                margin: const EdgeInsets.only(right: 16),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isHovered ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.link, color: isHovered ? Colors.white : Theme.of(context).colorScheme.primary, size: 24),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HoverCubit extends Cubit<bool> {
  _HoverCubit() : super(false);

  void setHovered(bool value) => emit(value);
}
