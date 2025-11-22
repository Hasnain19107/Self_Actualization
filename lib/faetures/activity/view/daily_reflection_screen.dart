import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../binding/daily_reflection_binding.dart';
import '../controller/daily_reflection_controller.dart';
import '../widgets/add_reflection_button_widget.dart';
import '../widgets/reflection_card_widget.dart';
import '../../../core/const/app_exports.dart';

class DailyReflectionScreen extends StatelessWidget {
  DailyReflectionScreen({super.key});

  final AppSizes appSizes = AppSizes();

  @override
  Widget build(BuildContext context) {
    DailyReflectionBinding().dependencies();
    final controller = Get.find<DailyReflectionController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.getWidthPercentage(3),
            vertical: appSizes.getHeightPercentage(2),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button and title

                // Back button
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
                Gap(20),
                CustomTextWidget(
                  text: 'Daily Reflection & Journaling',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.black,
                  textAlign: TextAlign.center,
                ),
                const Gap(32),
                // Spacer to center the title

                // Mood Section
                CustomTextWidget(
                  text: 'Mood',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.black,
                  textAlign: TextAlign.left,
                ),
                const Gap(16),
                // Mood emojis row - only show last 7 days, one per day
                Obx(
                  () {
                    final moodsWithReflections = controller.moodsWithReflections;
                    
                    if (moodsWithReflections.isEmpty) {
                      return Center(
                        child: CustomTextWidget(
                          text: 'No moods recorded yet',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.mediumGray,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    // Show in a row (max 7 days)
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: moodsWithReflections.map((mood) {
                        return MoodEmojiWidget(
                          day: mood['day'] as String? ?? '',
                          imagePath: mood['imagePath'] as String?,
                        );
                      }).toList(),
                    );
                  },
                ),
                const Gap(32),

                // Add New Reflection Button
                AddReflectionButtonWidget(onTap: controller.addNewReflection),
                const Gap(32),

                // Reflection History Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: 'Reflection History',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.black,
                      textAlign: TextAlign.left,
                    ),
                    GestureDetector(
                      onTap: controller.viewReflectionHistory,
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const Gap(16),

                // Reflection Cards List
                Obx(
                  () {
                    if (controller.isLoadingReflections.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (controller.reflections.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CustomTextWidget(
                            text: 'No reflections yet. Add your first reflection!',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            textColor: AppColors.mediumGray,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    // Show only last 7 days reflections (one per day)
                    final last7Days = controller.last7DaysReflections;
                    
                    return Column(
                      children: last7Days.map((reflection) {
                        return ReflectionCardWidget(
                          text: reflection['text'] as String,
                          date: reflection['date'] as String,
                        );
                      }).toList(),
                    );
                  },
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
