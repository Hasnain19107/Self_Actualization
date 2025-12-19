import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_actualisation/core/widgets/custom_back_button.dart';
import 'package:self_actualisation/faetures/subscription/controllers/subscription_controller.dart';
import 'package:self_actualisation/faetures/subscription/widgets/subscription_card_widget.dart';


import '../../../core/const/app_exports.dart';

class SelectPlanScreen extends StatelessWidget {
  const SelectPlanScreen({super.key});

 
  
  

  @override
  Widget build(BuildContext context) {
    final AppSizes appSizes = AppSizes();
    final controller = Get.put(SubscriptionController());
    
    // Check if this is onboarding flow (new user) or upgrade flow (existing user)
    final arguments = Get.arguments as Map<String, dynamic>?;
    final isOnboarding = arguments?['isOnboarding'] as bool? ?? false;

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
              // Back button (only show when not onboarding)
              if (!isOnboarding) ...[
                Row(
                  children: [
                  CustomBackButton(),
                  ],
                ),
                const Gap(16),
              ] else ...[
                Gap(appSizes.getHeightPercentage(2)),
              ],
              CustomTextWidget(
                text: 'Select Subscription',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),
              const Gap(12),
              CustomTextWidget(
                text: isOnboarding ? 'Choose a plan to get started' : 'Change Plan',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),
              Gap(24),
              Expanded(
                child: Obx(() {
                  // Access currentSubscription.value to make Obx reactive to subscription changes
                  final currentSubscription = controller.currentSubscription.value;
                  final isLoading = controller.isLoadingCurrentSubscription.value;
                  
                  // For onboarding flow, don't show any plan as active or disabled
                  // Only show active/disabled for existing users upgrading their plan
                  String? currentActivePlanId;
                  int currentPlanIndex = -1;
                  
                  if (!isOnboarding) {
                    // Get subscription type from NESTED subscription object
                    final subscriptionType = currentSubscription?.subscription?.subscriptionType;
                    
                    // Get current active plan ID from subscription
                    if (subscriptionType != null && subscriptionType.isNotEmpty) {
                      final typeLower = subscriptionType.toLowerCase();
                      if (typeLower == 'free') {
                        currentActivePlanId = 'free';
                      } else if (typeLower == 'premium') {
                        currentActivePlanId = 'premium';
                      } else if (typeLower == 'coach') {
                        currentActivePlanId = 'coach';
                      }
                    }
                    
                    currentPlanIndex = currentActivePlanId != null
                        ? controller.subscriptionPlans.indexWhere(
                            (p) => p['planId'] == currentActivePlanId,
                          )
                        : -1;
                  }

                  if (isLoading && !isOnboarding) {
                    return const Center(child: CustomProgressIndicator());
                  }

                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: controller.subscriptionPlans.length,
                    itemBuilder: (context, index) {
                      final plan = controller.subscriptionPlans[index];
                      final planId = plan['planId'] as String;
                      final isCurrentPlan = !isOnboarding && planId == currentActivePlanId;
                      // Disable current plan and all plans below it (only for upgrade flow)
                      final isDisabled = !isOnboarding && currentPlanIndex >= 0 && index <= currentPlanIndex;

                      return SubscriptionCardWidget(
                        planName: plan['planName'] as String,
                        price: plan['price'] as String,
                        isCurrentPlan: isCurrentPlan,
                        isDisabled: isDisabled,
                        onTap: isDisabled ? null : () => controller.selectPlan(plan),
                      );
                    },
                    separatorBuilder: (_, __) => const Gap(16),
                  );
                }),
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
              Obx(() {
                final isProcessing = controller.isProcessingPayment.value || 
                                    controller.isCreatingSubscription.value;
                return CustomElevatedButton(
                  text: 'Change Plan',
                  backgroundColor: AppColors.blue,
                  textColor: AppColors.white,
                  hasRightIcon: !isProcessing,
                  iconData: Icons.arrow_forward,
                  iconColor: AppColors.white,
                  iconSize: 20,
                  isLoading: isProcessing,
                  onPress: controller.handlePlanContinue,
                  width: double.infinity,
                );
              }),
              Gap(appSizes.getHeightPercentage(2)),
            ],
          ),
        ),
      ),
    );
  }
}