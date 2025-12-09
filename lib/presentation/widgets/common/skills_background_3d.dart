// Example: Add floating 3D tech objects to Skills Section background
// This creates an immersive 3D environment

import 'package:flutter/material.dart';
import '../common/model_3d_viewer.dart';

class SkillsBackground3D extends StatelessWidget {
  const SkillsBackground3D({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Floating cube (top right)
        Positioned(right: 50, top: 100, child: Animated3DModel(src: 'assets/3d/cube.glb', width: 120, height: 120, autoRotate: true)),

        // Floating sphere (left side)
        Positioned(left: 30, top: 200, child: Animated3DModel(src: 'assets/3d/sphere.glb', width: 100, height: 100, autoRotate: true)),

        // Floating pyramid (bottom right)
        Positioned(right: 100, bottom: 150, child: Animated3DModel(src: 'assets/3d/pyramid.glb', width: 110, height: 110, autoRotate: true)),
      ],
    );
  }
}

// To use in skills_section.dart:
// Wrap your existing content with Stack and add this as background:
/*
Stack(
  children: [
    // Background 3D objects
    const SkillsBackground3D(),
    
    // Your existing skills content
    Container(
      // ... your existing code
    ),
  ],
)
*/
