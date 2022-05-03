import 'package:flutter/cupertino.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';

class RounedCard extends StatelessWidget {
  const RounedCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  factory RounedCard.withHorizontalMargin({
    Key? key,
    required Widget child,
  }) {
    return RounedCard(
      key: key,
      child: child,
      margin: const EdgeInsets.only(
        left: kDefaultMargin,
        right: kDefaultMargin,
        bottom: kDefaultMargin * 1.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(kDefaultMargin),
      margin: margin ?? const EdgeInsets.only(bottom: kDefaultMargin * 1.2),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: child,
    );
  }
}
