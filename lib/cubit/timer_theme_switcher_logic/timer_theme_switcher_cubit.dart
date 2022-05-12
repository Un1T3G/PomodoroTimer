import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/core/values/keys.dart';

part 'timer_theme_switcher_state.dart';

class TimerThemeSwitcherCubit extends Cubit<TimerThemeSwitcherState> {
  TimerThemeSwitcherCubit() : super(TimerThemeSwitcherState.initial());

  late final Box<int> _timerThemeBox;

  void init() async {
    _timerThemeBox = await Hive.openBox<int>(kTimerThemeBox);

    int index = _timerThemeBox.get(kTimerThemeBox)!;

    emit(state.copyWith(selectedThemeIndex: index));
  }

  void changeTheme(int index) async {
    emit(
      state.copyWith(
        selectedThemeIndex: index,
      ),
    );

    await _timerThemeBox.put(kTimerThemeBox, index);
  }
}
