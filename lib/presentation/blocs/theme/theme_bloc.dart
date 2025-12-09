import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetLightThemeEvent>(_onSetLightTheme);
    on<SetDarkThemeEvent>(_onSetDarkTheme);
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final newThemeMode =
        state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(
      themeMode: newThemeMode,
      isDarkMode: !state.isDarkMode,
    ));
  }

  void _onSetLightTheme(SetLightThemeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(
      themeMode: ThemeMode.light,
      isDarkMode: false,
    ));
  }

  void _onSetDarkTheme(SetDarkThemeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(
      themeMode: ThemeMode.dark,
      isDarkMode: true,
    ));
  }
}
