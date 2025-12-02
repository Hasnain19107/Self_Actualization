import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixsa_petrol_pump/faetures/subscription/view/select_plan.dart';

import '../../../core/const/app_exports.dart';

class MainNavScreen extends StatelessWidget {
  final int? initialIndex;

  const MainNavScreen({super.key, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    // Initialize binding when screen is first created
    BottomNavBinding().dependencies();

    // Set initial index if provided via arguments or parameter
    // Safely check if arguments is an int before casting
    int? indexFromArgs;
    if (Get.arguments != null && Get.arguments is int) {
      indexFromArgs = Get.arguments as int;
    }
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
          return const SelectPlanScreen(showHeader: true); // Show header when accessed from bottom nav
        default:
          return const HomeScreen();
      }
    });
  }
}
