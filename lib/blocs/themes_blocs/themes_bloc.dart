import 'package:fl_pkgtesting/blocs/themes_blocs/themes_event.dart';
import 'package:fl_pkgtesting/blocs/themes_blocs/themes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemesBloc extends Bloc<ThemesEvent, ThemesState> {
  ThemesBloc() : super(const ThemesState(ThemeMode.system)) {
    on<ThemesChanged>(_onThemesChanged);
  }

  void _onThemesChanged(ThemesChanged event, Emitter<ThemesState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
  }
}
