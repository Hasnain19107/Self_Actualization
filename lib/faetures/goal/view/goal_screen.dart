import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../binding/goal_binding.dart';
import '../controller/goal_controller.dart';
import '../widgets/goal_card_widget.dart';
import '../widgets/goal_item_widget.dart';
import '../widgets/coaching_offer_banner_widget.dart';
import '../../../core/const/app_exports.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GoalBinding().dependencies();
    final controller = Get.find<GoalController>();
    final AppSizes appSizes = AppSizes();

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
              // Header with back button and title
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.inputBorderGrey,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),
              ),
              Gap(12),
              CustomTextWidget(
                text: 'Goal Tracker',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: AppColors.black,
                textAlign: TextAlign.center,
              ),

              const Gap(24),

              // Search Bar
              SearchBarWidget(
                searchController: controller.searchController,
                onChanged: controller.onSearchChanged,
                onMicTap: controller.onMicTap,
              ),
              const Gap(24),

              // Coaching Offer Banner (if eligible)
              Obx(() {
                if (controller.isCoachingOfferEligible) {
                  return CoachingOfferBannerWidget(controller: controller);
                }
                return const SizedBox.shrink();
              }),
              const Gap(24),

              // Current Goals Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Obx(
                      () {
                        final currentGoals = controller.currentGoals;
                        final isLoading = controller.isLoadingGoals.value &&
                            controller.goals.isEmpty;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              text: 'Current Goals',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              textColor: AppColors.black,
                              textAlign: TextAlign.left,
                            ),
                            const Gap(16),
                            if (isLoading)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CustomProgressIndicator(),
                                ),
                              )
                            else if (currentGoals.isEmpty)
                              CustomTextWidget(
                                text: 'No active goals yet. Add a new goal to get started!',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                textColor: AppColors.mediumGray,
                                textAlign: TextAlign.left,
                              ),
                            if (!isLoading && currentGoals.isNotEmpty)
                              ...currentGoals.map(
                                (goal) => GoalItemWidget(
                                  barColor: controller.barColorForGoal(goal),
                                  title: goal.title,
                                  subtitle: controller.formattedDateRange(goal),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const Gap(16),
                  Obx(() {
                    // Observe goals to update chart
                    final _ = controller.goals.length;
                    return CircularProgressChartWidget(
                      segments: controller.chartSegments,
                    );
                  }),
                ],
              ),
              const Gap(24),

              // Add New Goal Button
              GestureDetector(
                onTap: controller.onAddNewGoal,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(41),
                    border: Border.all(
                      color: AppColors.inputBorderGrey,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextWidget(
                        text: 'Add New Goal',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.black,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(24),

              // Share to Coach Button
              Obx(
                () {
                  final isSharing = controller.isSharingGoals.value;
                  return GestureDetector(
                    onTap: isSharing ? null : controller.shareGoalsToCoach,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(
                          color: AppColors.inputBorderGrey,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSharing) ...[
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CustomProgressIndicator(strokeWidth: 2),
                            ),
                            const Gap(12),
                          ],
                          CustomTextWidget(
                            text: 'Share to Coach',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.black,
                            textAlign: TextAlign.center,
                          ),
                          const Gap(8),
                          Icon(
                            Icons.share,
                            color: isSharing ? AppColors.inputBorderGrey : AppColors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Gap(24),

              // All Goals Section
              CustomTextWidget(
                text: 'All Goals',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),
              const Gap(16),

              // All Goals List
              Obx(
                () {
                  if (controller.isLoadingGoals.value &&
                      controller.goals.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CustomProgressIndicator(),
                      ),
                    );
                  }

                  final goals = controller.filteredGoals;

                  if (goals.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomTextWidget(
                          text: 'No goals found.',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.mediumGray,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: goals.map((goal) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GoalCardWidget(
                          goal: goal,
                          emoji: controller.emojiForGoal(goal),
                          date: controller.formattedStartDate(goal),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
