import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolioweb/presentation/widgets/common/portfolio_loader.dart';

void main() {
  testWidgets(
    'loader fits a narrow screen with large text and reduced motion',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 568),
              disableAnimations: true,
              textScaler: TextScaler.linear(2),
            ),
            child: const Scaffold(body: PortfolioLoader()),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 9));
      await tester.pump(const Duration(milliseconds: 400));
      expect(
        find.text('Still connecting. Thank you for your patience.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      // Reduced motion produces no continuously scheduled animation frames.
      expect(tester.binding.hasScheduledFrame, isFalse);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  for (final brightness in Brightness.values) {
    testWidgets(
      'loader disposes animations and slow-request timer in ${brightness.name} theme',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1100, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final capture = GlobalKey();
        const previewFont = String.fromEnvironment('PREVIEW_FONT');
        if (previewFont.isNotEmpty) {
          await tester.runAsync(() async {
            final bytes = ByteData.sublistView(
              await File(previewFont).readAsBytes(),
            );
            for (final family in ['PreviewSans', 'monospace']) {
              await (FontLoader(family)..addFont(Future.value(bytes))).load();
            }
          });
        }
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              brightness: brightness,
              fontFamily: previewFont.isEmpty ? null : 'PreviewSans',
            ),
            home: RepaintBoundary(
              key: capture,
              child: const Scaffold(body: PortfolioLoader()),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 1200));
        expect(find.text('Preparing your visit'), findsOneWidget);
        expect(tester.takeException(), isNull);
        if (const bool.fromEnvironment('CAPTURE_LOADER')) {
          final boundary =
              capture.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final image = await boundary.toImage();
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            await Directory('build/loader-previews').create(recursive: true);
            await File(
              'build/loader-previews/${brightness.name}.png',
            ).writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 10));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
