import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/const/app_exports.dart';

class SelectPlanScreen extends StatelessWidget {
  const SelectPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppSizes appSizes = AppSizes();
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.getWidthPercentage(4),
            vertical: appSizes.getHeightPercentage(3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(appSizes.getHeightPercentage(2)),
              CustomTextWidget(
                text: 'Select Subscription',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),
              Gap(12),
              CustomTextWidget(
                text: 'Change Plan',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),
              Gap(24),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: controller.subscriptionPlans.length,
                  itemBuilder: (context, index) {
                    final plan = controller.subscriptionPlans[index];
                    return SubscriptionCardWidget(
                      planName: plan['planName'] as String,
                      price: plan['price'] as String,
                      onTap: () => controller.selectPlan(plan),
                    );
                  },
                  separatorBuilder: (_, __) => const Gap(16),
                ),
              ),
              Obx(() {
                final selectedPlanId = controller.selectedPlanId.value;
                if (selectedPlanId.isEmpty) return const SizedBox.shrink();
                
                // Find plan from static list
                final selectedPlan = controller.subscriptionPlans.firstWhereOrNull(
                  (plan) => plan['planId'] == selectedPlanId,
                );
                
                if (selectedPlan == null) return const SizedBox.shrink();
                
                final planName = selectedPlan['planName'] as String;
                final planPrice = selectedPlan['price'] as String;
                
                return Column(
                  children: [
                    Gap(16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: CustomTextWidget(
                        text: 'Selected: $planName ($planPrice)',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }),
              Gap(24),
              CustomElevatedButton(
                text: 'Continue',
                backgroundColor: AppColors.blue,
                textColor: AppColors.white,
                hasRightIcon: true,
                iconData: Icons.arrow_forward,
                iconColor: AppColors.white,
                iconSize: 20,
                onPress: controller.handlePlanContinue,
                width: double.infinity,
              ),
              Gap(appSizes.getHeightPercentage(2)),
            ],
          ),
        ),
      ),
    );
  }
}