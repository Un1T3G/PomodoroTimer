import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/cubit/timer_theme_switcher_logic/timer_theme_switcher_cubit.dart';
import 'package:pomodoro_timer_task_management/themes/timer_slider_themes.dart';
import 'package:pomodoro_timer_task_management/views/widgets/back_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/page_title.dart';

class TimerThemePickerPage extends StatelessWidget {
  const TimerThemePickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: const [
            _BackButton(),
            _Title(),
            _TimerList(),
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
    return PageTitle.withHorizontalMargin(title: 'Timer Theme');
  }
}

class _TimerList extends StatelessWidget {
  const _TimerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TimerThemeSwitcherCubit>();
    const timersLength = 4;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      padding: const EdgeInsets.only(
        left: kDefaultMargin,
        right: kDefaultMargin,
        bottom: kDefaultMargin,
      ),
      mainAxisSpacing: kDefaultMargin,
      crossAxisSpacing: kDefaultMargin,
      children: List.generate(
        timersLength,
        (index) => _TimerCard(
          title: 'Timer ${index + 1}',
          isSelected: cubit.state.selectedThemeIndex == index,
          onPressed: () => cubit.changeTheme(index),
          child: Stack(
            alignment: Alignment.center,
            children: [
              getTimerWidget(
                color: CupertinoTheme.of(context).primaryColor,
                value: 0.35,
                widgetIndex: index,
              ),
              const _TimerTitle(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerCard extends StatelessWidget {
  const _TimerCard({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: kCardColor,
      padding: const EdgeInsets.all(kDefaultMargin),
      child: Column(
        children: [
          SizedBox(
            height: 25,
            child: Row(
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
                    ? Icon(
                        CupertinoIcons.checkmark_alt,
                        size: 25,
                        color: CupertinoTheme.of(context).primaryColor,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          const SizedBox(height: kDefaultMargin * 2),
          Expanded(
            child: child,
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class _TimerTitle extends StatelessWidget {
  const _TimerTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FractionallySizedBox(
        widthFactor: 0.45,
        heightFactor: 0.45,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            '23:05',
            style: TextStyle(
              fontSize: 80,
              color: kTextColor,
              fontFamily: 'Lato-Regular',
            ),
          ),
        ),
      ),
    );
  }
}
