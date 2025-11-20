import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controller/review_result_controller.dart';
import '../../../core/const/app_exports.dart';

class ReviewResultActionButtonsWidget extends StatelessWidget {
  const ReviewResultActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewResultController>();

    return Column(
      children: [
        // Download PDF Summary Button
        GestureDetector(
          onTap: controller.downloadPDF,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(1000),
              border: Border.all(color: AppColors.inputBorderGrey, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  text: 'Download PDF Summary',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.black,
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                const Icon(Icons.download, color: AppColors.blue, size: 20),
              ],
            ),
          ),
        ),
        const Gap(12),
        // Share to Coach Button
        GestureDetector(
          onTap: controller.shareToCoach,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(1000),
              border: Border.all(color: AppColors.inputBorderGrey, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  text: 'Share to Coach',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.black,
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                const Icon(Icons.share, color: AppColors.blue, size: 20),
              ],
            ),
          ),
        ),
        const Gap(12),
        // Continue Button
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.profileSetupScreen);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  text: 'Continue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.white,
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
