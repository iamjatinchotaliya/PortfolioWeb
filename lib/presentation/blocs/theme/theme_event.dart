import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();
}

class SetLightThemeEvent extends ThemeEvent {
  const SetLightThemeEvent();
}

class SetDarkThemeEvent extends ThemeEvent {
  const SetDarkThemeEvent();
}
