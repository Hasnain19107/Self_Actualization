import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pixsa_petrol_pump/core/widgets/custom_back_button.dart';
import '../../../core/const/app_exports.dart';
import '../controllers/subscription_controller.dart';
import '../bindings/onBoarding_binding.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    SubscriptionBinding().dependencies();
    final controller = Get.find<SubscriptionController>();
    final AppSizes appSizes = AppSizes();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(() {
          // Show loading for entire screen
          if (controller.isLoadingCurrentSubscription.value) {
            return const Center(
              child: CustomProgressIndicator(),
            );
          }

          // Show error screen for entire screen
          if (controller.errorMessage.value.isNotEmpty && 
              controller.currentSubscription.value == null) {
            return ErrorScreenWidget(
              errorMessage: controller.errorMessage.value,
              onRetry: () => controller.refreshCurrentSubscription(),
            );
          }

          // Show no subscription message
         

          // Show content
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: appSizes.getWidthPercentage(3),
              vertical: appSizes.getHeightPercentage(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                Row(
                  children: [
                    CustomBackButton(),
                    
                    const Gap(12),
                    const Expanded(
                      child: CustomTextWidget(
                        text: 'Current Subscription',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                const Gap(24),

                // Current Subscription Section
                Obx(() {
                  final currentSub = controller.currentSubscription.value;
                  if (currentSub?.subscription != null) {
                    final subscription = currentSub!.subscription!;
                    final currentPlan = controller.currentActivePlan;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Current Plan Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.blue,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CustomTextWidget(
                                        text: 'Current Plan',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        textColor: AppColors.blue,
                                        textAlign: TextAlign.left,
                                      ),
                                      const Gap(4),
                                      CustomTextWidget(
                                        text: currentPlan != null
                                            ? '${currentPlan['planName']} (${currentPlan['price']})'
                                            : subscription.subscriptionType,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        textColor: AppColors.black,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: subscription.isActive
                                          ? AppColors.green
                                          : AppColors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: CustomTextWidget(
                                      text: subscription.isActive ? 'Active' : 'Inactive',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      textColor: AppColors.white,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(24),
                        // Subscription Details
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.darkwhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.inputBorderGrey,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                'Type',
                                subscription.subscriptionType,
                                Icons.card_membership,
                              ),
                              const Gap(12),
                              _buildInfoRow(
                                'Status',
                                subscription.isActive ? 'Active' : 'Inactive',
                                Icons.check_circle_outline,
                                valueColor: subscription.isActive
                                    ? AppColors.green
                                    : AppColors.red,
                              ),
                              const Gap(12),
                              _buildInfoRow(
                                'Started',
                                _formatDate(subscription.createdAt),
                                Icons.calendar_today_outlined,
                              ),
                              if (subscription.expiresAt != null) ...[
                                const Gap(12),
                                _buildInfoRow(
                                  'Expires',
                                  _formatDate(subscription.expiresAt),
                                  Icons.event_busy_outlined,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Gap(32),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Available Categories Section
                const CustomTextWidget(
                  text: 'Available Categories',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.black,
                  textAlign: TextAlign.left,
                ),
                const Gap(16),
                Expanded(
                  child: Obx(() {
                    // Show loading for categories
                    if (controller.isLoadingAvailableCategories.value) {
                      return const Center(
                        child: CustomProgressIndicator(),
                      );
                    }

                    final categories = controller.availableCategories;
                    
                    if (categories.isEmpty) {
                      return Center(
                        child: CustomTextWidget(
                          text: 'No categories available for this plan',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.mediumGray,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const Gap(12),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.darkwhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.inputBorderGrey,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlue.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.category_outlined,
                                  color: AppColors.blue,
                                  size: 20,
                                ),
                              ),
                              const Gap(16),
                              Expanded(
                                child: CustomTextWidget(
                                  text: category,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  textColor: AppColors.black,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.green,
                                size: 24,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
                CustomElevatedButton(
                  text: 'Upgrade Plan',
                  onPress: () {
                    Get.toNamed(AppRoutes.selectPlanScreen);
                  },
                  backgroundColor: AppColors.blue,
                  textColor: AppColors.white,
                  hasRightIcon: false,
                  iconData: Icons.arrow_forward,
                  iconColor: AppColors.white,
                  iconSize: 20,
                  isLoading: false,
                  width: double.infinity,
                ),
              ],
            ),
          );
        }),

      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.lightBlue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.blue,
            size: 20,
          ),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                text: label,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.mediumGray,
                textAlign: TextAlign.left,
              ),
              const Gap(4),
              CustomTextWidget(
                text: value,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: valueColor ?? AppColors.black,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
