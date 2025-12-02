import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AchievementBinding().dependencies();
    final controller = Get.find<AchievementController>();
    final AppSizes appSizes = AppSizes();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.getWidthPercentage(3),
            vertical: appSizes.getHeightPercentage(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              AppHeaderWidget(),
              CustomTextWidget(
                text: 'Achievements',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: AppColors.black,
              ),
              const Gap(24),

              // Achievement Progress Card
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CustomProgressIndicator(),
                    ),
                  );
                }
                return const AchievementProgressCardWidget();
              }),
              const Gap(24),

              // Achievement Cards Grid
              Expanded(
                child: Obx(
                  () {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CustomProgressIndicator(),
                      );
                    }
                    final achievements = controller.achievements;
                    if (achievements.isEmpty) {
                      return Center(
                        child: CustomTextWidget(
                          text: 'No achievements available',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.grey,
                        ),
                      );
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                      itemCount: achievements.length,
                      itemBuilder: (context, index) {
                        final achievement = achievements[index];
                        return AchievementCardWidget(
                          imagePath: achievement['imagePath'] as String?,
                          title: achievement['title'] as String,
                          subtitle: achievement['subtitle'] as String,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
