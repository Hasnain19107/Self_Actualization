import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../core/const/app_exports.dart';
import '../../notification/binding/notification_binding.dart';
import '../../profile/view/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  final int? initialIndex;

  const MainNavScreen({super.key, this.initialIndex});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  bool _showUpgradeBanner = true;

  void _dismissBanner() {
    if (mounted) setState(() => _showUpgradeBanner = false);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize binding when screen is first created
    BottomNavBinding().dependencies();
    // Initialize NotificationController to track unread notifications on all screens
    NotificationBinding().dependencies();

    // Set initial index if provided via arguments or parameter
    // Safely check if arguments is an int before casting
    int? indexFromArgs;
    if (Get.arguments != null && Get.arguments is int) {
      indexFromArgs = Get.arguments as int;
    }
    final index = widget.initialIndex ?? indexFromArgs;

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
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Upgrade Banner - shows like an ad above bottom nav
            if (_showUpgradeBanner)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: UpgradeBannerWidget(
                  showDismiss: true,
                  onDismiss: _dismissBanner,
                ),
              ),
            // Bottom Navigation Bar
            CustomBottomNavBar(initialIndex: index),
          ],
        ),
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
