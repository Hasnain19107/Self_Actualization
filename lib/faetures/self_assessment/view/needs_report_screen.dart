import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pixsa_petrol_pump/core/widgets/custom_back_button.dart';
import '../../../core/const/app_exports.dart';
import '../controller/needs_report_controller.dart';
import '../../../data/models/question/needs_report_model.dart';

class NeedsReportScreen extends StatelessWidget {
  const NeedsReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppSizes appSizes = AppSizes();
    final controller = Get.put(NeedsReportController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: appSizes.getWidthPercentage(3),
              vertical: appSizes.getHeightPercentage(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                   CustomBackButton(),
                    const Gap(12),
                    CustomTextWidget(
                      text: 'Needs Report',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.black,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const Gap(24),

                // Loading or Content
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CustomProgressIndicator(),
                    );
                  }

                  if (controller.needScores.isEmpty) {
                    return Center(
                      child: CustomTextWidget(
                        text: 'No needs data available',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.grey,
                      ),
                    );
                  }

                  // Group needs by category
                  final Map<String, List<NeedScore>> needsByCategory = {};
                  for (final need in controller.needScores) {
                    if (!needsByCategory.containsKey(need.category)) {
                      needsByCategory[need.category] = [];
                    }
                    needsByCategory[need.category]!.add(need);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Center(
                        child: Column(
                          children: [
                            CustomTextWidget(
                              text: 'Self-Actualization Assessment Report',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              textColor: AppColors.black,
                              textAlign: TextAlign.center,
                            ),
                            const Gap(4),
                            CustomTextWidget(
                              text: '©The Coaching Centre',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: AppColors.black,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),

                      // Need-level sliders grouped by category
                      ...needsByCategory.entries.map((entry) {
                        final category = entry.key;
                        final needs = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category header
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CustomTextWidget(
                                text: category,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.primary,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            // Need sliders
                            ...needs.map((need) => _buildNeedSlider(need, controller)),
                            const Gap(24),
                          ],
                        );
                      }).toList(),

                      // Suggested Prompt
                      if (controller.needsReport.value?.suggestedPrompt != null &&
                          controller.needsReport.value!.suggestedPrompt!.isNotEmpty) ...[
                        const Gap(24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: CustomTextWidget(
                            text: controller.needsReport.value!.suggestedPrompt!,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.primary,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],

                      // Recommendations section (show recommendations, or recommendedActions if recommendations is empty)
                      if (controller.needsReport.value != null) ...[
                        Builder(
                          builder: (context) {
                            final recommendationsToShow = controller.needsReport.value!.recommendations.isNotEmpty
                                ? controller.needsReport.value!.recommendations
                                : controller.needsReport.value!.recommendedActions;
                            
                            if (recommendationsToShow.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(24),
                                CustomTextWidget(
                                  text: 'Recommendations',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  textColor: AppColors.black,
                                  textAlign: TextAlign.left,
                                ),
                                const Gap(12),
                                ...recommendationsToShow.map(
                                  (recommendation) => _buildRecommendationCard(recommendation, controller),
                                ),
                              ],
                            );
                          },
                        ),
                      ],

                      // Lowest needs section
                      if (controller.lowestNeeds.isNotEmpty) ...[
                        const Gap(24),
                        CustomTextWidget(
                          text: 'Areas for Growth',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          textColor: AppColors.black,
                          textAlign: TextAlign.left,
                        ),
                        const Gap(12),
                        ...controller.lowestNeeds.map((need) => _buildNeedCard(need, controller)),
                      ],
                    ],
                  );
                }),
                const Gap(12),
                CustomElevatedButton(
                  text: 'continue',
                  backgroundColor: AppColors.blue,
                  textColor: AppColors.white,
                  onPress: () {
                    Get.to(MainNavScreen(initialIndex: 0));
                  },
                ),
                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeedSlider(NeedScore need, NeedsReportController controller) {
    final score = need.score;
    final color = controller.getColorForScore(score);
    final label = controller.getPerformanceLabel(score);
    final widthFactor = (score / 7.0).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkwhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextWidget(
                  text: need.needLabel,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.black,
                  textAlign: TextAlign.left,
                ),
              ),
              CustomTextWidget(
                text: '${score.toStringAsFixed(1)}/7',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: color,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          const Gap(8),
          // Progress bar
          Container(
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  Container(color: AppColors.white),
                  FractionallySizedBox(
                    widthFactor: widthFactor == 0 ? 0.001 : widthFactor,
                    alignment: Alignment.centerLeft,
                    child: Container(color: color),
                  ),
                ],
              ),
            ),
          ),
          const Gap(4),
          CustomTextWidget(
            text: label,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            textColor: color,
            textAlign: TextAlign.left,
          ),
          // Learn and Grow button
          if (need.questionId != null && need.questionId!.isNotEmpty) ...[
            const Gap(12),
            GestureDetector(
              onTap: () {
                Get.toNamed(
                  AppRoutes.learnGrowScreen,
                  arguments: {'questionId': need.questionId},
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      text: 'Learn and Grow',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.primary,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNeedCard(NeedScore need, NeedsReportController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: need.needLabel,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.black,
                  textAlign: TextAlign.left,
                ),
                const Gap(4),
                CustomTextWidget(
                  text: 'Score: ${need.score.toStringAsFixed(1)}/7',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.grey,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          if (need.questionId != null && need.questionId!.isNotEmpty)
            GestureDetector(
              onTap: () {
                // Navigate to learn & grow for this need with questionId
                Get.toNamed(
                  AppRoutes.learnGrowScreen,
                  arguments: {'questionId': need.questionId},
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      text: 'Learn and Grow',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.white,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    const Icon(
                      Icons.arrow_forward,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(Recommendation recommendation, NeedsReportController controller) {
    // Determine button text and icon based on type
    String buttonText;
    IconData buttonIcon;
    Color buttonColor;
    
    switch (recommendation.type) {
      case 'learn':
        buttonText = 'Learn and Grow';
        buttonIcon = Icons.school;
        buttonColor = AppColors.primary;
        break;
      case 'goal':
        buttonText = 'Set a Goal';
        buttonIcon = Icons.flag;
        buttonColor = AppColors.blue;
        break;
      case 'coach':
        buttonText = 'Ask to Coach';
        buttonIcon = Icons.email;
        buttonColor = AppColors.orange;
        break;
      default:
        buttonText = 'Take Action';
        buttonIcon = Icons.arrow_forward;
        buttonColor = AppColors.primary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkwhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: buttonColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message
          CustomTextWidget(
            text: recommendation.message,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: AppColors.black,
            textAlign: TextAlign.left,
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          ),
          const Gap(12),
          // Action button
          GestureDetector(
            onTap: () => controller.handleRecommendationAction(recommendation),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    buttonIcon,
                    color: AppColors.white,
                    size: 18,
                  ),
                  const Gap(8),
                  CustomTextWidget(
                    text: buttonText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.white,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

