import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/constants/app_constants.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../blocs/theme/theme_event.dart';
import '../../blocs/theme/theme_state.dart';

class CustomNavBar extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String) onNavItemTap;

  const CustomNavBar({super.key, required this.scrollController, required this.onNavItemTap});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  bool _isScrolled = false;
  String _activeSection = AppConstants.homeSectionId;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final isScrolled = widget.scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _isScrolled ? 30.0 : 0.0, sigmaY: _isScrolled ? 30.0 : 0.0),
        child: AnimatedContainer(
          duration: AppTheme.animationNormal,
          height: 80,
          decoration: BoxDecoration(
            gradient: _isScrolled
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75),
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.65),
                      Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    ],
                  )
                : null,
            border: _isScrolled ? Border(bottom: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2), width: 1.5)) : null,
            boxShadow: _isScrolled
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(color: Colors.white.withOpacity(0.05), blurRadius: 20, spreadRadius: -5, offset: const Offset(0, -2)),
                  ]
                : [],
          ),
          child: Container(
            decoration: _isScrolled
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                    ),
                  )
                : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? 16 : 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLogo(),
                  if (!isMobile) ...[_buildNavItems(), _buildActions()] else _buildMobileMenu(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onNavItemTap(AppConstants.homeSectionId),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppTheme.primaryGradient),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text('Portfolio', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItems() {
    final navItems = [
      {'id': AppConstants.homeSectionId, 'label': 'Home'},
      {'id': AppConstants.aboutSectionId, 'label': 'About'},
      {'id': AppConstants.skillsSectionId, 'label': 'Skills'},
      {'id': AppConstants.projectsSectionId, 'label': 'Projects'},
      {'id': AppConstants.experienceSectionId, 'label': 'Experience'},
      {'id': AppConstants.blogSectionId, 'label': 'Blog'},
      {'id': AppConstants.contactSectionId, 'label': 'Contact'},
    ];

    return Row(
      children: navItems
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _NavItem(label: item['label']!, isActive: _activeSection == item['id'], onTap: () => widget.onNavItemTap(item['id']!)),
            ),
          )
          .toList(),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            final isDark = state.themeMode == ThemeMode.dark;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.read<ThemeBloc>().add(const ToggleThemeEvent());
                },
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 400),
                  tween: Tween<double>(begin: 0, end: isDark ? 1 : 0),
                  curve: Curves.easeInOutCubic,
                  builder: (context, value, child) {
                    return Container(
                      width: 60,
                      height: 32,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Color.lerp(const Color(0xFF00D9FF), const Color(0xFF0A0E27), value)!,
                            Color.lerp(const Color(0xFF0099FF), const Color(0xFF1A1F3A), value)!,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.lerp(const Color(0xFF00D9FF), const Color(0xFF00F5FF), value)!.withOpacity(0.3 + (0.2 * value)),
                            blurRadius: 8 + (4 * value),
                            spreadRadius: 1 + value,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Animated position
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubic,
                            left: isDark ? 28 : 0,
                            top: 0,
                            bottom: 0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1 + (0.05 * value)),
                                    blurRadius: 4 + (2 * value),
                                    offset: Offset(0, 2 + value),
                                  ),
                                ],
                              ),
                              child: Transform.rotate(
                                angle: value * 3.14159 * 2, // 360 degree rotation
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: FadeTransition(opacity: animation, child: child),
                                    );
                                  },
                                  child: Icon(
                                    isDark ? Icons.nights_stay : Icons.wb_sunny,
                                    key: ValueKey(isDark),
                                    size: 16,
                                    color: isDark ? const Color(0xFF00F5FF) : const Color(0xFFFFBE0B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildMobileMenu() {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => _MobileMenuSheet(onNavItemTap: widget.onNavItemTap, activeSection: _activeSection),
        );
      },
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({required this.label, required this.isActive, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppTheme.animationFast,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: widget.isActive ? FontWeight.bold : FontWeight.normal,
                  color: widget.isActive || _isHovered ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: AppTheme.animationFast,
                height: 2,
                width: widget.isActive || _isHovered ? 40 : 0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppTheme.primaryGradient),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileMenuSheet extends StatelessWidget {
  final Function(String) onNavItemTap;
  final String activeSection;

  const _MobileMenuSheet({required this.onNavItemTap, required this.activeSection});

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'id': AppConstants.homeSectionId, 'label': 'Home', 'icon': Icons.home},
      {'id': AppConstants.aboutSectionId, 'label': 'About', 'icon': Icons.person},
      {'id': AppConstants.skillsSectionId, 'label': 'Skills', 'icon': Icons.code},
      {'id': AppConstants.projectsSectionId, 'label': 'Projects', 'icon': Icons.work},
      {'id': AppConstants.experienceSectionId, 'label': 'Experience', 'icon': Icons.business_center},
      {'id': AppConstants.blogSectionId, 'label': 'Blog', 'icon': Icons.article},
      {'id': AppConstants.contactSectionId, 'label': 'Contact', 'icon': Icons.mail},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: navItems
            .map(
              (item) => ListTile(
                leading: Icon(item['icon'] as IconData, color: activeSection == item['id'] ? Theme.of(context).colorScheme.primary : null),
                title: Text(
                  item['label'] as String,
                  style: TextStyle(
                    fontWeight: activeSection == item['id'] ? FontWeight.bold : FontWeight.normal,
                    color: activeSection == item['id'] ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onNavItemTap(item['id'] as String);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
