import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'hero_state.dart';

class HeroCubit extends Cubit<HeroState> {
  Timer? _timer;
  final List<String> rotatingTexts = ['Full Stack Developer', 'UI/UX Designer', 'Problem Solver', 'Creative Thinker'];

  HeroCubit() : super(const HeroInitial()) {
    _startTextRotation();
  }

  void _startTextRotation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final nextIndex = (state.currentTextIndex + 1) % rotatingTexts.length;
      emit(HeroTextRotated(nextIndex));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
