import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/Const/app_colors.dart';
import '../../../core/utils/app_sizes.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/custom_input_textfield.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../controllers/onboarding_controller.dart';

class ProfileSetupScreen extends StatelessWidget {
  ProfileSetupScreen({super.key});

  final AppSizes appSizes = AppSizes();
  final controller = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.getWidthPercentage(4),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(Get.height * 0.04),
                      // Title
                      CustomTextWidget(
                        text: 'Profile Setup',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      Gap(32),
                      // Full Name Section
                      CustomTextWidget(
                        text: 'Full Name',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      Gap(8),
                      CustomInputTextField(
                        hintText: 'Enter your Full Name',
                        textEditingController: controller.fullNameController,
                        haveLabelText: false,
                        labelText: null,
                        isValidator: false,
                        borderRadius: 12,
                      ),
                      Gap(24),
                      // Age Section
                      CustomTextWidget(
                        text: 'Age',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      Gap(8),
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.inputBorderGrey,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextWidget(
                                text: '${controller.age.value}',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textColor: AppColors.black,
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: controller.decrementAge,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.black,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  IconButton(
                                    onPressed: controller.incrementAge,
                                    icon: const Icon(
                                      Icons.arrow_drop_up,
                                      color: AppColors.black,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(24),
                      // Select Focus Areas Section
                      CustomTextWidget(
                        text: 'Select Focus Areas',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      Gap(16),
                      Obx(
                        () => Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: controller.focusAreas.map((focusArea) {
                            final isSelected = controller.isFocusAreaSelected(
                              focusArea,
                            );
                            return GestureDetector(
                              onTap: () =>
                                  controller.toggleFocusArea(focusArea),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.blue
                                        : AppColors.inputBorderGrey,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomTextWidget(
                                      text: focusArea,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppColors.black,
                                      textAlign: TextAlign.left,
                                    ),
                                    Gap(8),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.blue
                                              : AppColors.inputBorderGrey,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? AppColors.blue
                                            : AppColors.white,
                                      ),
                                      child: isSelected
                                          ? const Center(
                                              child: Icon(
                                                Icons.circle,
                                                size: 10,
                                                color: AppColors.white,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Gap(16),
                      // Selected Focus Areas Display
                      Obx(
                        () => controller.selectedFocusAreas.isNotEmpty
                            ? Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  CustomTextWidget(
                                    text: 'Selected:',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppColors.black,
                                    textAlign: TextAlign.left,
                                  ),
                                  ...controller.selectedFocusAreas.map((
                                    focusArea,
                                  ) {
                                    return Container(
                                      width: 105,
                                      height: 37,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightGray,
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: CustomTextWidget(
                                              text: focusArea,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppColors.black,
                                              textAlign: TextAlign.center,
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Gap(4),
                                          GestureDetector(
                                            onTap: () => controller
                                                .removeFocusArea(focusArea),
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                      Gap(24),
                      // Select Avatar Section
                      CustomTextWidget(
                        text: 'Select Avatar',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      Gap(16),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: controller.avatarOptions.asMap().entries.map((
                            entry,
                          ) {
                            final index = entry.key;
                            final avatar = entry.value;
                            final isSelected = controller.isAvatarSelected(
                              avatar,
                            );
                            return GestureDetector(
                              onTap: () => controller.selectAvatar(avatar),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.blue
                                        : AppColors.inputBorderGrey,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: AppColors.lightGray,
                                    child: Center(
                                      child: CustomTextWidget(
                                        text: '${index + 1}',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppColors.black,
                                      ),
                                    ),
                                    // Replace with actual image when available:
                                    // Image.asset(
                                    //   'assets/images/avatars/$avatar.png',
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Gap(32),
                    ],
                  ),
                ),
              ),
              // Finish Setup Button
              Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.02),
                child: CustomElevatedButton(
                  text: 'Finish Setup',
                  backgroundColor: AppColors.blue,
                  textColor: AppColors.white,
                  onPress: controller.submitProfileSetup,
                  width: double.infinity,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
