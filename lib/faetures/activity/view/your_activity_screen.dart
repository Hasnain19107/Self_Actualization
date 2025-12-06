import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/const/app_exports.dart';

class YourActivityScreen extends StatelessWidget {
  YourActivityScreen({super.key});

  final AppSizes appSizes = AppSizes();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    YourActivityBinding().dependencies();
    final controller = Get.find<YourActivityController>();

    // Refresh data when screen is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isLoadingGoals.value) {
        controller.refreshData();
      }
    });

    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchGoals();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Obx(() {
            // Show loading for entire screen
            if (controller.isLoadingGoals.value) {
              return const Center(
                child: CustomProgressIndicator(),
              );
            }

            // Show error screen for entire screen
            if (controller.errorMessage.value.isNotEmpty) {
              return ErrorScreenWidget(
                errorMessage: controller.errorMessage.value,
                onRetry: () => controller.fetchGoals(),
              );
            }

            // Show content
            return Padding(
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
                  
          
                    // Date Picker (Current Week Only)
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.dates.length,
                        separatorBuilder: (context, index) => const Gap(8),
                        itemBuilder: (context, index) {
                          final dateData = controller.dates[index];
                          final date = dateData['date'] as DateTime;
                          final displayText = dateData['displayText'] as String;
                          final isToday = dateData['isToday'] as bool;
                          
                          return Obx(() {
                            final isSelected = controller.isSameDay(date, controller.selectedDate.value);
                            
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
                                    text: displayText,
                                    fontSize: 14,
                                    fontWeight: isSelected || isToday
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
                    Obx(() {
                      final cardsData = controller.activityCardsData;
                      return Row(
                        children: [
                          Expanded(
                            child: ActivityCardWidget(
                              icon1: cardsData[0]['icon1'] as IconData,
                              icon1Color: cardsData[0]['icon1Color'] as Color,
                              icon2: cardsData[0]['icon2'] as IconData?,
                              icon2Color: cardsData[0]['icon2Color'] as Color?,
                              title: cardsData[0]['title'] as String,
                              subtitle: cardsData[0]['subtitle'] as String,
                              backgroundColor: AppColors.lightBlue.withOpacity(0.5),
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: ActivityCardWidget(
                              icon1: cardsData[1]['icon1'] as IconData,
                              icon1Color: cardsData[1]['icon1Color'] as Color,
                              icon2: cardsData[1]['icon2'] as IconData?,
                              icon2Color: cardsData[1]['icon2Color'] as Color?,
                              icon2BgColor: cardsData[1]['icon2BgColor'] as Color?,
                              title: cardsData[1]['title'] as String,
                              subtitle: cardsData[1]['subtitle'] as String,
                              backgroundColor: AppColors.lightBlue.withOpacity(0.5),
                              onTap: () {
                                Get.toNamed(AppRoutes.dailyReflectionScreen);
                              },
                            ),
                          ),
                        ],
                      );
                    }),
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
                    Obx(() {
                      final currentGoals = controller.currentGoals;
                      
                      if (currentGoals.isEmpty) {
                        return CustomTextWidget(
                          text: 'No active goals yet. Add a new goal to get started!',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.mediumGray,
                          textAlign: TextAlign.left,
                        );
                      }
          
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: currentGoals.map((goal) {
                                return GoalItemWidget(
                                  barColor: controller.barColorForGoal(goal),
                                  title: goal.title,
                                  subtitle: controller.formattedDateRange(goal),
                                );
                              }).toList(),
                            ),
                          ),
                          const Gap(8),
                          Obx(() {
                            // Observe goals to update chart
                            final _ = controller.goals.length;
                            return CircularProgressChartWidget(
                              segments: controller.chartSegments,
                            );
                          }),
                        ],
                      );
                    }),
                    const Gap(32),
          
                    // Mood Tracker / Daily Emojis
                    Obx(() {
                      final moodsWithReflections = controller.moodsWithReflections;
                      
                      if (controller.isLoadingReflections) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CustomProgressIndicator(),
                          ),
                        );
                      }
                      
                      if (moodsWithReflections.isEmpty) {
                        return const SizedBox.shrink(); // Show nothing when empty, like daily_reflection_screen
                      }
                      
                      return Row(
                      
                        children: moodsWithReflections.map((mood) {
                          return MoodEmojiWidget(
                            day: mood['day'] as String? ?? '',
                            imagePath: mood['imagePath'] as String?,
                          );
                        }).toList(),
                      );
                    }),
                    const Gap(20),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
