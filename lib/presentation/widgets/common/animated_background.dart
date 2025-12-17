import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();

    // Generate particles
    for (int i = 0; i < 30; i++) {
      _particles.add(
        Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 3 + 1,
          speedX: (_random.nextDouble() - 0.5) * 0.0005,
          speedY: (_random.nextDouble() - 0.5) * 0.0005,
          opacity: _random.nextDouble() * 0.3 + 0.1,
        ),
      );
    }

    _controller.addListener(() {
      setState(() {
        for (var particle in _particles) {
          particle.x += particle.speedX;
          particle.y += particle.speedY;

          // Wrap around edges
          if (particle.x < 0) particle.x = 1;
          if (particle.x > 1) particle.x = 0;
          if (particle.y < 0) particle.y = 1;
          if (particle.y > 1) particle.y = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [const Color(0xFF0A0E27), const Color(0xFF1A1F3A), const Color(0xFF0A0E27)]
                  : [const Color(0xFFF8F9FF), const Color(0xFFE8EEFF), const Color(0xFFF8F9FF)],
            ),
          ),
        ),

        // Animated Particles
        CustomPaint(
          painter: ParticlePainter(particles: _particles, isDark: Theme.of(context).brightness == Brightness.dark),
          size: Size.infinite,
        ),

        // Mesh Gradient Overlay
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: MeshGradientPainter(animation: _controller.value, isDark: Theme.of(context).brightness == Brightness.dark),
              );
            },
          ),
        ),

        // Content
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speedX;
  final double speedY;
  final double opacity;

  Particle({required this.x, required this.y, required this.size, required this.speedX, required this.speedY, required this.opacity});
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final bool isDark;

  ParticlePainter({required this.particles, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = (isDark ? const Color(0xFF00F5FF) : const Color(0xFF00D9FF)).withOpacity(0.3);

    for (var particle in particles) {
      final x = particle.x * size.width;
      final y = particle.y * size.height;

      // Draw particle
      paint.color = (isDark ? const Color(0xFF00F5FF) : const Color(0xFF00D9FF)).withOpacity(particle.opacity);
      canvas.drawCircle(Offset(x, y), particle.size, paint);

      // Draw connections between nearby particles
      for (var other in particles) {
        final otherX = other.x * size.width;
        final otherY = other.y * size.height;
        final distance = sqrt(pow(x - otherX, 2) + pow(y - otherY, 2));

        if (distance < 150) {
          final linePaint = Paint()
            ..color = (isDark ? const Color(0xFF00F5FF) : const Color(0xFF00D9FF)).withOpacity((1 - distance / 150) * 0.1)
            ..strokeWidth = 0.5;

          canvas.drawLine(Offset(x, y), Offset(otherX, otherY), linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MeshGradientPainter extends CustomPainter {
  final double animation;
  final bool isDark;

  MeshGradientPainter({required this.animation, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    // Animated gradient blobs
    final colors = isDark
        ? [const Color(0xFF00F5FF).withOpacity(0.05), const Color(0xFFFF0080).withOpacity(0.05), const Color(0xFFFFD60A).withOpacity(0.05)]
        : [const Color(0xFF00D9FF).withOpacity(0.08), const Color(0xFFFF006E).withOpacity(0.08), const Color(0xFFFFBE0B).withOpacity(0.08)];

    final positions = [
      Offset(size.width * (0.2 + 0.3 * sin(animation * 2 * pi)), size.height * (0.2 + 0.3 * cos(animation * 2 * pi))),
      Offset(size.width * (0.8 + 0.2 * cos(animation * 2 * pi + pi / 2)), size.height * (0.3 + 0.2 * sin(animation * 2 * pi + pi / 2))),
      Offset(size.width * (0.5 + 0.3 * sin(animation * 2 * pi + pi)), size.height * (0.7 + 0.3 * cos(animation * 2 * pi + pi))),
    ];

    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      canvas.drawCircle(positions[i], size.width * 0.3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
