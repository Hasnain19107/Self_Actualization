import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../core/const/app_exports.dart';
import '../../profile/view/profile_screen.dart';

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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        // Get controller safely
        if (!Get.isRegistered<BottomNavController>()) {
          return;
        }

        final controller = Get.find<BottomNavController>();

        // If not on home tab (index 0), navigate to home
        if (controller.currentIndex.value != 0) {
          controller.changeIndex(0);
        } else {
          // If on home tab, show exit dialog
          final shouldExit = await ExitDialogWidget.show();
          if (shouldExit == true) {
            exit(0);
          }
        }
      },
      child: Scaffold(
        body: _buildBody(),
        bottomNavigationBar: CustomBottomNavBar(initialIndex: index),
      ),
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
          return const ProfileScreen();
        default:
          return const HomeScreen();
      }
    });
  }
}
