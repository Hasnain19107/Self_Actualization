import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/const/app_exports.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  final int totalPages = 5;

  /// Preference key for tracking onboarding completion
  static const String hasSeenOnboardingKey = 'hasSeenOnboarding';

  /// Move to the next page or complete onboarding if on last page
  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  /// Skip to the last page
  void skipToEnd() {
    pageController.animateToPage(
      totalPages - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  /// Complete onboarding and navigate to the next screen
  Future<void> completeOnboarding() async {
    // Save that user has seen onboarding
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(hasSeenOnboardingKey, true);

    // Navigate to login screen
    Get.offNamed(AppRoutes.loginScreen);
  }

  /// Check if user has already seen onboarding
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(hasSeenOnboardingKey) ?? false;
  }

  /// Update current page index when page changes
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  /// Check if currently on the last page
  bool get isLastPage => currentPage.value == totalPages - 1;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
