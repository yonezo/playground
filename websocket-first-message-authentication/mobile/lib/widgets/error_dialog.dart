import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ErrorDialog extends StatelessWidget {
  final String error;
  const ErrorDialog._(this.error);

  static Future<void> show(
    BuildContext context,
    String errorMessage,
  ) {
    return showCupertinoDialog(
      context: context,
      builder: (_) => ErrorDialog._(errorMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Error'),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        )
      ],
    );
  }
}

class LoadingSheet extends StatelessWidget {
  const LoadingSheet._();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(48),
        ),
      ),
      builder: (_) => const LoadingSheet._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Theme.of(context).colorScheme.primary,
          size: 80,
        ),
      ),
    );
  }
}
