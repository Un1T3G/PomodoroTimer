import 'package:flutter/cupertino.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';

class ListButton extends StatelessWidget {
  const ListButton({
    Key? key,
    required this.leading,
    required this.title,
    this.titleColor,
    required this.trailing,
    required this.onPressed,
  }) : super(key: key);

  final Widget leading;
  final String title;
  final Color? titleColor;
  final Widget trailing;
  final void Function() onPressed;

  factory ListButton.withLeadingIcon({
    Key? key,
    required IconData iconData,
    double? iconSize,
    Color? iconColor,
    required String title,
    Color? titleColor,
    Widget? trailing,
    required void Function() onPressed,
  }) {
    return ListButton(
      key: key,
      leading: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
      title: title,
      titleColor: titleColor,
      trailing: trailing ?? const SizedBox(),
      onPressed: onPressed,
    );
  }

  factory ListButton.withTrailingSwitch({
    Key? key,
    required IconData iconData,
    double? iconSize,
    Color? iconColor,
    required String title,
    Color? titleColor,
    Widget? trailing,
    required bool value,
    required void Function(bool) onPressed,
  }) {
    return ListButton(
      key: key,
      leading: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
      title: title,
      titleColor: titleColor,
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onPressed,
      ),
      onPressed: () => onPressed.call(!value),
    );
  }

  factory ListButton.withTrailingChevronIcon(
      {Key? key,
      required IconData iconData,
      double? iconSize,
      Color? iconColor,
      required String title,
      Color? titleColor,
      required Function() onPressed}) {
    return ListButton.withLeadingIcon(
      key: key,
      iconData: iconData,
      iconSize: iconSize,
      iconColor: iconColor,
      title: title,
      titleColor: titleColor,
      trailing: const Icon(
        CupertinoIcons.chevron_forward,
        color: kGreyColor,
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: kDefaultMargin / 2),
      onPressed: onPressed.call,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading,
          const SizedBox(width: kDefaultMargin / 2),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: titleColor ?? CupertinoColors.white,
              ),
            ),
          ),
          const SizedBox(width: kDefaultMargin / 2),
          trailing,
        ],
      ),
    );
  }
}
