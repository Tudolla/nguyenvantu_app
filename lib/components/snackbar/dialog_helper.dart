import 'package:flutter/material.dart';
import 'package:monstar/components/snackbar/show_top_dialog.dart';

class DialogHelper {
  static void showTopSlidingDialog(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => FloatingTopDialog(
        message: message,
        duration: duration ?? Duration(seconds: 6),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(duration ?? Duration(seconds: 6), () {
      overlayEntry.remove();
    });
  }
}
