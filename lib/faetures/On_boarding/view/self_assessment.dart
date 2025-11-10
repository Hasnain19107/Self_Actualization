import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../../../core/const/app_exports.dart';

class SelfAssessmentScreen extends StatelessWidget {
  SelfAssessmentScreen({super.key});

  final AppSizes appSizes = AppSizes();
  final controller = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.getWidthPercentage(3),
            vertical: appSizes.getHeightPercentage(2),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                      ),
                    ),
                    // Title
                    CustomTextWidget(
                      text: 'Self Assessment',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.black,
                    ),
                    // Progress Indicator
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomTextWidget(
                          text: controller.progressText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(Get.height * 0.04),
                      // Question
                      Obx(
                        () => CustomTextWidget(
                          text: controller.currentQuestion.value,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          textColor: AppColors.black,
                          textAlign: TextAlign.left,
                          limitedCharacters: false,
                        ),
                      ),
                      Gap(Get.height * 0.06),
                      // Large Rating Display
                      Center(
                        child: Obx(
                          () => CustomTextWidget(
                            text: controller.selectedRating.value.toString(),
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            textColor: AppColors.black,
                          ),
                        ),
                      ),
                      Gap(Get.height * 0.04),
                      // Rating Input (Numbers 1-7)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(7, (index) {
                              final rating = index + 1;
                              final isSelected =
                                  controller.selectedRating.value == rating;
                              return GestureDetector(
                                onTap: () => controller.selectRating(rating),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? AppColors.blue
                                        : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: CustomTextWidget(
                                      text: rating.toString(),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      textColor: isSelected
                                          ? AppColors.white
                                          : AppColors.black,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      Gap(Get.height * 0.06),
                      // Rating Legend
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...controller.ratingDescriptions.entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextWidget(
                                    text: '${entry.key}:',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    textColor: AppColors.blue,
                                  ),
                                  Gap(8),
                                  Expanded(
                                    child: CustomTextWidget(
                                      text: entry.value,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppColors.black,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(32),
                      CustomElevatedButton(
                        text: 'Continue',
                        backgroundColor: AppColors.blue,
                        textColor: AppColors.white,
                        onPress: () {
                          Get.toNamed(AppRoutes.reviewResultScreen);
                        },
                        hasRightIcon: true,
                        iconColor: AppColors.white,
                        iconData: Icons.arrow_forward,
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),
              ),

              // Continue Button
            ],
          ),
        ),
      ),
    );
  }
}
