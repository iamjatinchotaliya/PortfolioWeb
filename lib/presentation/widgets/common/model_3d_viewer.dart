import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Model3DViewer extends StatelessWidget {
  final String src;
  final String? alt;
  final bool autoRotate;
  final bool cameraControls;
  final String? iosSrc;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final String? poster;
  final bool shadowIntensity;
  final num? exposure;
  final String? cameraOrbit;

  const Model3DViewer({
    super.key,
    required this.src,
    this.alt,
    this.autoRotate = true,
    this.cameraControls = true,
    this.iosSrc,
    this.backgroundColor,
    this.width,
    this.height,
    this.poster,
    this.shadowIntensity = true,
    this.exposure,
    this.cameraOrbit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: backgroundColor ?? Colors.transparent),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ModelViewer(
          src: src,
          alt: alt ?? 'A 3D model',
          ar: false,
          autoRotate: autoRotate,
          cameraControls: cameraControls,
          iosSrc: iosSrc,
          disableZoom: false,
          backgroundColor: backgroundColor ?? const Color(0x00000000),
          loading: Loading.eager,
          shadowIntensity: shadowIntensity ? 1.0 : 0.0,
          exposure: exposure,
          cameraOrbit: cameraOrbit ?? 'auto auto auto',
          autoPlay: true,
          interpolationDecay: 200,
        ),
      ),
    );
  }
}

/// Animated 3D Model with floating effect
class Animated3DModel extends StatefulWidget {
  final String src;
  final double? width;
  final double? height;
  final bool autoRotate;
  final String? cameraOrbit;

  const Animated3DModel({super.key, required this.src, this.width, this.height, this.autoRotate = true, this.cameraOrbit});

  @override
  State<Animated3DModel> createState() => _Animated3DModelState();
}

class _Animated3DModelState extends State<Animated3DModel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat(reverse: true);

    _animation = Tween<double>(begin: -10, end: 10).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Model3DViewer(
            src: widget.src,
            width: widget.width,
            height: widget.height,
            autoRotate: widget.autoRotate,
            cameraOrbit: widget.cameraOrbit,
            shadowIntensity: true,
          ),
        );
      },
    );
  }
}
