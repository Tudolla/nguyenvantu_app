import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:monstar/components/core/app_colors.dart';

/// This is used for toast notification that pop down from top only for login feature
class ToastNotifier {
  static void showDialogMessage(BuildContext context, String message) {
    DelightToastBar(
      builder: (context) {
        return ToastCard(
          color: AppColors.backgroundButton,
          leading: Icon(
            color: Colors.white,
            Icons.notifications,
            size: 30,
          ),
          title: Text(
            message,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        );
      },
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: Durations.extralong2,
    ).show(context);
  }
}
