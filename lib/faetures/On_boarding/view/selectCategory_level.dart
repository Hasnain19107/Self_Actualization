import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../../../core/const/app_exports.dart';

class SelectCategoryLevelScreen extends StatelessWidget {
  SelectCategoryLevelScreen({super.key});

  final AppSizes appSizes = AppSizes();
  final controller = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    // Initialize plan from arguments
    controller.initializeCategoryLevelScreen();
    
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gap(Get.height * 0.04),
                      // Title
                      CustomTextWidget(
                        text: 'Select Level and Category',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black,
                        textAlign: TextAlign.center,
                      ),
                      Gap(12),
                      // Description
                      CustomTextWidget(
                        text:
                            'Voluptatem et impedit voluptatem\n architecto pariatur ea nobis delectus.',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: AppColors.mediumGray,
                      ),
                      Gap(32),
                      // Meta Needs Section Heading
                      CustomTextWidget(
                        text: 'Categories',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                      ),
                      Gap(16),
                      // Meta Needs Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.inputBorderGrey,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Meta Needs Header
                            Row(
                              children: [
                                const Text(
                                  '🧘',
                                  style: TextStyle(fontSize: 24),
                                ),
                                Gap(8),
                                CustomTextWidget(
                                  text: 'Meta Needs',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.black,
                                ),
                              ],
                            ),
                            Gap(16),
                            // Meta Needs Options
                            Obx(
                              () => Column(
                                children: controller.metaNeedsOptions
                                    .map(
                                      (option) {
                                        final isLocked = controller.isMetaNeedLocked(option);
                                        return GestureDetector(
                                          onTap: () =>
                                              controller.toggleMetaNeed(option),
                                          child: Opacity(
                                            opacity: isLocked ? 0.5 : 1.0,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 12,
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 14,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    controller.isMetaNeedSelected(
                                                      option,
                                                    )
                                                    ? AppColors.white
                                                    : AppColors.white,
                                                borderRadius: BorderRadius.circular(
                                                  8,
                                                ),
                                                border: Border.all(
                                                  color:
                                                      controller.isMetaNeedSelected(
                                                        option,
                                                      )
                                                      ? AppColors.blue
                                                      : AppColors.inputBorderGrey,
                                                  width:
                                                      controller.isMetaNeedSelected(
                                                        option,
                                                      )
                                                      ? 2
                                                      : 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      option,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: isLocked 
                                                            ? AppColors.grey 
                                                            : AppColors.black,
                                                        fontFamily: 'Poppins',
                                                        height: 1.4,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Gap(12),
                                                  isLocked
                                                      ? Icon(
                                                          Icons.lock,
                                                          size: 20,
                                                          color: AppColors.grey,
                                                        )
                                                      : Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  controller
                                                                      .isMetaNeedSelected(
                                                                        option,
                                                                      )
                                                                  ? AppColors.blue
                                                                  : AppColors
                                                                        .inputBorderGrey,
                                                              width: 2,
                                                            ),
                                                            color:
                                                                controller
                                                                    .isMetaNeedSelected(
                                                                      option,
                                                                    )
                                                                ? AppColors.blue
                                                                : AppColors.white,
                                                          ),
                                                          child:
                                                              controller
                                                                  .isMetaNeedSelected(
                                                                    option,
                                                                  )
                                                              ? const Center(
                                                                  child: Icon(
                                                                    Icons.circle,
                                                                    size: 10,
                                                                    color:
                                                                        AppColors.white,
                                                                  ),
                                                                )
                                                              : null,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Levels Section - Only show when Meta Needs are selected
                      Obx(
                        () => controller.selectedMetaNeeds.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(24),
                                  // Levels Section Heading
                                  CustomTextWidget(
                                    text: 'Levels',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppColors.black,
                                  ),
                                  Gap(16),
                                  Column(
                                    children: controller.levels.map((level) {
                                      final isSelected = controller.isLevelSelected(level['name']!);
                                      final isLocked = controller.isLevelLocked(level['name']!);
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        child: GestureDetector(
                                          onTap: () => controller.toggleLevel(level['name']!),
                                          child: Opacity(
                                            opacity: isLocked ? 0.5 : 1.0,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 14,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? AppColors.blue
                                                    : AppColors.lightBlue,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? AppColors.blue
                                                      : AppColors.inputBorderGrey,
                                                  width: isSelected ? 2 : 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(8),
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      level['emoji']!,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Gap(12),
                                                  Expanded(
                                                    child: CustomTextWidget(
                                                      text: level['name']!,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      textColor: isSelected
                                                          ? AppColors.white
                                                          : (isLocked ? AppColors.grey : AppColors.black),
                                                    ),
                                                  ),
                                                  Gap(12),
                                                  isLocked
                                                      ? Icon(
                                                          Icons.lock,
                                                          size: 20,
                                                          color: AppColors.grey,
                                                        )
                                                      : isSelected
                                                          ? Icon(
                                                              Icons.check_circle,
                                                              size: 20,
                                                              color: AppColors.white,
                                                            )
                                                          : const SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                      Gap(32),
                      Gap(24),
                      // Get Started Button
                      Center(
                        child: CustomElevatedButton(
                          text: 'Get Started',
                          backgroundColor: AppColors.blue,
                          textColor: AppColors.white,
                          onPress: controller.handleGetStarted,
                          hasRightIcon: true,
                          iconColor: AppColors.white,
                          iconData: Icons.arrow_forward,
                          iconSize: 20,
                        ),
                      ),
                    ],
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
