import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../binding/goal_binding.dart';
import '../controller/goal_controller.dart';
import '../widgets/date_picker_widget.dart';
import '../../../core/const/app_exports.dart';

class AddGoalScreen extends StatelessWidget {
  const AddGoalScreen({super.key});

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
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                        text: 'Add Goal',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black,
                        textAlign: TextAlign.center,
                      ),
                      // Spacer to center the title
                      const SizedBox(width: 40),
                      const Gap(32),

                      // Select Category Section - Styled Dropdown
                      CustomTextWidget(
                        text: 'Select Category',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      const Gap(12),
                      Obx(() {
                        final selectedType = controller.selectedGoalType.value;

                        // Helper function for emoji
                        String getEmoji(String category) {
                          switch (category) {
                            case 'Meta-Needs':
                              return '🌟';
                            case 'Self':
                              return '✏️';
                            case 'Social':
                              return '💬';
                            case 'Safety':
                              return '💪';
                            case 'Survival':
                              return '😊';
                            default:
                              return '🎯';
                          }
                        }

                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedType,
                              isExpanded: true,
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              dropdownColor: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              onChanged: (String? value) {
                                if (value != null) {
                                  controller.selectGoalType(value);
                                }
                              },
                              selectedItemBuilder: (context) {
                                return controller.goalTypes.map((category) {
                                  return Row(
                                    children: [
                                      Text(
                                        getEmoji(category),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const Gap(10),
                                      CustomTextWidget(
                                        text: category,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppColors.primary,
                                      ),
                                    ],
                                  );
                                }).toList();
                              },
                              items: controller.goalTypes.map((category) {
                                final isLocked = controller.isCategoryLocked(
                                  category,
                                );
                                final isSelected = selectedType == category;
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withValues(
                                              alpha: 0.1,
                                            )
                                          : (isLocked ? AppColors.grey3 : null),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          getEmoji(category),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const Gap(10),
                                        Expanded(
                                          child: CustomTextWidget(
                                            text: category,
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                            textColor: isLocked
                                                ? AppColors.grey
                                                : (isSelected
                                                      ? AppColors.primary
                                                      : AppColors.black),
                                          ),
                                        ),
                                        if (isLocked)
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: AppColors.grey.withValues(
                                                alpha: 0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                              Icons.lock_rounded,
                                              size: 14,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        if (isSelected && !isLocked)
                                          const Icon(
                                            Icons.check_circle,
                                            size: 18,
                                            color: AppColors.primary,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }),
                      const Gap(24),

                      // Goal Title Section - Modern Chip Selector
                      CustomTextWidget(
                        text: 'Goal Title',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      const Gap(12),
                      Obx(() {
                        // Access observables at top level so GetX can track them
                        final isLoading = controller.isLoadingNeeds.value;
                        final needs = controller.needsList.toList();
                        final selectedLabel =
                            controller.selectedNeedLabel.value;

                        if (isLoading) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.grey3,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: CustomProgressIndicator(),
                            ),
                          );
                        }

                        if (needs.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.grey3,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: CustomTextWidget(
                                text: 'No needs available for this category',
                                fontSize: 14,
                                textColor: AppColors.grey,
                              ),
                            ),
                          );
                        }

                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: needs.map((need) {
                            final isSelected = selectedLabel == need.needLabel;
                            return GestureDetector(
                              onTap: () => controller.selectNeed(need),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? LinearGradient(
                                          colors: [
                                            AppColors.vibrantBlue,
                                            AppColors.primary,
                                          ],
                                        )
                                      : null,
                                  color: isSelected ? null : AppColors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.inputBorderGrey,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.25,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isSelected) ...[
                                      const Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: AppColors.white,
                                      ),
                                      const Gap(6),
                                    ],
                                    Flexible(
                                      child: CustomTextWidget(
                                        text: need.needLabel,
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        textColor: isSelected
                                            ? AppColors.white
                                            : AppColors.black,
                                        maxLines: null,
                                        textOverflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                      const Gap(24),

                      // Date Selection Section
                      Row(
                        children: [
                          DatePickerWidget(
                            label: 'Start Date',
                            dateValue: controller.startDate,
                            onTap: () => controller.selectStartDate(context),
                          ),
                          const Gap(16),
                          DatePickerWidget(
                            label: 'End Date',
                            dateValue: controller.endDate,
                            onTap: () => controller.selectEndDate(context),
                          ),
                        ],
                      ),
                      const Gap(24),

                      // Description Section
                      CustomTextWidget(
                        text: 'Description',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      const Gap(8),
                      Container(
                        width: double.infinity,
                        height: 120,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.inputBorderGrey,
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            TextField(
                              controller: controller.descriptionController,
                              maxLength: controller.maxCharacters,
                              maxLines: null,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: const InputDecoration(
                                hintText: 'Description...',
                                hintStyle: TextStyle(
                                  color: AppColors.placeholderGrey,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.black,
                                height: 1.5,
                              ),
                            ),
                            // Character counter
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Obx(
                                () => CustomTextWidget(
                                  text:
                                      '${controller.characterCount.value}/${controller.maxCharacters}',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.mediumGray,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),
                      Obx(
                        () => CustomElevatedButton(
                          text: 'Save Goal',
                          backgroundColor: AppColors.blue,
                          textColor: AppColors.white,
                          onPress: controller.saveGoal,
                          width: double.infinity,
                          isLoading: controller.isSaving.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Save Goal Button
            ],
          ),
        ),
      ),
    );
  }
}
