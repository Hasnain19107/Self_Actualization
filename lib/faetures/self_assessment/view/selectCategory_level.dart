
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/const/app_exports.dart';
import '../controller/self_assessment_controller.dart';

class SelectCategoryLevelScreen extends StatelessWidget {
  SelectCategoryLevelScreen({super.key});

  final AppSizes appSizes = AppSizes();
  final controller = Get.put(SelfAssessmentController());

  @override
  Widget build(BuildContext context) {
    // Initialize category level screen and fetch categories
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeCategoryLevelScreen();
    });
    
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
                      // Categories Section Heading
                      CustomTextWidget(
                        text: 'Categories',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.black,
                      ),
                      Gap(16),
                      // Categories List (expandable cards)
                      Obx(() {
                        if (controller.isLoadingCategories.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: CustomProgressIndicator(),
                            ),
                          );
                        }

                        final categories = controller.availableCategories;
                        if (categories.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: CustomTextWidget(
                                text: 'No categories available',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textColor: AppColors.grey,
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: categories.map((category) {
                            final isSelected = controller.isCategorySelected(category);
                            
                            // Get emoji for category
                            String categoryEmoji = '📋';
                            if (category == 'Self') categoryEmoji = '✏️';
                            else if (category == 'Social') categoryEmoji = '💬';
                            else if (category == 'Safety') categoryEmoji = '💪';
                            else if (category == 'Survival') categoryEmoji = '😊';
                            
                            return GestureDetector(
                              onTap: () => controller.toggleCategory(category),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlue,
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
                                        categoryEmoji,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Gap(12),
                                    Expanded(
                                      child: CustomTextWidget(
                                        text: category,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppColors.black,
                                      ),
                                    ),
                                    Gap(12),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.blue,
                                        size: 24,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),

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
