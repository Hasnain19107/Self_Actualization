import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../../../core/const/app_exports.dart';

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
                                    CustomRadioButton(isSelected: isSelected),
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
                          children: controller.avatarOptions.map((avatar) {
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
                                  child: _getAvatarImage(avatar),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Gap(32),
                      CustomElevatedButton(
                        text: 'Finish Setup',
                        backgroundColor: AppColors.blue,
                        textColor: AppColors.white,
                        onPress: controller.submitProfileSetup,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),

              // Finish Setup Button
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAvatarImage(String avatar) {
    String imagePath;
    switch (avatar) {
      case 'avatar1':
        imagePath = AppImages.avatar1;
        break;
      case 'avatar2':
        imagePath = AppImages.avatar2;
        break;
      case 'avatar3':
        imagePath = AppImages.avatar3;
        break;
      case 'avatar4':
        imagePath = AppImages.avatar4;
        break;
      case 'avatar5':
        imagePath = AppImages.avatar5;
        break;
      default:
        imagePath = AppImages.avatar1; // Default fallback
    }

    return Image.asset(
      imagePath,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.lightGray,
          child: Center(
            child: CustomTextWidget(
              text: avatar.replaceAll('avatar', ''),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              textColor: AppColors.black,
            ),
          ),
        );
      },
    );
  }
}
