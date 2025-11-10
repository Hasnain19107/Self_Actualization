import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../models/plan_model.dart';

/// Controller for Plan Details Screen
/// Manages the state and logic for displaying subscription plan details
class PlanDetailsController extends GetxController {
  final Rx<SubscriptionPlanModel?> currentPlan = Rx<SubscriptionPlanModel?>(null);
  final RxString selectedCategory = 'Social'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializePlanData();
  }

  /// Initialize plan data from arguments or create default
  void _initializePlanData() {
    if (Get.arguments != null && Get.arguments is SubscriptionPlanModel) {
      currentPlan.value = Get.arguments as SubscriptionPlanModel;
    } else if (Get.arguments != null && Get.arguments is Map) {
      // Handle case where plan data is passed as Map
      final planData = Get.arguments as Map<String, dynamic>;
      currentPlan.value = _createPlanFromMap(planData);
    } else {
      // Create default plan if no arguments
      currentPlan.value = _createDefaultPlan();
    }
  }

  /// Create plan model from map data
  SubscriptionPlanModel _createPlanFromMap(Map<String, dynamic> planData) {
    final planId = planData['planId'] as String? ?? 'premium';
    final planName = planData['planName'] as String? ?? 'Premium';
    final price = planData['price'] as String? ?? '\$19';

    return SubscriptionPlanModel(
      id: planId,
      name: planName,
      price: price,
      categories: _getCategoriesForPlan(planId),
    );
  }

  /// Create default plan for testing
  SubscriptionPlanModel _createDefaultPlan() {
    return SubscriptionPlanModel(
      id: 'premium',
      name: 'Premium',
      price: '\$19',
      categories: _getCategoriesForPlan('premium'),
    );
  }

  /// Get categories based on plan ID
  List<PlanCategory> _getCategoriesForPlan(String planId) {
    final metaNeedsItems = [
      PlanMetaNeedItem(
        description: 'Cognitive needs: to know, understand, learn',
      ),
      PlanMetaNeedItem(
        description: 'Contribution needs: to make a difference',
      ),
      PlanMetaNeedItem(
        description: 'Conative: to choose your unique way of life',
      ),
      PlanMetaNeedItem(
        description: 'Love needs: to care and extend yourself to others',
      ),
      PlanMetaNeedItem(
        description: 'Truth needs: to know what is true, real and authentic',
      ),
      PlanMetaNeedItem(
        description: 'Aesthetic needs: to see, enjoy, and create beauty',
      ),
      PlanMetaNeedItem(
        description: 'Expressive needs: to be and express your best self',
      ),
    ];

    final categories = <PlanCategory>[
      PlanCategory(
        name: 'Meta Needs',
        emoji: '🧘',
        metaNeedItems: metaNeedsItems,
      ),
      PlanCategory(
        name: 'Self',
        emoji: '✏️',
      ),
      PlanCategory(
        name: 'Social',
        emoji: '💬',
      ),
      PlanCategory(
        name: 'Safety',
        emoji: '💪',
      ),
      PlanCategory(
        name: 'Survival',
        emoji: '😊',
      ),
    ];

    // Add additional categories based on plan
    if (planId == 'coach') {
      categories.add(
        PlanCategory(
          name: 'Coaching',
          icon: Icons.support_agent,
          backgroundColor: AppColors.blue,
          textColor: AppColors.white,
        ),
      );
    }

    return categories;
  }

  /// Handle category card tap
  void onCategoryCardTap(PlanCategory category) {
    selectedCategory.value = category.name;
    // Additional logic can be added here
  }

  /// Handle continue button press
  void onContinuePressed() {
    if (currentPlan.value != null) {
      // Navigate to payment or confirmation screen
      ToastClass.showCustomToast(
        'Proceeding with ${currentPlan.value!.name} plan',
        type: ToastType.simple,
      );
      // TODO: Implement navigation to payment/confirmation screen
      // Get.toNamed(AppRoutes.paymentScreen, arguments: currentPlan.value);
    }
  }

  /// Get Meta Needs category
  PlanCategory? get metaNeedsCategory {
    return currentPlan.value?.categories.firstWhereOrNull(
      (cat) => cat.name == 'Meta Needs',
    );
  }

  /// Get feature categories (excluding Meta Needs)
  List<PlanCategory> get featureCategories {
    return currentPlan.value?.categories
            .where((cat) => cat.name != 'Meta Needs')
            .toList() ??
        [];
  }
}

