import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/utils/app_sizes.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../controller/plan_details_controller.dart';
import '../widgets/plan_details_header_widget.dart';
import '../widgets/plan_meta_needs_section_widget.dart';
import '../widgets/plan_feature_card_widget.dart';

/// Plan Details Screen
/// Displays detailed information about a selected subscription plan
class PlanDetailsScreen extends StatelessWidget {
  const PlanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appSizes = AppSizes();
    final controller = Get.find<PlanDetailsController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Obx(() {
          final plan = controller.currentPlan.value;

          if (plan == null) {
            return Center(
              child: CustomTextWidget(
                text: 'Plan details not available',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textColor: AppColors.black,
                textAlign: TextAlign.center,
              ),
            );
          }

          return Column(
            children: [
              PlanDetailsHeaderWidget(
                planName: plan.name,
                planPrice: plan.price,
                onBackPressed: () => Get.back(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: appSizes.getWidthPercentage(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meta Needs Section
                      if (controller.metaNeedsCategory != null)
                        PlanMetaNeedsSectionWidget(
                          metaNeedsCategory: controller.metaNeedsCategory!,
                        ),
                      Gap(appSizes.getHeightPercentage(3)),
                      // Feature Categories (Self, Social, Safety)
                      ...controller.featureCategories.map(
                        (category) => PlanFeatureCardWidget(
                          category: category,
                        ),
                      ),
                      Gap(appSizes.getHeightPercentage(3)),
                      // Continue Button
                      CustomElevatedButton(
                        text: 'Continue',
                        backgroundColor: AppColors.blue,
                        textColor: AppColors.white,
                        onPress: controller.onContinuePressed,
                        hasRightIcon: true,
                        iconColor: AppColors.white,
                        iconData: Icons.arrow_forward,
                        iconSize: 20,
                        width: double.infinity,
                      ),
                      Gap(appSizes.getHeightPercentage(1.8)),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

