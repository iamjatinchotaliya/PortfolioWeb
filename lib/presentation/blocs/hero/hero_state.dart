part of 'hero_cubit.dart';

abstract class HeroState {
  final int currentTextIndex;
  const HeroState(this.currentTextIndex);
}

class HeroInitial extends HeroState {
  const HeroInitial() : super(0);
}

class HeroTextRotated extends HeroState {
  const HeroTextRotated(super.currentTextIndex);
}
