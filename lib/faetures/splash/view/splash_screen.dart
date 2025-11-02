import 'package:flutter/material.dart';
import '../../../core/Const/app_colors.dart';
import '../../../core/Const/app_images.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            AppImages.logo,
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.height * 0.35,
          ),
        ),
      ),
    );
  }
}
