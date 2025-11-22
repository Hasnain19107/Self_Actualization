import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controller/self_assessment_controller.dart';
import '../../../core/const/app_exports.dart';

class SelfAssessmentScreen extends StatelessWidget {
  SelfAssessmentScreen({super.key});

  final AppSizes appSizes = AppSizes();
  final controller = Get.find<SelfAssessmentController>();

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
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                   
                    // Title
                    CustomTextWidget(
                      text: 'Self Assessment',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.black,
                    ),
                    // Progress Indicator
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomTextWidget(
                          text: controller.progressText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.questions.isEmpty
                          ? Center(
                              child: CustomTextWidget(
                                text: 'No questions available',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.grey,
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(Get.height * 0.02),
                                  // Category label
                                  Obx(() {
                                    final category =
                                        controller.currentQuestionCategory;
                                    if (category.isEmpty) {
                                      return const SizedBox.shrink();
                                    }
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.blue.withOpacity(0.3),
                                        ),
                                      ),
                                      child: CustomTextWidget(
                                        text: category,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppColors.blue,
                                      ),
                                    );
                                  }),
                                  Gap(Get.height * 0.015),
                                  // Question
                                  Obx(
                                    () => CustomTextWidget(
                                      text: controller.currentQuestionText,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      textColor: AppColors.black,
                                      textAlign: TextAlign.left,
                                      limitedCharacters: false,
                                      textOverflow: TextOverflow.clip,
                                      maxLines: null,
                                    ),
                                  ),
                      Gap(Get.height * 0.02),
                      // Large Rating Display with Animation
                      Center(
                        child: Obx(
                          () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: CustomTextWidget(
                              key: ValueKey<int>(controller.selectedRating.value),
                              text: controller.selectedRating.value.toString(),
                              fontSize: 50,
                              fontWeight: FontWeight.w700,
                              textColor: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                      Gap(Get.height * 0.02),
                      // Draggable Rating Line (Numbers 1-7)
                      Obx(
                        () {
                          return GestureDetector(
                            onHorizontalDragStart: (_) {
                              controller.isDragging.value = true;
                            },
                            onHorizontalDragUpdate: (details) {
                              final RenderBox box = context.findRenderObject() as RenderBox;
                              final localPosition = box.globalToLocal(details.globalPosition);
                              final containerWidth = box.size.width - (appSizes.getWidthPercentage(3) * 2);
                              final padding = appSizes.getWidthPercentage(3);
                              final availableWidth = containerWidth - (padding * 2) - 32; // 32 for container padding
                              
                              // Calculate which number based on drag position
                              final dragX = localPosition.dx - padding - 16; // Adjust for padding
                              final normalizedX = dragX.clamp(0.0, availableWidth);
                              final segmentWidth = availableWidth / 6; // 6 segments between 7 numbers
                              final rating = ((normalizedX / segmentWidth) + 1).round().clamp(1, 7);
                              
                              if (controller.selectedRating.value != rating) {
                                controller.selectRating(rating);
                              }
                            },
                            onHorizontalDragEnd: (_) {
                              controller.isDragging.value = false;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(7, (index) {
                                  final rating = index + 1;
                                  final isSelected =
                                      controller.selectedRating.value == rating;
                                  final isDragging = controller.isDragging.value;
                                  final shouldScale = isSelected && isDragging;
                                  
                                  return GestureDetector(
                                    onTap: () => controller.selectRating(rating),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                      width: shouldScale ? 56 : 40,
                                      height: shouldScale ? 56 : 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? AppColors.blue
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.blue
                                              : AppColors.inputBorderGrey,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 200),
                                          style: TextStyle(
                                            fontSize: shouldScale ? 20 : 16,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? AppColors.white
                                                : AppColors.black,
                                          ),
                                          child: Text(rating.toString()),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          );
                        },
                      ),
                      Gap(Get.height * 0.02),
                      // Rating Legend
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...controller.ratingDescriptions.entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextWidget(
                                    text: '${entry.key}:',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    textColor: AppColors.blue,
                                  ),
                                  Gap(8),
                                  Expanded(
                                    child: CustomTextWidget(
                                      text: entry.value,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppColors.black,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(12),
                      Obx(
                        () => CustomElevatedButton(
                          text: controller.currentQuestionIndex.value <
                                  controller.totalQuestions - 1
                              ? 'Continue'
                              : 'Finish',
                          backgroundColor: AppColors.blue,
                          textColor: AppColors.white,
                          isLoading: controller.isSubmitting.value,
                          onPress: () {
                            controller.nextQuestion();
                          },
                          hasRightIcon: controller.currentQuestionIndex.value <
                                  controller.totalQuestions - 1 &&
                              !controller.isSubmitting.value,
                          iconColor: AppColors.white,
                          iconData: Icons.arrow_forward,
                          iconSize: 20,
                        ),
                      ),
                                ],
                              ),
                            ),
                ),
              ),

              // Continue Button
            ],
          ),
        ),
      ),
    );
  }
}
