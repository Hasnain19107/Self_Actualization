import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pixsa_petrol_pump/faetures/OnBoarding/view/self_Assessment.dart';
import '../../../core/Const/app_colors.dart';
import '../../../core/utils/app_sizes.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../controllers/onboarding_controller.dart';

class SelectCategoryLevelScreen extends StatelessWidget {
  SelectCategoryLevelScreen({super.key});

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
                      // Categories Section Heading
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
                                      (option) => GestureDetector(
                                        onTap: () =>
                                            controller.toggleMetaNeed(option),
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
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.black,
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
                                              Container(
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
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Gap(24),
                      // Other Categories
                      Obx(
                        () => Column(
                          children: controller.categories.map((category) {
                            final isSelected = controller.isCategorySelected(
                              category['name']!,
                            );
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => controller.selectCategory(
                                  category['name']!,
                                ),
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
                                      width: 1,
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
                                          category['emoji']!,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      Gap(12),
                                      CustomTextWidget(
                                        text: category['name']!,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        textColor: isSelected
                                            ? AppColors.white
                                            : AppColors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Gap(32),
                      Gap(24),
                      // Get Started Button
                      Center(
                        child: CustomElevatedButton(
                          text: 'Get Started',
                          backgroundColor: AppColors.blue,
                          textColor: AppColors.white,
                          onPress: () {
                            Get.to(SelfAssessmentScreen());
                            // Navigate to next screen if needed
                            // Get.toNamed(AppRoutes.HOMESCREEN);
                          },
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
