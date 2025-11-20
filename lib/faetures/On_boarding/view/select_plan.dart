import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/const/app_exports.dart';


class SelectPlanScreen extends StatefulWidget {
  const SelectPlanScreen({super.key});

  @override
  State<SelectPlanScreen> createState() => _SelectPlanScreenState();
}

class _SelectPlanScreenState extends State<SelectPlanScreen> {
  final AppSizes appSizes = AppSizes();
  final SubscriptionController subscriptionController =
      Get.put(SubscriptionController());

  String? selectedPlanId;

  Map<String, dynamic>? get _selectedPlan {
    if (selectedPlanId == null) return null;
    return subscriptionController.subscriptionPlans.firstWhereOrNull(
      (plan) => plan['planId'] == selectedPlanId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final plans = subscriptionController.subscriptionPlans;

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
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return SubscriptionCardWidget(
                      planName: plan['planName'] as String,
                      price: plan['price'] as String,
                      onTap: () {
                        setState(() {
                          selectedPlanId = plan['planId'] as String;
                        });
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const Gap(16),
                ),
              ),
              if (_selectedPlan != null) ...[
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
                    text:
                        'Selected: ${_selectedPlan!['planName']} (${_selectedPlan!['price']})',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.black,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              Gap(24),
              CustomElevatedButton(
                text: 'Continue',
                backgroundColor: AppColors.blue,
                textColor: AppColors.white,
                hasRightIcon: true,
                iconData: Icons.arrow_forward,
                iconColor: AppColors.white,
                iconSize: 20,
                onPress: _handleContinue,
                width: double.infinity,
              ),
              Gap(appSizes.getHeightPercentage(2)),
            ],
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (selectedPlanId == null) {
      ToastClass.showCustomToast(
        'Please select a plan to continue',
        type: ToastType.error,
      );
      return;
    }

    // Find the selected plan
    final selectedPlan = subscriptionController.subscriptionPlans.firstWhereOrNull(
      (plan) => plan['planId'] == selectedPlanId,
    );

    if (selectedPlan != null) {
      // Navigate to category level screen with plan data
      Get.toNamed(
        AppRoutes.categoryLevelScreen,
        arguments: selectedPlan,
      );
    } else {
      ToastClass.showCustomToast(
        'Plan not found',
        type: ToastType.error,
      );
    }
  }
}