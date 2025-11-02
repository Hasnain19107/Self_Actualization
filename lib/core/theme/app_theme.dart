import 'package:flutter/material.dart';
import '../Const/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.white,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(useMaterial3: true,
      scaffoldBackgroundColor: AppColors.black,
    );
  }
}
