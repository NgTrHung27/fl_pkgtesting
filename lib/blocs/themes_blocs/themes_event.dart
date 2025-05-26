import 'package:flutter/material.dart';

abstract class ThemesEvent {}

class ThemesChanged extends ThemesEvent {
  final ThemeMode themeMode;
  ThemesChanged({required this.themeMode});
}
