import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toast {
  const Toast._();

  static const Duration _defaultAutoCloseDuration = Duration(seconds: 1);

  static void success(BuildContext context, String text, {Duration? duration}) {
    _show(context, text, type: ToastificationType.success, duration: duration);
  }

  static void info(BuildContext context, String text, {Duration? duration}) {
    _show(context, text, type: ToastificationType.info, duration: duration);
  }

  static void warning(BuildContext context, String text, {Duration? duration}) {
    _show(context, text, type: ToastificationType.warning, duration: duration);
  }

  static void error(BuildContext context, String text, {Duration? duration}) {
    _show(context, text, type: ToastificationType.error, duration: duration);
  }

  static void _show(
    BuildContext context,
    String text, {
    required ToastificationType type,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      title: Text(text),
      autoCloseDuration: duration ?? _defaultAutoCloseDuration,
      type: type,
      style: ToastificationStyle.flat,
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
      applyBlurEffect: false,
    );
  }
}
