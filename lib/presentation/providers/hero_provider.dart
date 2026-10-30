import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

const rotatingHeroTexts = [
  'Full Stack Developer',
  'UI/UX Designer',
  'Problem Solver',
  'Creative Thinker',
];

final heroProvider = NotifierProvider.autoDispose<HeroNotifier, int>(
  HeroNotifier.new,
);

class HeroNotifier extends Notifier<int> {
  @override
  int build() {
    final timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (ref.mounted) {
        state = (state + 1) % rotatingHeroTexts.length;
      }
    });
    ref.onDispose(timer.cancel);
    return 0;
  }
}
