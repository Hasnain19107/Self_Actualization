import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pixsa_petrol_pump/core/const/app_colors.dart';
import 'package:pixsa_petrol_pump/core/utils/app_sizes.dart';
import 'package:pixsa_petrol_pump/core/widgets/custom_text_widget.dart';
import '../binding/home_binding.dart';
import '../controller/home_controller.dart';
import '../widgtes/action_cards_widget.dart';
import '../widgtes/header_widget.dart';
import '../widgtes/needs_slider_widget.dart';
import '../../../core/widgets/custom_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize binding
    HomeBinding().dependencies();
    final AppSizes appSizes = AppSizes();
    final controller = Get.find<HomeController>();

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
              HeaderWidget(
                userName: controller.userName.value,
                greeting: controller.greeting.value,
              ),
              const Gap(24),
              Row(
                children: [
                  CustomTextWidget(
                    text: 'Good morning',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.black,
                    textAlign: TextAlign.left,
                  ),
                  CustomTextWidget(
                    text: '@DuozhuaMiao 🌞',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.black,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
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
