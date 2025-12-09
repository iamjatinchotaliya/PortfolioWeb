import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/themes/app_theme.dart';

class ScrollRevealWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;
  final bool slideFromLeft;
  final bool slideFromRight;
  final bool slideFromTop;
  final bool slideFromBottom;
  final bool fade;

  const ScrollRevealWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppTheme.animationSlow,
    this.offset = 50.0,
    this.slideFromLeft = false,
    this.slideFromRight = false,
    this.slideFromTop = false,
    this.slideFromBottom = true,
    this.fade = true,
  });

  @override
  State<ScrollRevealWidget> createState() => _ScrollRevealWidgetState();
}

class _ScrollRevealWidgetState extends State<ScrollRevealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: widget.fade ? 0.0 : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Offset beginOffset = Offset.zero;
    if (widget.slideFromLeft) {
      beginOffset = Offset(-widget.offset / 100, 0);
    } else if (widget.slideFromRight) {
      beginOffset = Offset(widget.offset / 100, 0);
    } else if (widget.slideFromTop) {
      beginOffset = Offset(0, -widget.offset / 100);
    } else if (widget.slideFromBottom) {
      beginOffset = Offset(0, widget.offset / 100);
    }

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() async {
    if (_hasAnimated) return;
    _hasAnimated = true;
    await Future.delayed(widget.delay);
    if (mounted) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('scroll_reveal_${widget.child.hashCode}'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.1) {
          _startAnimation();
        }
      },
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}
