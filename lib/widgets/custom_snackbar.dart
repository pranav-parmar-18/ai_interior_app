import 'package:flutter/material.dart';

enum SnackBarType { success, error, info, warning }

class CustomSnackBar {
  static void success(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(context, message, type: SnackBarType.success, duration: duration);
  }

  static void error(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(context, message, type: SnackBarType.error, duration: duration);
  }

  static void info(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(context, message, type: SnackBarType.info, duration: duration);
  }

  static void warning(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(context, message, type: SnackBarType.warning, duration: duration);
  }

  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration? duration,
  }) {
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    Color backgroundColor;
    IconData iconData;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = const Color(0xFF12B76A);
        iconData = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        backgroundColor = const Color(0xFFF04438);
        iconData = Icons.error_outline;
        break;
      case SnackBarType.warning:
        backgroundColor = const Color(0xFFFF983D);
        iconData = Icons.warning_amber_outlined;
        break;
      case SnackBarType.info:
        backgroundColor = const Color(0xFF101828);
        iconData = Icons.info_outline;
        break;
    }

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: duration ?? const Duration(seconds: 3),
    );

    messenger.showSnackBar(snackBar);
  }
}
