import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/const/app_exports.dart';


class ReviewResultScreen extends StatelessWidget {
  const ReviewResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ReviewResultBinding().dependencies();
    final AppSizes appSizes = AppSizes();
    final screenHeight = MediaQuery.of(context).size.height;
    Get.find<ReviewResultController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with padding
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: appSizes.getWidthPercentage(3),
                  vertical: appSizes.getHeightPercentage(2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    CustomTextWidget(
                      text: 'Review Results',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.black,
                      textAlign: TextAlign.left,
                    ),
                    const Gap(24),

                    // Title and Subtitle
                    Center(
                      child: Column(
                        children: [
                          CustomTextWidget(
                            text: 'Self-Actualization Assessment Scale',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            textColor: AppColors.black,
                            textAlign: TextAlign.center,
                          ),
                          const Gap(4),
                          CustomTextWidget(
                            text: '©The Coaching Centre',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textColor: AppColors.black,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                  ],
                ),
              ),

              // Assessment Grid - small left padding (10px)
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: GetBuilder<ReviewResultController>(
                  builder: (controller) {
                    return Obx(() {
                      if (controller.isLoading.value) {
                        return SizedBox(
                          height: screenHeight * 0.6,
                          child: const Center(
                            child: CustomProgressIndicator(),
                          ),
                        );
                      }
                      return SizedBox(
                        height: screenHeight * 0.75, // Use 75% of screen height to fit all categories and sub-needs
                        child: AssessmentGridWidget(
                          repaintBoundaryKey: controller.repaintBoundaryKey,
                        ),
                      );
                    });
                  },
                ),
              ),

              // Action Buttons section with padding
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: appSizes.getWidthPercentage(3),
                  vertical: appSizes.getHeightPercentage(2),
                ),
                child: const Column(
                  children: [
                    Gap(24),
                    ReviewResultActionButtonsWidget(),
                    Gap(20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
