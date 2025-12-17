import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';

class PortfolioLoader extends StatefulWidget {
  const PortfolioLoader({super.key});

  @override
  State<PortfolioLoader> createState() => _PortfolioLoaderState();
}

class _PortfolioLoaderState extends State<PortfolioLoader> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();

    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);

    _particleController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();

    _particles = List.generate(
      20,
      (index) => Particle(
        angle: (index * 2 * pi) / 20,
        distance: 80.0 + (index % 3) * 30,
        size: 3.0 + Random().nextDouble() * 4,
        speed: 0.5 + Random().nextDouble() * 0.5,
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).colorScheme.primary.withOpacity(0.08),
                Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                AppTheme.primaryGradient[0].withOpacity(0.03),
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main animated loader
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer rotating ring with enhanced gradient
                      AnimatedBuilder(
                        animation: _rotationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationController.value * 2 * pi,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    AppTheme.primaryGradient[0],
                                    AppTheme.primaryGradient[1],
                                    Theme.of(context).colorScheme.secondary,
                                    AppTheme.primaryGradient[0].withOpacity(0.8),
                                    AppTheme.primaryGradient[0],
                                  ],
                                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).scaffoldBackgroundColor),
                              ),
                            ),
                          );
                        },
                      ),

                      // Middle pulsing circle with vibrant gradient
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final scale = 0.7 + (_pulseController.value * 0.3);
                          final opacity = 0.2 + (_pulseController.value * 0.3);
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppTheme.primaryGradient[0].withOpacity(opacity),
                                    AppTheme.primaryGradient[1].withOpacity(opacity * 0.7),
                                    Theme.of(context).colorScheme.secondary.withOpacity(opacity * 0.5),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.4, 0.7, 1.0],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Floating particles
                      AnimatedBuilder(
                        animation: _particleController,
                        builder: (context, child) {
                          return CustomPaint(
                            size: const Size(200, 200),
                            painter: ParticlePainter(
                              particles: _particles,
                              animation: _particleController.value,
                              primaryColor: Theme.of(context).colorScheme.primary,
                            ),
                          );
                        },
                      ),

                      // Center icon with gradient and glow
                      AnimatedBuilder(
                        animation: _rotationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: -_rotationController.value * 2 * pi,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [AppTheme.primaryGradient[0], AppTheme.primaryGradient[1], Theme.of(context).colorScheme.secondary],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(color: AppTheme.primaryGradient[0].withOpacity(0.6), blurRadius: 25, spreadRadius: 3),
                                  BoxShadow(color: AppTheme.primaryGradient[1].withOpacity(0.4), blurRadius: 15, spreadRadius: 1),
                                ],
                              ),
                              child: const Icon(Icons.code, color: Colors.white, size: 30),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Loading text with animation
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.5 + (_pulseController.value * 0.5),
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(colors: AppTheme.primaryGradient).createShader(bounds);
                        },
                        child: Text(
                          'Loading Portfolio',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Animated dots with gradient colors
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final colors = [AppTheme.primaryGradient[0], AppTheme.primaryGradient[1], Theme.of(context).colorScheme.secondary];
                    return AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final delay = index * 0.2;
                        final value = (_pulseController.value + delay) % 1.0;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(colors: [colors[index].withOpacity(value), colors[index].withOpacity(value * 0.5)]),
                            boxShadow: [BoxShadow(color: colors[index].withOpacity(value * 0.5), blurRadius: 8, spreadRadius: 1)],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Particle {
  final double angle;
  final double distance;
  final double size;
  final double speed;

  Particle({required this.angle, required this.distance, required this.size, required this.speed});
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final Color primaryColor;

  ParticlePainter({required this.particles, required this.animation, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (var particle in particles) {
      final animatedAngle = particle.angle + (animation * 2 * pi * particle.speed);
      final x = center.dx + cos(animatedAngle) * particle.distance;
      final y = center.dy + sin(animatedAngle) * particle.distance;

      final paint = Paint()
        ..color = primaryColor.withOpacity(0.6)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particle.size, paint);

      // Glow effect
      final glowPaint = Paint()
        ..color = primaryColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(Offset(x, y), particle.size * 1.5, glowPaint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
