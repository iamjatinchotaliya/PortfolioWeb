#!/bin/bash

# 3D Models Download Helper Script
# This script helps you quickly download free 3D models for your portfolio

echo "🎨 Portfolio 3D Models Setup Helper"
echo "===================================="
echo ""

# Create 3d directory if it doesn't exist
mkdir -p assets/3d

echo "📥 Free 3D Model Resources:"
echo ""
echo "1. LAPTOP MODELS (for Hero Section)"
echo "   🔗 https://sketchfab.com/3d-models/macbook-pro-16-late-2019-free-b0ba5c5c15234635a452d1c91e44c80e"
echo "   🔗 https://sketchfab.com/3d-models/laptop-lowpoly-free-e54fb6c6c05e46cdbc8f74f5b6b8e88f"
echo "   🔗 https://poly.pizza/?s=laptop"
echo ""

echo "2. AVATAR/CHARACTER MODELS (for About Section)"
echo "   🔗 https://readyplayer.me - Create custom avatar"
echo "   🔗 https://sketchfab.com/3d-models/low-poly-character-free-f88a7e7e5c8d4e5fa5a5f5e5e5e5e5e5"
echo "   🔗 https://poly.pizza/?s=character"
echo ""

echo "3. ABSTRACT TECH OBJECTS (for backgrounds)"
echo "   🔗 https://poly.pizza/?s=cube"
echo "   🔗 https://poly.pizza/?s=sphere"
echo "   🔗 https://poly.pizza/?s=geometric"
echo ""

echo "📝 Download Instructions:"
echo "1. Click on any link above"
echo "2. Download the model in GLB format (NOT GLTF)"
echo "3. Rename the file:"
echo "   - Laptop model → laptop.glb"
echo "   - Avatar model → avatar.glb"
echo "4. Move the files to: assets/3d/"
echo ""

echo "💡 Quick Download Commands (using curl):"
echo ""
echo "# Example: Download a sample laptop model"
echo "# Replace URL with actual model URL from Sketchfab/Poly"
echo "curl -o assets/3d/laptop.glb 'YOUR_MODEL_URL_HERE'"
echo ""

echo "✅ Alternative: Manual Download"
echo "1. Open your browser"
echo "2. Visit the recommended sites above"
echo "3. Search for 'laptop glb' or 'avatar glb'"
echo "4. Download FREE models with commercial license"
echo "5. Place in assets/3d/ folder"
echo ""

echo "🎯 Recommended Models:"
echo "✓ Laptop: Low-poly MacBook or generic laptop"
echo "✓ Avatar: Professional business character"
echo "✓ Size: Under 5MB each"
echo "✓ Format: GLB (not GLTF with separate files)"
echo ""

echo "🚀 After downloading:"
echo "1. Verify files are in: assets/3d/laptop.glb and assets/3d/avatar.glb"
echo "2. Run: flutter clean"
echo "3. Run: flutter run -d chrome"
echo "4. Check your portfolio with 3D models!"
echo ""

echo "📖 Need help? Check: 3D_MODELS_GUIDE.md"
