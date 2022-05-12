part of 'theme_switcher_cubit.dart';

class ThemeSwitcherState {
  final CupertinoThemeData theme;
  final int selectedThemeIndex;

  ThemeSwitcherState({
    required this.theme,
    required this.selectedThemeIndex,
  });

  factory ThemeSwitcherState.initial() => ThemeSwitcherState(
        theme: indigoTheme,
        selectedThemeIndex: 0,
      );

  ThemeSwitcherState copyWith({
    CupertinoThemeData? theme,
    int? selectedThemeIndex,
  }) {
    return ThemeSwitcherState(
      theme: theme ?? this.theme,
      selectedThemeIndex: selectedThemeIndex ?? this.selectedThemeIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeSwitcherState &&
        other.theme == theme &&
        other.selectedThemeIndex == selectedThemeIndex;
  }

  @override
  int get hashCode => theme.hashCode ^ selectedThemeIndex.hashCode;
}
