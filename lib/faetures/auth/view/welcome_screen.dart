import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/const/app_exports.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final AppSizes appSizes = AppSizes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFAFAFA,
      ), // Light beige/off-white background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.getWidthPercentage(3),
            vertical: appSizes.getHeightPercentage(2),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap(Get.height * 0.15),
                      // Welcome Title
                      CustomTextWidget(
                        text: "Welcome to Pixsa!",
                        fontSize: 22,
                        fontWeight: FontWeight.w700,

                        textColor: AppColors.black,
                        textAlign: TextAlign.center,
                      ),
                      Gap(8),
                      // Welcome Description
                      CustomTextWidget(
                        text:
                            "Voluptatem et impedit voluptatem \n architecto pariatur ea nobis delectus.",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        textColor: AppColors.mediumGray,

                        textAlign: TextAlign.center,
                      ),
                      Gap(Get.height * 0.06),
                      // Welcome Logo
                      Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: Get.height * 0.35,
                            maxWidth: Get.width * 0.8,
                          ),
                          child: Image.asset(
                            AppImages.welcomeLogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Get Started Button
              Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.04),
                child: CustomElevatedButton(
                  text: "Get Started",
                  backgroundColor: AppColors.blue,
                  textColor: AppColors.white,
                  onPress: () {
                    Get.toNamed(AppRoutes.selectPlanScreen);
                  },
                  hasRightIcon: true,
                  iconColor: AppColors.white,
                  iconData: Icons.arrow_forward,
                  iconSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
