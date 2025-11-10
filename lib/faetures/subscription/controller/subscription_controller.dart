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
    Get.snackbar('Info', 'Voice search functionality');
  }

  void onNotificationTap() {
    // Navigate to notifications screen
    Get.toNamed(AppRoutes.notificationScreen);
  }

  void onPlanTap(String planId) {
    // Handle subscription plan tap
    // TODO: Navigate to subscription detail screen when implemented
    Get.snackbar(
      'Subscription Plan',
      'Selected plan: ${planId.toUpperCase()}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
