import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/achievement_controller.dart';
import '../../../core/const/app_exports.dart';

class AchievementProgressCardWidget extends StatelessWidget {
  const AchievementProgressCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AchievementController>();

    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0x33F3F2F1), // #F3F2F133 with 20% opacity
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(2.03, 2.03),
              blurRadius: 15.23,
              spreadRadius: 0,
              color: const Color(0x80A6ABBD), // #A6ABBD80
            ),
            BoxShadow(
              offset: const Offset(-1.02, -1.02),
              blurRadius: 13.2,
              spreadRadius: 0,
              color: const Color(0xFFFAFBFF), // #FAFBFF
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge and title row
            Row(
              children: [
                // Current level badge (dark with light yellow number)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF424242), // Dark grey
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomTextWidget(
                      text: '${controller.currentLevel.value}',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textColor: const Color(0xFFFFEB3B), // Light yellow
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: controller.currentBadge.value,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 4),
                      CustomTextWidget(
                        text:
                            '${controller.pointsToNext.value} Points to next achievemnt',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Progress bar with range-based approach
            Row(children: [_buildProgressBar(controller)]),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(AchievementController controller) {
    // Define range values
    final minValue = 0.0;
    final maxValue = controller.totalPoints.value.toDouble();
    final currentValue = controller.currentPoints.value.toDouble();

    // Calculate progress percentage within range
    final progressValue = (currentValue - minValue) / (maxValue - minValue);
    final clampedProgress = progressValue.clamp(0.0, 1.0);

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background track (unfilled portion)
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3B14E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              // Progress fill (filled portion) - clipped to range
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: clampedProgress,
                  child: Container(
                    height: 40,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFF3B14E), // #F3B14E
                          Color(0xFFFFCE51), // #FFCE51
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              // Overlay content (badges and text)
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Current level badge (on filled portion)
                    _buildLevelBadge(controller.currentLevel.value),
                    // Points text
                    CustomTextWidget(
                      text:
                          '${controller.currentPoints.value}/${controller.totalPoints.value}',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.black,
                      textAlign: TextAlign.center,
                    ),
                    // Next level badge (on unfilled portion)
                    _buildLevelBadge(controller.nextLevel.value),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLevelBadge(int level) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFF3B14E), // #F3B14E
            Color(0xFFFFCE51), // #FFCE51
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomTextWidget(
          text: '$level',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          textColor: AppColors.black,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
