import 'package:flutter/cupertino.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';

class CardTitle extends StatelessWidget {
  const CardTitle({
    Key? key,
    required this.title,
    this.margin,
  }) : super(key: key);

  final String title;
  final EdgeInsets? margin;

  factory CardTitle.withHorizontalMargin({
    Key? key,
    required String title,
  }) {
    return CardTitle(
      key: key,
      title: title,
      margin: const EdgeInsets.only(
        left: kDefaultMargin,
        right: kDefaultMargin,
        bottom: kDefaultMargin * 0.9,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ??
          const EdgeInsets.only(
            bottom: kDefaultMargin * 0.9,
          ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: CupertinoColors.white,
        ),
      ),
    );
  }
}
