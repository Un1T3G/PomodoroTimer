import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/cubit/theme_switcher_logic/theme_switcher_cubit.dart';
import 'package:pomodoro_timer_task_management/themes/app_themes.dart';
import 'package:pomodoro_timer_task_management/views/widgets/back_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/page_title.dart';

class ThemePickerPage extends StatelessWidget {
  const ThemePickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: const [
            _BackButton(),
            _Title(),
            _ThemeCardList(),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: BackButton(),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTitle.withHorizontalMargin(title: 'Theme');
  }
}

class _ThemeCardList extends StatelessWidget {
  const _ThemeCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ThemeSwitcherCubit>();

    final titles = [
      'Indigo',
      'Light moon',
    ];

    return Column(
      children: List.generate(
        appThemes.length,
        (index) => _ThemeCard(
          title: titles[index],
          color: appThemes[index].primaryColor,
          isSelected: index == cubit.state.selectedThemeIndex,
          onPressed: () => cubit.changeTheme(appThemes[index], index),
        ),
      ).toList(),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    Key? key,
    required this.title,
    required this.color,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final Color color;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultMargin),
      child: CupertinoButton(
        color: kCardColor,
        padding: const EdgeInsets.all(kDefaultMargin),
        onPressed: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: kTextColor,
                    ),
                  ),
                  isSelected
                      ? const Icon(
                          CupertinoIcons.checkmark_alt,
                          color: kTextColor,
                          size: 25,
                        )
                      : const SizedBox()
                ],
              ),
            ),
            const SizedBox(height: kDefaultMargin * 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.person_crop_circle,
                  color: color,
                ),
                const SizedBox(width: kDefaultMargin),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: kGreyColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FractionallySizedBox(
                        widthFactor: 0.76,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: kGreyColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: kDefaultMargin * 2),
                Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
