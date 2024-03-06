import 'package:flutter/cupertino.dart';

class ToastNotification {
  static const _duration = Duration(seconds: 3);
  static void showSuccess(BuildContext context, String message) {
    // toastification.show(
    //   context: context,
    //   title: Text(message),
    //   autoCloseDuration: _duration,
    //   type: ToastificationType.success,
    // );
  }

  static void showError(BuildContext context, String message) {
    // toastification.show(
    //   context: context,
    //   title: Text(message),
    //   autoCloseDuration: _duration,
    //   type: ToastificationType.error,
    // );
  }

  static void showInfo(BuildContext context, String message) {
    // toastification.show(
    //   context: context,
    //   title: Text(message),
    //   autoCloseDuration: _duration,
    //   type: ToastificationType.success,
    // );
  }
}
