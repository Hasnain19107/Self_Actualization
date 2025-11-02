import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/Const/app_colors.dart';
import 'core/app_routes/app_pages.dart';
import 'core/app_routes/app_routes.dart';
import 'core/const/app_strings.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SPLASHSCREEN,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
    );
  }
}
