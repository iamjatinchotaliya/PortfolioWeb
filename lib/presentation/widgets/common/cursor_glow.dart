import 'package:flutter/material.dart';

class CursorGlow extends StatefulWidget {
  final Widget child;

  const CursorGlow({super.key, required this.child});

  @override
  State<CursorGlow> createState() => _CursorGlowState();
}

class _CursorGlowState extends State<CursorGlow> with SingleTickerProviderStateMixin {
  Offset _cursorPosition = Offset.zero;
  bool _isHovering = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _cursorPosition = event.position;
          _isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Stack(
        children: [
          widget.child,

          // Cursor Glow Effect
          if (_isHovering)
            Positioned(
              left: _cursorPosition.dx - 100,
              top: _cursorPosition.dy - 100,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF00F5FF) : const Color(0xFF00D9FF)).withOpacity(
                              0.15 * (1 - _pulseController.value * 0.3),
                            ),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
