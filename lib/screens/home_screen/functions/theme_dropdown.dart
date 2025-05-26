import 'package:fl_pkgtesting/blocs/themes_blocs/themes_bloc.dart';
import 'package:fl_pkgtesting/blocs/themes_blocs/themes_event.dart';
import 'package:fl_pkgtesting/blocs/themes_blocs/themes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeDropdown extends StatelessWidget {
  const ThemeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemesBloc, ThemesState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.topRight,
          child: DropdownButton<ThemeMode>(
            value: state.themeMode,
            onChanged: (ThemeMode? newValue) {
              if (newValue != null) {
                context.read<ThemesBloc>().add(ThemesChanged(themeMode: newValue));
              }
            },
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('System'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
            ],
          ),
        );
      },
    );
  }
}
