part of 'timer_theme_switcher_cubit.dart';

class TimerThemeSwitcherState {
  final int selectedThemeIndex;

  TimerThemeSwitcherState({
    required this.selectedThemeIndex,
  });

  factory TimerThemeSwitcherState.initial() {
    return TimerThemeSwitcherState(
      selectedThemeIndex: 0,
    );
  }

  TimerThemeSwitcherState copyWith({
    int? selectedThemeIndex,
  }) {
    return TimerThemeSwitcherState(
      selectedThemeIndex: selectedThemeIndex ?? this.selectedThemeIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimerThemeSwitcherState &&
        other.selectedThemeIndex == selectedThemeIndex;
  }

  @override
  int get hashCode => selectedThemeIndex.hashCode;
}
