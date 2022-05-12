import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/core/values/keys.dart';
import 'package:pomodoro_timer_task_management/themes/app_themes.dart';

part 'theme_switcher_state.dart';

class ThemeSwitcherCubit extends Cubit<ThemeSwitcherState> {
  ThemeSwitcherCubit() : super(ThemeSwitcherState.initial());

  late final Box<int> _themeBox;

  void init() async {
    _themeBox = await Hive.openBox<int>(kThemeBox);

    int themeIndex = _themeBox.get(kThemeBox)!;

    emit(
      state.copyWith(
        theme: appThemes[themeIndex],
        selectedThemeIndex: themeIndex,
      ),
    );
  }

  void changeTheme(CupertinoThemeData theme, int selectedThemeIndex) async {
    emit(
      state.copyWith(
        theme: theme,
        selectedThemeIndex: selectedThemeIndex,
      ),
    );

    _themeBox.put(kThemeBox, selectedThemeIndex);
  }
}
