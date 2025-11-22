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

                      // Goal Title Section
                      CustomTextWidget(
                        text: 'Goal Title',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      const Gap(8),
                      CustomInputTextField(
                        hintText: 'Enter title...',
                        textEditingController: controller.goalTitleController,
                        haveLabelText: false,
                        labelText: null,
                        isValidator: false,
                        borderRadius: 12,
                      ),
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

                      // Select Goal Type Section
                      CustomTextWidget(
                        text: 'Select Goal Type',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      const Gap(16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.5,
                            ),
                        itemCount: controller.goalTypes.length,
                        itemBuilder: (context, index) {
                          final goalType = controller.goalTypes[index];
                          return Obx(() {
                            final isSelected =
                                controller.selectedGoalType.value == goalType;
                            return GestureDetector(
                              onTap: () => controller.selectGoalType(goalType),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.lightBlue.withOpacity(0.2)
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.blue
                                        : AppColors.inputBorderGrey,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomTextWidget(
                                      text: goalType,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppColors.black,
                                      textAlign: TextAlign.left,
                                    ),
                                    CustomRadioButton(isSelected: isSelected),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                      ),
                      const Gap(32),
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
