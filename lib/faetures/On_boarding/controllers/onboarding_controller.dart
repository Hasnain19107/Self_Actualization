import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class OnboardingController extends GetxController {
  // Store selected plan
  final RxString selectedPlanId = ''.obs;
  final RxMap<String, dynamic> selectedPlan = <String, dynamic>{}.obs;

  // Initialize plan from arguments
  void initializePlan(Map<String, dynamic>? planData) {
    if (planData != null) {
      selectedPlan.value = planData;
      selectedPlanId.value = planData['planId'] as String? ?? '';
    }
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
  void submitProfileSetup() {
    if (fullNameController.text.isEmpty) {
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
    // Handle submit logic here
    ToastClass.showCustomToast('Profile setup completed', type: ToastType.success);
    // Navigate to main navigation screen
    Get.offAllNamed(AppRoutes.mainNavScreen);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    super.onClose();
  }
}
