import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixsa_petrol_pump/faetures/subscription/view/subscription_screen.dart';
import '../../../core/const/app_exports.dart';

class MainNavScreen extends StatelessWidget {
  final int? initialIndex;

  const MainNavScreen({super.key, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    // Initialize binding when screen is first created
    BottomNavBinding().dependencies();

    // Set initial index if provided via arguments or parameter
    final indexFromArgs = Get.arguments as int?;
    final index = initialIndex ?? indexFromArgs;

    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavBar(initialIndex: index),
    );
  }

  Widget _buildBody() {
    final controller = Get.find<BottomNavController>();
    return Obx(() {
      switch (controller.currentIndex.value) {
        case 0:
          return const HomeScreen();
        case 1:
          return YourActivityScreen();
        case 2:
          return AchievementScreen();
        case 3:
          return const SubscriptionScreen(); // or use any other appropriate widget, e.g., SizedBox.shrink()
        default:
          return const HomeScreen();
      }
    });
  }
}
