import 'package:flutter/cupertino.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/views/widgets/action_button.dart';

Future<void> openPopupModal({
  required BuildContext context,
  required String title,
  void Function()? onCancel,
  void Function()? onConiform,
}) async {
  await showCupertinoDialog(
    context: context,
    builder: (_) => _PopupModal(
      title: title,
      onCancel: onCancel,
      onConiform: onConiform,
    ),
  );
}

class _PopupModal extends StatelessWidget {
  const _PopupModal({
    Key? key,
    required this.title,
    this.onCancel,
    this.onConiform,
  }) : super(key: key);

  final String title;
  final void Function()? onCancel;
  final void Function()? onConiform;

  void _cancel(BuildContext context) {
    Navigator.of(context).pop();
    onCancel?.call();
  }

  void _coniform(BuildContext context) {
    Navigator.of(context).pop();
    onConiform?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _cancel(context),
      child: Container(
        color: kBGColor.withOpacity(0.5),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(kDefaultMargin),
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(kDefaultRadius),
          ),
          constraints: const BoxConstraints(
            maxWidth: 450,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: kTextColor,
                ),
              ),
              const SizedBox(height: kDefaultMargin),
              Row(
                children: [
                  Flexible(
                    child: ActionButton.withChildText(
                      color: kIndigoColor.withOpacity(0.3),
                      title: 'Cancel',
                      titleColor: kIndigoColor,
                      onPressed: () => _cancel(context),
                    ),
                  ),
                  const SizedBox(width: kDefaultMargin),
                  Flexible(
                    child: ActionButton.withChildText(
                      color: kIndigoColor,
                      title: 'Coniform',
                      titleColor: kTextColor,
                      onPressed: () => _coniform(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
