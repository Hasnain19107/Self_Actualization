import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../Const/app_colors.dart';

/// Enum for toast types
enum ToastType { success, error, warning, simple }

class ToastClass {
  static void showCustomToast(
    String message, {
    ToastType type = ToastType.simple,
    ToastGravity gravity = ToastGravity.BOTTOM,
    double fontSize = 14.0,
    Toast? toastLength,
  }) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case ToastType.success:
        backgroundColor = AppColors.green;
        textColor = AppColors.white;
        break;
      case ToastType.error:
        backgroundColor = AppColors.red;
        textColor = AppColors.white;
        break;
      case ToastType.warning:
        backgroundColor = AppColors.orange;
        textColor = AppColors.white;
        break;
      case ToastType.simple:
        backgroundColor = AppColors.black;
        textColor = AppColors.white;
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
