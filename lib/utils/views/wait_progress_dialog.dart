import 'package:flutter/material.dart';

class WaitProgressDialog extends StatelessWidget {
  const WaitProgressDialog({super.key});

  static final Color _barrierColor = Colors.black.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static void show(
    BuildContext context, {
    barrierDismissible = false,
    int transitionDurationMill = 300,
    Color? barrierColor,
  }) {
    showGeneralDialog(
        context: context,
        barrierColor: barrierColor ?? _barrierColor,
        barrierDismissible: barrierDismissible,
        transitionDuration: Duration(milliseconds: transitionDurationMill),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return const WaitProgressDialog();
        });
  }

  static void close(BuildContext context) {
    Navigator.of(context).pop();
  }
}
