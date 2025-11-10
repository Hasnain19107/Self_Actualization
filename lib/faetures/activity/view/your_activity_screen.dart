import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../binding/your_activity_binding.dart';
import '../controller/your_activity_controller.dart';
import '../widgets/activity_card_widget.dart';
import '../../goal/widgets/goal_item_widget.dart';
import '../../../core/const/app_exports.dart';

class YourActivityScreen extends StatelessWidget {
  YourActivityScreen({super.key});

  final AppSizes appSizes = AppSizes();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    YourActivityBinding().dependencies();
    final controller = Get.find<YourActivityController>();

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
                // Header: Avatar, Title, Notification Bell
                AppHeaderWidget(
                  title: 'Your Activity',
                  onNotificationTap: () {
                    // Handle notification tap
                  },
                ),
                const Gap(12),
                SearchBarWidget(
                  searchController: searchController,
                  onChanged: (value) {
                    // Handle search input
                  },
                  onMicTap: () {
                    // Handle mic tap
                  },
                ),
                const Gap(24),

                // Date Picker
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.dates.length,
                    separatorBuilder: (context, index) => const Gap(8),
                    itemBuilder: (context, index) {
                      final date = controller.dates[index];
                      return Obx(() {
                        final isSelected =
                            controller.selectedDate.value == date;
                        return GestureDetector(
                          onTap: () => controller.selectDate(date),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.inputBorderGrey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.blue
                                    : Colors.transparent,
                                width: isSelected ? 1.5 : 0,
                              ),
                            ),
                            child: Center(
                              child: CustomTextWidget(
                                text: date,
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                textColor: isSelected
                                    ? AppColors.blue
                                    : AppColors.black,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                const Gap(24),

                // Activity Cards
                Row(
                  children: [
                    Expanded(
                      child: ActivityCardWidget(
                        icon1: controller.activityCardsData[0]['icon1'],
                        icon1Color:
                            controller.activityCardsData[0]['icon1Color'],
                        icon2: controller.activityCardsData[0]['icon2'],
                        icon2Color:
                            controller.activityCardsData[0]['icon2Color'],
                        title: controller.activityCardsData[0]['title'],
                        subtitle: controller.activityCardsData[0]['subtitle'],
                        backgroundColor: AppColors.lightBlue.withOpacity(0.5),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: ActivityCardWidget(
                        icon1: controller.activityCardsData[1]['icon1'],
                        icon1Color:
                            controller.activityCardsData[1]['icon1Color'],
                        icon2: controller.activityCardsData[1]['icon2'],
                        icon2Color:
                            controller.activityCardsData[1]['icon2Color'],
                        icon2BgColor:
                            controller.activityCardsData[1]['icon2BgColor'],
                        title: controller.activityCardsData[1]['title'],
                        subtitle: controller.activityCardsData[1]['subtitle'],
                        backgroundColor: AppColors.lightBlue.withOpacity(0.5),
                        onTap: () {
                          Get.toNamed(AppRoutes.dailyReflectionScreen);
                        },
                      ),
                    ),
                  ],
                ),
                const Gap(32),

                // Goals Tracker Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomTextWidget(
                      text: 'Goals Tracker',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.black,
                      textAlign: TextAlign.left,
                    ),
                    IconButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.goalScreen);
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const Gap(16),

                // Goals List and Circular Chart
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: controller.goalsData.map((goal) {
                          return GoalItemWidget(
                            barColor: goal['barColor'],
                            title: goal['title'],
                            subtitle: goal['subtitle'],
                          );
                        }).toList(),
                      ),
                    ),
                    const Gap(8),
                    const CircularProgressChartWidget(),
                  ],
                ),
                const Gap(32),

                // Mood Tracker / Daily Emojis
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: controller.moodEmojisData.map((mood) {
                    return MoodEmojiWidget(
                      day: mood['day'],
                      imagePath: mood['imagePath'] as String?,
                    );
                  }).toList(),
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
