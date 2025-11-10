import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../binding/subscription_binding.dart';
import '../controller/subscription_controller.dart';
import '../widgets/subscription_card_widget.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize binding when screen is first created
    SubscriptionBinding().dependencies();
    final controller = Get.find<SubscriptionController>();
    final AppSizes appSizes = AppSizes();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.getWidthPercentage(4),
            vertical: appSizes.getHeightPercentage(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              AppHeaderWidget(
                title: 'Subscription',
                onNotificationTap: controller.onNotificationTap,
              ),
              const Gap(24),
              // Search Bar
              SearchBarWidget(
                searchController: controller.searchController,
                onChanged: controller.onSearchChanged,
                onMicTap: controller.onMicTap,
              ),
              const Gap(24),
              // Change Plan Heading
              const CustomTextWidget(
                text: 'Change Plan',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),
              const Gap(16),
              // Subscription Cards
              Expanded(
                child: Column(
                  children: controller.subscriptionPlans.map((plan) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SubscriptionCardWidget(
                        planName: plan['planName'] as String,
                        price: plan['price'] as String,
                        onTap: () =>
                            controller.onPlanTap(plan['planId'] as String),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
