import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../controller/goal_controller.dart';
import '../../../data/models/goal/goal_model.dart';

class GoalCardWidget extends StatelessWidget {
  final GoalModel goal;
  final String emoji;
  final String date;

  const GoalCardWidget({
    super.key,
    required this.goal,
    required this.emoji,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalController>();
    
    return Obx(() {
      final isExpanded = controller.expandedGoalIds.contains(goal.id);
      final goalDetails = controller.getGoalDetails(goal.id) ?? goal;
      final isLoadingDetails = controller.isLoadingGoalDetails[goal.id] ?? false;
      final isCompleting = controller.isCompletingGoal[goal.id] ?? false;
      final isDeleting = controller.isDeletingGoal[goal.id] ?? false;

      return GestureDetector(
        onTap: () => controller.toggleGoalExpansion(goal.id),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkwhite,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main content row
              Row(
                children: [
                  // Emoji icon
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const Gap(8),
                  // Title
                  Expanded(
                    child: CustomTextWidget(
                      text: goal.title,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.black,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const Gap(12),
                  // Category and date badge
                  CustomTextWidget(
                    text: goal.type,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.black,
                    textAlign: TextAlign.right,
                  ),
                  const Gap(4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomTextWidget(
                      text: date,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Gap(8),
                  // Expand/collapse icon
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.black,
                    size: 20,
                  ),
                ],
              ),
              
              // Expanded content
              if (isExpanded) ...[
                const Gap(16),
                if (isLoadingDetails)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CustomProgressIndicator(),
                    ),
                  )
                else ...[
                  // Description
                  if (goalDetails.description.isNotEmpty) ...[
                    CustomTextWidget(
                      text: goalDetails.description,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.mediumGray,
                      textAlign: TextAlign.left,
                    ),
                    const Gap(16),
                  ],
                  // Action buttons
                  Row(
                    children: [
                      // Complete button (only if not completed)
                      if (!goalDetails.isCompleted)
                        Expanded(
                          child: GestureDetector(
                            onTap: (isCompleting || isDeleting)
                                ? null
                                : () => controller.completeGoal(goal.id),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: (isCompleting || isDeleting)
                                    ? AppColors.blue.withOpacity(0.5)
                                    : AppColors.blue,
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              child: Center(
                                child: isCompleting
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CustomProgressIndicator(),
                                      )
                                    : const CustomTextWidget(
                                        text: 'Complete',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppColors.white,
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      if (!goalDetails.isCompleted) const Gap(12),
                      // Delete button
                      Expanded(
                        child: GestureDetector(
                          onTap: (isCompleting || isDeleting)
                              ? null
                              : () => controller.deleteGoal(goal.id),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(1000),
                              border: Border.all(
                                color: (isCompleting || isDeleting)
                                    ? AppColors.red.withOpacity(0.5)
                                    : AppColors.red,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: isDeleting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CustomProgressIndicator(),
                                    )
                                  : const CustomTextWidget(
                                      text: 'Delete',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      textColor: AppColors.red,
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      );
    });
  }
}
