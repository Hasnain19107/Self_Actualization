import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/Const/app_colors.dart';
import 'core/app_routes/app_pages.dart';
import 'core/app_routes/app_routes.dart';
import 'core/const/app_strings.dart';
import 'data/exception/theme/app_theme.dart';
import 'data/services/fcm_service.dart' show FcmService, firebaseMessagingBackgroundHandler;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeFcm();
  }

  Future<void> _initializeFcm() async {
    try {
      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      
      // Initialize FCM service
      await FcmService().initialize();
    } catch (e) {
      debugPrint('FCM initialization error: $e');
    }
  }

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
      initialRoute: AppRoutes.splashScreen,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      // Prevent system font settings from affecting app
      builder: (context, child) {
        return MediaQuery(
          // Override text scale factor to always be 1.0 (ignore system settings)
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0),
            // Also disable bold text accessibility setting
            boldText: false,
          ),
          child: child!,
        );
      },
    );
  }
}
