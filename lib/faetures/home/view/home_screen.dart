import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/const/app_exports.dart';

import '../../../core/controllers/user_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeBinding().dependencies();
    final AppSizes appSizes = AppSizes();
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(() {
          // Show loading for entire screen
          if (controller.isLoadingNeeds.value) {
            return const Center(
              child: CustomProgressIndicator(),
            );
          }

          // Show error screen for entire screen
          if (controller.errorMessage.value.isNotEmpty) {
            return ErrorScreenWidget(
              errorMessage: controller.errorMessage.value,
              onRetry: () => controller.refreshData(),
            );
          }

          // Show content
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: appSizes.getWidthPercentage(3),
              vertical: appSizes.getHeightPercentage(2),
            ),
            child: Column(
              children: [
                // Header with user avatar
                AppHeaderWidget(),

                // Greeting with user name
                Obx(() {
                  final userController = Get.isRegistered<UserController>()
                      ? Get.find<UserController>()
                      : null;
                  final userName = userController?.userName ?? '';
                  return Row(
                    children: [
                      CustomTextWidget(
                        text: 'Good morning',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      if (userName.isNotEmpty) ...[
                        const Gap(8),
                        CustomTextWidget(
                          text: '@$userName 🌞',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          textColor: AppColors.black,
                          textAlign: TextAlign.left,
                        ),
                      ]
                    ],
                  );
                }),
                const Gap(16),
                // Action Cards
                ActionCardsWidget(
                  actionCards: controller.actionCards,
                  onTap: controller.onActionCardTap,
                ),
                const SizedBox(height: 24),
                // Needs Sliders
                Expanded(
                  child: controller.needs.isEmpty
                      ? Center(
                          child: CustomTextWidget(
                            text: 'No assessment data available',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            textColor: AppColors.grey,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: controller.needs
                                .map((need) => NeedsSliderWidget(need: need))
                                .toList(),
                          ),
                        ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
