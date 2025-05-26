import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


class ThemesState extends Equatable {
  final ThemeMode themeMode;
  
  const ThemesState(this.themeMode);

  @override
  List<Object> get props => [themeMode];

  ThemesState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemesState(
      themeMode ?? this.themeMode,
    );
  }
}