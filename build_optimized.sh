#!/bin/bash

# Flutter Web Performance Build Script
# This script builds your Flutter web app with maximum performance optimizations

echo "🚀 Building Flutter Web App with Performance Optimizations..."
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build with optimizations
echo "⚡ Building with performance optimizations..."
flutter build web \
  --web-renderer canvaskit \
  --release \
  --dart-define=FLUTTER_WEB_USE_SKIA=true \
  --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@latest/bin/ \
  --source-maps \
  --pwa-strategy offline-first

echo ""
echo "✅ Build complete!"
echo "📁 Output directory: build/web"
echo ""
echo "Performance Tips:"
echo "  • Use CanvasKit renderer for better performance"
echo "  • Enable gzip compression on your server"
echo "  • Use CDN for static assets"
echo "  • Enable browser caching"
echo ""
echo "To test locally, run:"
echo "  cd build/web && python3 -m http.server 8080"
echo ""
