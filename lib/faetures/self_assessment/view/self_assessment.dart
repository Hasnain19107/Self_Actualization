import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controller/self_assessment_controller.dart';
import '../../../core/const/app_exports.dart';

class SelfAssessmentScreen extends StatelessWidget {
  SelfAssessmentScreen({super.key});

  final AppSizes appSizes = AppSizes();

  @override
  Widget build(BuildContext context) {
    // Get or create controller
    final controller = Get.put(SelfAssessmentController());
    
    // Initialize and fetch questions when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeForAssessment();
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
                          child: CustomProgressIndicator(),
                        )
                      : controller.regularQuestions.isEmpty
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
                                    () {
                                      final questionText = controller.currentQuestionText;
                                      final textWithQuestionMark = questionText.trim().endsWith('?')
                                          ? questionText
                                          : '$questionText?';
                                      return CustomTextWidget(
                                        text: textWithQuestionMark,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        textColor: AppColors.black,
                                        textAlign: TextAlign.left,
                                        limitedCharacters: false,
                                        textOverflow: TextOverflow.clip,
                                        maxLines: null,
                                      );
                                    },
                                  ),
                      Gap(Get.height * 0.02),
                      // Rating Legend
                      Obx(() {
                        final questionType = controller.currentQuestionType.value;
                        
                        if (questionType == 'regular') {
                          // Regular question - show dynamic rating descriptions
                          return Column(
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
                              Gap(Get.height * 0.02),
                            ],
                          );
                        } else if (questionType == 'quality' || questionType == 'volume') {
                          // Quality or Volume question - show hard-coded rating instructions
                          final ratingInstructions = [
                            "1 - Not at all true",
                            "2 - Rarely true",
                            "3 - Sometimes true",
                            "4 - Often true",
                            "5 - Usually true",
                            "6 - Almost always true",
                            "7 - Completely true"
                          ];
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...ratingInstructions.map(
                                (instruction) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: CustomTextWidget(
                                          text: instruction,
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
                              Gap(Get.height * 0.02),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      Gap(Get.height * 0.02),
                      // Show different UI based on question type
                      Obx(() {
                        final questionType = controller.currentQuestionType.value;
                        
                        if (questionType == 'regular') {
                          // Regular question - show 1-7 scale
                          return Column(
                            children: [
                              // Large Rating Display with Animation
                              Center(
                                child: AnimatedSwitcher(
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
                              Gap(Get.height * 0.02),
                              // Draggable Rating Line (Numbers 1-7)
                              GestureDetector(
                                onHorizontalDragStart: (_) {
                                  controller.isDragging.value = true;
                                },
                                onHorizontalDragUpdate: (details) {
                                  final RenderBox box = context.findRenderObject() as RenderBox;
                                  final localPosition = box.globalToLocal(details.globalPosition);
                                  final containerWidth = box.size.width - (appSizes.getWidthPercentage(3) * 2);
                                  final padding = appSizes.getWidthPercentage(3);
                                  final availableWidth = containerWidth - (padding * 2) - 32;
                                  
                                  final dragX = localPosition.dx - padding - 16;
                                  final normalizedX = dragX.clamp(0.0, availableWidth);
                                  final segmentWidth = availableWidth / 6;
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
                                      final isSelected = controller.selectedRating.value == rating;
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
                              ),
                            ],
                          );
                        } else {
                          // Quality or Volume question - show slider
                          return _buildSliderQuestion(context, controller, questionType);
                        }
                      }),
                      Gap(12),
                      Obx(
                        () {
                          final isLastRegular = controller.currentRegularQuestionIndex.value >=
                              controller.totalRegularQuestions - 1;
                          final isLastStep = isLastRegular && 
                              controller.currentQuestionType.value == 'volume';
                          final buttonText = isLastStep ? 'Finish' : 'Continue';
                          
                          return CustomElevatedButton(
                            text: buttonText,
                            backgroundColor: AppColors.blue,
                            textColor: AppColors.white,
                            isLoading: controller.isSubmitting.value,
                            onPress: () {
                              controller.nextQuestion();
                            },
                            hasRightIcon: !isLastStep && !controller.isSubmitting.value,
                            iconColor: AppColors.white,
                            iconData: Icons.arrow_forward,
                            iconSize: 20,
                          );
                        },
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

  Widget _buildSliderQuestion(BuildContext context, SelfAssessmentController controller, String questionType) {
    return Column(
      children: [
        // Current value display
        Center(
          child: Obx(
            () => CustomTextWidget(
              text: controller.selectedRating.value.toString(),
              fontSize: 50,
              fontWeight: FontWeight.w700,
              textColor: AppColors.primary,
            ),
          ),
        ),
        Gap(Get.height * 0.02),
        // Custom Slider matching needs_slider_widget design
        Obx(
          () => _buildCustomSlider(
            context: context,
            value: controller.selectedRating.value.toDouble(),
            min: 1,
            max: 7,
            onChanged: (value) {
              controller.selectRating(value.round());
            },
            questionType: questionType,
          ),
        ),
        Gap(Get.height * 0.01),
        // Min and Max labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              text: '1',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: AppColors.grey,
            ),
            CustomTextWidget(
              text: questionType == 'quality' ? 'Quality' : 'Volume',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textColor: AppColors.primary,
            ),
            CustomTextWidget(
              text: '7',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: AppColors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomSlider({
    required BuildContext context,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required String questionType,
  }) {
    final normalizedValue = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final thumbSize = 24.0;
    final trackHeight = 16.0;

    // Calculate colors based on value (1-7 scale)
    Color getTrackColor() {
      if (value < 2.1) {
        // Less than 30% of 7 (2.1) - more red
        return AppColors.red;
      } else if (value < 3.5) {
        // Below half of 7 (3.5) - light red
        return AppColors.red.withOpacity(0.5);
      } else {
        // Above half (3.5) - blue
        return AppColors.primary;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final trackWidth = availableWidth;
        
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final RenderBox? box = context.findRenderObject() as RenderBox?;
            if (box == null) return;
            
            final localPosition = box.globalToLocal(details.globalPosition);
            final dragX = localPosition.dx.clamp(0.0, trackWidth);
            final normalizedX = dragX / trackWidth;
            final newValue = min + normalizedX * (max - min);
            onChanged(newValue.clamp(min, max));
          },
          onTapDown: (details) {
            final RenderBox? box = context.findRenderObject() as RenderBox?;
            if (box == null) return;
            
            final localPosition = box.globalToLocal(details.localPosition);
            final tapX = localPosition.dx.clamp(0.0, trackWidth);
            final normalizedX = tapX / trackWidth;
            final newValue = min + normalizedX * (max - min);
            onChanged(newValue.clamp(min, max));
          },
          child: Container(
            width: trackWidth,
            height: trackHeight + thumbSize + 20,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Track background
                Positioned(
                  top: thumbSize / 2 - trackHeight / 2,
                  left: 0,
                  width: trackWidth,
                  child: Container(
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        // Filled portion - color changes based on value
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: normalizedValue * trackWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: getTrackColor(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Thumb
                Positioned(
                  left: (normalizedValue * trackWidth - thumbSize / 2).clamp(0.0, trackWidth - thumbSize),
                  top: 0,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // Label below thumb
                Positioned(
                  left: (normalizedValue * trackWidth - 10).clamp(0.0, trackWidth - 20),
                  top: thumbSize + 4,
                  child: CustomTextWidget(
                    text: questionType == 'quality' ? 'Q' : 'V',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.black,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
