import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../binding/goal_binding.dart';
import '../controller/goal_controller.dart';
import '../widgets/goal_card_widget.dart';
import '../widgets/goal_item_widget.dart';
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.getWidthPercentage(3),
            vertical: appSizes.getHeightPercentage(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and title
              Center(
                child: CustomTextWidget(
                  text: 'Goal Tracker',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.black,
                  textAlign: TextAlign.center,
                ),
              ),

              const Gap(24),

              // Search Bar
              SearchBarWidget(
                searchController: controller.searchController,
                onChanged: controller.onSearchChanged,
                onMicTap: controller.onMicTap,
              ),
              const Gap(24),

              // Current Goals Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Goal List (Left)
                  Expanded(
                    child: Column(
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
                        ...controller.currentGoals.map(
                          (goal) => GoalItemWidget(
                            barColor: goal['barColor'],
                            title: goal['title'],
                            subtitle: goal['subtitle'],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  // Circular Progress Chart (Right)
                  const CircularProgressChartWidget(),
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
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.filteredGoals.length,
                    itemBuilder: (context, index) {
                      final goal = controller.filteredGoals[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GoalCardWidget(
                          emoji: goal['emoji'],
                          title: goal['title'],
                          category: goal['category'],
                          date: goal['date'],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
