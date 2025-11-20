import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../binding/review_result_binding.dart';
import '../widgets/assessment_grid_widget.dart';
import '../widgets/review_result_action_buttons_widget.dart';
import '../controller/review_result_controller.dart';
import '../../../core/const/app_exports.dart';

class ReviewResultScreen extends StatelessWidget {
  const ReviewResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ReviewResultBinding().dependencies();
    final AppSizes appSizes = AppSizes();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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

                // Assessment Grid - with calculated height
                GetBuilder<ReviewResultController>(
                  builder: (controller) {
                    return Obx(() {
                      if (controller.isLoading.value) {
                        return SizedBox(
                          height: screenHeight * 0.6,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return SizedBox(
                        height: screenHeight * 0.6, // Use 60% of screen height
                        child: AssessmentGridWidget(),
                      );
                    });
                  },
                ),
                const Gap(24),

                // Action Buttons
                const ReviewResultActionButtonsWidget(),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
