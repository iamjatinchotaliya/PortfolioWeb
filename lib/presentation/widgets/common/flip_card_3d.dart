import 'dart:math';
import 'package:flutter/material.dart';
import 'model_3d_viewer.dart';

class FlipCard3D extends StatefulWidget {
  final String imagePath;
  final String modelSrc;
  final double width;
  final double height;
  final bool autoRotate;
  final String cameraOrbit;
  final BoxFit imagefit;
  final bool isCircle;

  const FlipCard3D({
    Key? key,
    required this.imagePath,
    required this.modelSrc,
    required this.width,
    required this.height,
    this.autoRotate = true,
    this.cameraOrbit = '0deg 75deg 105%',
    this.imagefit = BoxFit.cover,
    this.isCircle = false,
  }) : super(key: key);

  @override
  State<FlipCard3D> createState() => _FlipCard3DState();
}

class _FlipCard3DState extends State<FlipCard3D> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          // Determine which side to show
          final isFront = angle < pi / 2;

          return Transform(transform: transform, alignment: Alignment.center, child: isFront ? _buildFrontSide() : _buildBackSide());
        },
      ),
    );
  }

  Widget _buildFrontSide() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: widget.isCircle ? null : BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
      ),
      child: Stack(
        children: [
          // Image
          ClipRRect(
            borderRadius: widget.isCircle ? BorderRadius.circular(widget.width / 2) : BorderRadius.circular(20),
            child: Image.asset(
              widget.imagePath,
              width: widget.width,
              height: widget.height,
              fit: widget.imagefit,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: widget.isCircle ? null : BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Theme.of(context).colorScheme.primary.withOpacity(0.3), Theme.of(context).colorScheme.secondary.withOpacity(0.3)],
                    ),
                  ),
                  child: Icon(Icons.person, size: widget.width * 0.3, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                );
              },
            ),
          ),

          // Tap indicator overlay
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, size: 16, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Tap for 3D',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackSide() {
    return Transform(
      transform: Matrix4.identity()..rotateY(pi),
      alignment: Alignment.center,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: widget.isCircle ? null : BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
        ),
        child: Stack(
          children: [
            // Gradient background
            Container(
              decoration: BoxDecoration(
                shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: widget.isCircle ? null : BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Theme.of(context).colorScheme.primary.withOpacity(0.1), Theme.of(context).colorScheme.secondary.withOpacity(0.1)],
                ),
              ),
            ),

            // 3D Model
            ClipRRect(
              borderRadius: widget.isCircle ? BorderRadius.circular(widget.width / 2) : BorderRadius.circular(20),
              child: Animated3DModel(
                src: widget.modelSrc,
                width: widget.width,
                height: widget.height,
                autoRotate: widget.autoRotate,
                cameraOrbit: widget.cameraOrbit,
              ),
            ),

            // Back indicator
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flip_to_front, size: 16, color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 4),
                    Text(
                      'Tap to flip',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
