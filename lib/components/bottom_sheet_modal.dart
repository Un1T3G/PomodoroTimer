import 'package:flutter/cupertino.dart';

Future<void> openBottomSheetModal({
  required BuildContext context,
  required Widget child,
}) async {
  await showCupertinoDialog(
    context: context,
    builder: (_) {
      return const _BottomSheetModal();
    },
  );
}

class _BottomSheetModal extends StatelessWidget {
  const _BottomSheetModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
