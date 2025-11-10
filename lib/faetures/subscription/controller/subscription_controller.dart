import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class SubscriptionController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Subscription plans data
  final List<Map<String, dynamic>> subscriptionPlans = [
    {'planName': 'Free', 'price': '\$0', 'planId': 'free'},
    {'planName': 'Premium', 'price': '\$19', 'planId': 'premium'},
    {'planName': 'Coach', 'price': '\$39', 'planId': 'coach'},
  ];

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onMicTap() {
    // Handle microphone tap for voice search
    ToastClass.showCustomToast('Voice search functionality', type: ToastType.simple);
  }

  void onNotificationTap() {
    // Navigate to notifications screen
    Get.toNamed(AppRoutes.notificationScreen);
  }

  void onPlanTap(String planId) {
    // Find the selected plan
    final selectedPlan = subscriptionPlans.firstWhereOrNull(
      (plan) => plan['planId'] == planId,
    );

    if (selectedPlan != null) {
      // Navigate to plan details screen with plan data
      Get.toNamed(
        AppRoutes.planDetailsScreen,
        arguments: selectedPlan,
      );
    } else {
      ToastClass.showCustomToast(
        'Plan not found',
        type: ToastType.error,
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
