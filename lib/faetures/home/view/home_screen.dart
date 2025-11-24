import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../binding/home_binding.dart';
import '../../../core/const/app_exports.dart';
import '../controller/home_controller.dart';
import '../widgtes/action_cards_widget.dart';
import '../../../core/widgets/needs_slider_widget.dart';
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
        child: Padding(
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
                    ],
                  ],
                );
              }),
              // Action Cards
              ActionCardsWidget(
                actionCards: controller.actionCards,
                onTap: controller.onActionCardTap,
              ),
              const SizedBox(height: 24),
              // Needs Sliders
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: controller.needs
                        .map((need) => NeedsSliderWidget(need: need))
                        .toList(),
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
