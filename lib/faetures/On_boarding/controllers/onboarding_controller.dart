import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/models/user/profile_update_request_model.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/services/shared_preference_services.dart';

class OnboardingController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  // Store selected plan
  final RxString selectedPlanId = ''.obs;
  
  // Subscription plans data
  final List<Map<String, dynamic>> subscriptionPlans = [
    {'planName': 'Free', 'price': '\$0', 'planId': 'free'},
    {'planName': 'Premium', 'price': '\$19', 'planId': 'premium'},
    {'planName': 'Coach', 'price': '\$39', 'planId': 'coach'},
  ];

  // Initialize plan ID from arguments
  void initializePlan(Map<String, dynamic>? planData) {
    if (planData != null) {
      selectedPlanId.value = planData['planId'] as String? ?? '';
    }
  }

  // Select plan
  void selectPlan(Map<String, dynamic> plan) {
    final planId = plan['planId'] as String? ?? '';

    if (selectedPlanId.value != planId) {
      selectedPlanId.value = planId;
    }
  }

  // Getter for currently selected plan data
  Map<String, dynamic>? get currentPlan => subscriptionPlans.firstWhereOrNull(
        (plan) => plan['planId'] == selectedPlanId.value,
      );

  // Getter for selected plan name
  String get selectedPlanName {
    final plan = currentPlan;
    return plan != null ? plan['planName'] as String? ?? '' : '';
  }

  // Getter for selected plan price
  String get selectedPlanPrice {
    final plan = currentPlan;
    return plan != null ? plan['price'] as String? ?? '' : '';
  }
  
  // Check if plan is selected
  bool get hasSelectedPlan => selectedPlanId.value.isNotEmpty;
  
  // Handle continue from select plan screen
  void handlePlanContinue() {
    if (!hasSelectedPlan) {
      ToastClass.showCustomToast(
        'Please select a plan to continue',
        type: ToastType.error,
      );
      return;
    }
    
    // Navigate to category level screen with plan data
    final planData = currentPlan;
    if (planData == null) {
      ToastClass.showCustomToast(
        'Something went wrong. Please select a plan again.',
        type: ToastType.error,
      );
      return;
    }

    Get.toNamed(
      AppRoutes.categoryLevelScreen,
      arguments: planData,
    );
  }
  
  // Initialize category level screen from arguments
  void initializeCategoryLevelScreen() {
    final planData = Get.arguments as Map<String, dynamic>?;
    if (planData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initializePlan(planData);
      });
    }
  }
  
  // Handle get started from category level screen
  void handleGetStarted() {
    if (selectedMetaNeeds.isEmpty) {
      ToastClass.showCustomToast(
        'Please select at least one meta need',
        type: ToastType.error,
      );
      return;
    }
    
    if (selectedLevels.isEmpty) {
      ToastClass.showCustomToast(
        'Please select at least one level',
        type: ToastType.error,
      );
      return;
    }
    
    // Navigate to self assessment screen
    Get.toNamed(AppRoutes.selfAssessmentScreen);
  }

  final List<String> metaNeedsOptions = [
    'Cognitive needs: to know, understand, learn',
    'Contribution needs: to make a difference',
    'Conative: to choose your unique way of life',
    'Love needs: to care and extend yourself to others',
    'Truth Needs: to know what is true, real, and authentic',
    'Aesthetic needs: to see, enjoy, and create beauty',
  ];

  // Levels (Self, Social, Safety, Survival)
  final List<Map<String, String>> levels = [
    {'name': 'Self', 'emoji': '✏️'},
    {'name': 'Social', 'emoji': '💬'},
    {'name': 'Safety', 'emoji': '💪'},
    {'name': 'Survival', 'emoji': '😊'},
  ];

  // Reactive variables for selections
  final RxSet<String> selectedMetaNeeds = <String>{}.obs;
  final RxSet<String> selectedLevels = <String>{}.obs;

  // Check if meta need is locked based on plan
  bool isMetaNeedLocked(String option) {
    final planId = selectedPlanId.value;
    final index = metaNeedsOptions.indexOf(option);
    
    if (planId == 'free') {
      // Free plan: only first 2 unlocked
      return index >= 2;
    } else if (planId == 'premium') {
      // Premium plan: first 5 unlocked
      return index >= 5;
    } else if (planId == 'coach') {
      // Coach plan: all unlocked
      return false;
    }
    // Default: all locked if no plan selected
    return true;
  }

  // Toggle Meta Needs selection (multiple selection allowed)
  void toggleMetaNeed(String option) {
    // Don't allow selection if locked
    if (isMetaNeedLocked(option)) {
      ToastClass.showCustomToast(
        'This feature is locked. Please upgrade your plan.',
        type: ToastType.error,
      );
      return;
    }

    if (selectedMetaNeeds.contains(option)) {
      selectedMetaNeeds.remove(option);
    } else {
      selectedMetaNeeds.add(option);
    }
  }

  // Check if Meta Need is selected
  bool isMetaNeedSelected(String option) {
    return selectedMetaNeeds.contains(option);
  }

  // Check if level is locked based on plan
  bool isLevelLocked(String levelName) {
    final planId = selectedPlanId.value;
    final index = levels.indexWhere((level) => level['name'] == levelName);
    
    if (index == -1) return true; // Level not found
    
    if (planId == 'free') {
      // Free plan: only first 2 levels unlocked
      return index >= 2;
    } else if (planId == 'premium' || planId == 'coach') {
      // Premium and Coach plans: all levels unlocked
      return false;
    }
    // Default: all locked if no plan selected
    return true;
  }

  // Toggle level selection (multiple selection allowed)
  void toggleLevel(String levelName) {
    // Don't allow selection if locked
    if (isLevelLocked(levelName)) {
      ToastClass.showCustomToast(
        'This level is locked. Please upgrade your plan.',
        type: ToastType.error,
      );
      return;
    }

    if (selectedLevels.contains(levelName)) {
      selectedLevels.remove(levelName);
    } else {
      selectedLevels.add(levelName);
    }
  }

  // Check if level is selected
  bool isLevelSelected(String levelName) {
    return selectedLevels.contains(levelName);
  }

  // Submit selection
  void submitSelection() {
    if (selectedMetaNeeds.isEmpty || selectedLevels.isEmpty) {
      ToastClass.showCustomToast('Please select meta needs and at least one level', type: ToastType.error);
      return;
    }
    // Handle submit logic here
    ToastClass.showCustomToast('Selection saved', type: ToastType.success);
    // Navigate to next screen if needed
    // Get.toNamed(AppRoutes.NEXTSCREEN);
  }

  // Profile Setup variables
  final TextEditingController fullNameController = TextEditingController();
  final RxInt age = 45.obs;
  final RxSet<String> selectedFocusAreas = <String>{}.obs;
  final RxString selectedAvatar = ''.obs;
  final RxBool isProfileSubmitting = false.obs;

  // Focus Areas options
  final List<String> focusAreas = [
    'Career',
    'Health',
    'Creativity',
    'Spirituality',
    'Motivation',
  ];

  // Avatar options (you can replace these with actual image paths)
  final List<String> avatarOptions = [
    'avatar1',
    'avatar2',
    'avatar3',
    'avatar4',
    'avatar5',
  ];

  // Toggle Focus Area selection (multiple selection allowed)
  void toggleFocusArea(String focusArea) {
    if (selectedFocusAreas.contains(focusArea)) {
      selectedFocusAreas.remove(focusArea);
    } else {
      selectedFocusAreas.add(focusArea);
    }
  }

  // Check if Focus Area is selected
  bool isFocusAreaSelected(String focusArea) {
    return selectedFocusAreas.contains(focusArea);
  }

  // Remove Focus Area from selected
  void removeFocusArea(String focusArea) {
    selectedFocusAreas.remove(focusArea);
  }

  String _mapAvatarKeyToAsset(String avatarKey) {
    switch (avatarKey) {
      case 'avatar1':
        return AppImages.avatar1;
      case 'avatar2':
        return AppImages.avatar2;
      case 'avatar3':
        return AppImages.avatar3;
      case 'avatar4':
        return AppImages.avatar4;
      case 'avatar5':
        return AppImages.avatar5;
      default:
        return AppImages.avatar1;
    }
  }

  // Select Avatar (single selection)
  void selectAvatar(String avatar) {
    selectedAvatar.value = avatar;
  }

  // Check if Avatar is selected
  bool isAvatarSelected(String avatar) {
    return selectedAvatar.value == avatar;
  }

  // Increment age
  void incrementAge() {
    age.value++;
  }

  // Decrement age
  void decrementAge() {
    if (age.value > 1) {
      age.value--;
    }
  }

  // Submit Profile Setup
  Future<void> submitProfileSetup() async {
    final fullName = fullNameController.text.trim();
    if (fullName.isEmpty) {
      ToastClass.showCustomToast('Please enter your full name', type: ToastType.error);
      return;
    }
    if (selectedFocusAreas.isEmpty) {
      ToastClass.showCustomToast('Please select at least one focus area', type: ToastType.error);
      return;
    }
    if (selectedAvatar.value.isEmpty) {
      ToastClass.showCustomToast('Please select an avatar', type: ToastType.error);
      return;
    }

    final request = ProfileUpdateRequestModel(
      name: fullName,
      age: age.value,
      focusAreas: selectedFocusAreas.toList(),
      avatar: _mapAvatarKeyToAsset(selectedAvatar.value),
    );

    // Save profile setup completion status after successful API update
    try {
      isProfileSubmitting.value = true;

      final response = await _userRepository.updateProfile(request);
      if (!response.success) {
        final message = response.message.isNotEmpty
            ? response.message
            : 'Failed to update profile. Please try again.';
        ToastClass.showCustomToast(message, type: ToastType.error);
        return;
      }

      await PreferenceHelper.setBool(
        PrefConstants.isProfileSetupCompleted,
        true,
      );

      ToastClass.showCustomToast('Profile setup completed', type: ToastType.success);
      Get.offAllNamed(AppRoutes.mainNavScreen);
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to save profile setup. Please try again.',
        type: ToastType.error,
      );
    } finally {
      isProfileSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    super.onClose();
  }
}
