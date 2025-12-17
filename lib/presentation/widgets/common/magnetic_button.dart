import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';

class MagneticButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;

  const MagneticButton({super.key, required this.text, required this.onPressed, this.isPrimary = true, this.icon});

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  bool _isHovered = false;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _handleHover(PointerEvent details, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final localPosition = details.localPosition;
    final delta = localPosition - center;

    setState(() {
      _offset = delta * 0.15; // Magnetic effect strength
      _isHovered = true;
    });
  }

  void _handleExit(PointerEvent event) {
    setState(() {
      _offset = Offset.zero;
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onHover: (event) => _handleHover(event, context.size ?? Size.zero),
      onExit: _handleExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(_offset.dx, _offset.dy, 0),
          child: AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  gradient: widget.isPrimary ? LinearGradient(colors: isDark ? AppTheme.auroraGradient : AppTheme.primaryGradient) : null,
                  color: widget.isPrimary ? null : Colors.transparent,
                  border: widget.isPrimary ? null : Border.all(color: isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary, width: 2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary).withOpacity(0.4 * (1 - _glowController.value * 0.3)),
                            blurRadius: 20 + (10 * _glowController.value),
                            spreadRadius: 2 + (2 * _glowController.value),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 20, color: widget.isPrimary ? Colors.white : (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: widget.isPrimary ? Colors.white : (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
