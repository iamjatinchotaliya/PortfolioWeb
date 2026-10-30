import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// An indeterminate introduction shown only while portfolio data is pending.
class PortfolioLoader extends StatefulWidget {
  const PortfolioLoader({super.key});

  @override
  State<PortfolioLoader> createState() => _PortfolioLoaderState();
}

class _PortfolioLoaderState extends State<PortfolioLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;
  late final Timer _slowRequestTimer;
  bool _takingLonger = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _slowRequestTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) setState(() => _takingLonger = true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _motion.stop();
      _motion.value = 0.25;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
  }

  @override
  void dispose() {
    _slowRequestTimer.cancel();
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFF0F4FF) : const Color(0xFF14213D);
    final muted = dark ? const Color(0xFF9AAAC5) : const Color(0xFF596A84);
    final cyan = dark ? const Color(0xFF67E8F9) : const Color(0xFF007F9E);
    const violet = Color(0xFF9D83F3);
    final background = dark ? const Color(0xFF090F20) : const Color(0xFFF6F8FD);

    return Semantics(
      container: true,
      liveRegion: true,
      label: _takingLonger
          ? 'Still loading portfolio. Thank you for your patience.'
          : 'Loading portfolio. Preparing projects, skills and stories.',
      child: ExcludeSemantics(
        child: ColoredBox(
          color: background,
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.25),
                    radius: 0.85,
                    colors: [
                      cyan.withValues(alpha: dark ? 0.08 : 0.045),
                      background,
                    ],
                  ),
                ),
              ),
              CustomPaint(painter: _GridPainter(ink.withValues(alpha: 0.07))),
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 32,
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 460),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'PORTFOLIO',
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 11,
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  SizedBox(
                                    width: 240,
                                    height: 240,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        RepaintBoundary(
                                          child: CustomPaint(
                                            size: const Size(240, 240),
                                            painter: _OrbitPainter(
                                              motion: _motion,
                                              cyan: cyan,
                                              violet: violet,
                                              dark: dark,
                                            ),
                                          ),
                                        ),
                                        Transform.rotate(
                                          angle: -0.06,
                                          child: Container(
                                            width: 96,
                                            height: 96,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(28),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: dark
                                                    ? [
                                                        const Color(0xFF1C3046),
                                                        const Color(0xFF131C32),
                                                      ]
                                                    : [
                                                        Colors.white,
                                                        const Color(0xFFEBF2FC),
                                                      ],
                                              ),
                                              border: Border.all(
                                                color: cyan.withValues(
                                                  alpha: 0.3,
                                                ),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: cyan.withValues(
                                                    alpha: 0.12,
                                                  ),
                                                  blurRadius: 48,
                                                  spreadRadius: 4,
                                                ),
                                                BoxShadow(
                                                  color: background.withValues(
                                                    alpha: 0.7,
                                                  ),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 12),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                '</>',
                                                style: TextStyle(
                                                  fontFamily: 'monospace',
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w600,
                                                  color: cyan,
                                                  letterSpacing: -3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Crafting your first impression.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: ink,
                                      fontSize: 28,
                                      height: 1.25,
                                      letterSpacing: -0.8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'A collection of projects, skills and stories.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 14,
                                      height: 1.6,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  RepaintBoundary(
                                    child: SizedBox(
                                      width: 180,
                                      height: 3,
                                      child: CustomPaint(
                                        painter: _LoadingLinePainter(
                                          motion: _motion,
                                          color: cyan,
                                          reduced: _reduceMotion,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  AnimatedSwitcher(
                                    duration: _reduceMotion
                                        ? Duration.zero
                                        : const Duration(milliseconds: 300),
                                    child: Text(
                                      _takingLonger
                                          ? 'Still connecting. Thank you for your patience.'
                                          : 'Preparing your visit',
                                      key: ValueKey(_takingLonger),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: muted,
                                        fontSize: 12,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({
    required this.motion,
    required this.cyan,
    required this.violet,
    required this.dark,
  }) : super(repaint: motion);
  final Animation<double> motion;
  final Color cyan;
  final Color violet;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final phase = motion.value * math.pi * 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var ring = 0; ring < 2; ring++) {
      final radius = ring == 0 ? 88.0 : 112.0;
      final color = ring == 0 ? cyan : violet;
      paint.color = color.withValues(alpha: 0.14);
      canvas.drawCircle(center, radius, paint);
      final angle = ring == 0 ? phase : -phase + math.pi;
      paint
        ..color = color.withValues(alpha: 0.65)
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        angle - 0.6,
        0.6,
        false,
        paint,
      );
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.drawCircle(
        point,
        8,
        Paint()..color = color.withValues(alpha: 0.12),
      );
      canvas.drawCircle(point, 3, Paint()..color = color);
    }
    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 2 + 0.4;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * 103;
      final alpha = 0.2 + 0.3 * (0.5 + 0.5 * math.sin(phase + i));
      canvas.drawCircle(
        point,
        1.5,
        Paint()..color = cyan.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.cyan != cyan ||
      old.violet != violet ||
      old.dark != dark ||
      old.motion != motion;
}

class _LoadingLinePainter extends CustomPainter {
  _LoadingLinePainter({
    required this.motion,
    required this.color,
    required this.reduced,
  }) : super(repaint: motion);
  final Animation<double> motion;
  final Color color;
  final bool reduced;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.clipRRect(RRect.fromRectAndRadius(bounds, const Radius.circular(2)));
    canvas.drawRect(bounds, Paint()..color = color.withValues(alpha: 0.13));
    final phase = reduced ? 0.5 : (motion.value * 3) % 1;
    final left = -size.width * 0.5 + phase * size.width * 1.5;
    final highlight = Rect.fromLTWH(left, 0, size.width * 0.5, size.height);
    canvas.drawRect(
      highlight,
      Paint()
        ..shader = LinearGradient(
          colors: [
            color.withValues(alpha: 0),
            color,
            color.withValues(alpha: 0),
          ],
        ).createShader(highlight),
    );
  }

  @override
  bool shouldRepaint(_LoadingLinePainter old) =>
      old.color != color || old.reduced != reduced || old.motion != motion;
}

class _GridPainter extends CustomPainter {
  const _GridPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var x = 16.0; x < size.width; x += 32) {
      for (var y = 16.0; y < size.height; y += 32) {
        canvas.drawCircle(Offset(x, y), 0.65, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}
