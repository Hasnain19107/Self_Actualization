import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../bottom_navigation_bar/view/main_nav_screen.dart';

class OnboardingController extends GetxController {
  final List<String> metaNeedsOptions = [
    'Cognitive needs: to know, understand, learn',
    'Contribution needs: to make a difference',
    'Conative: to choose your unique way of life',
    'Love needs: to care and extend yourself to others',
    'Truth Needs: to know what is true, real, and authentic',
    'Aesthetic needs: to see, enjoy, and create beauty',
  ];

  // Categories
  final List<Map<String, String>> categories = [
    {'name': 'Self', 'emoji': '✏️'},
    {'name': 'Social', 'emoji': '💬'},
    {'name': 'Safety', 'emoji': '💪'},
    {'name': 'Survival', 'emoji': '😊'},
  ];

  // Reactive variables for selections
  final RxSet<String> selectedMetaNeeds = <String>{}.obs;
  final RxString selectedCategory = ''.obs;

  // Toggle Meta Needs selection (multiple selection allowed)
  void toggleMetaNeed(String option) {
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

  // Select category (single selection)
  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  // Check if category is selected
  bool isCategorySelected(String category) {
    return selectedCategory.value == category;
  }

  // Submit selection
  void submitSelection() {
    if (selectedMetaNeeds.isEmpty && selectedCategory.value.isEmpty) {
      Get.snackbar('Error', 'Please select at least one option');
      return;
    }
    // Handle submit logic here
    Get.snackbar('Success', 'Selection saved');
    // Navigate to next screen if needed
    // Get.toNamed(AppRoutes.NEXTSCREEN);
  }

  // Self Assessment variables
  final RxInt currentQuestionIndex = 2.obs; // 3 of 14 (0-indexed, so 2)
  final RxInt selectedRating = 5.obs;
  final RxString currentQuestion =
      'I get 7-8 hours of quality,\n restorative sleep most nights'.obs;
  final int totalQuestions = 14;

  // Rating scale descriptions
  final Map<int, String> ratingDescriptions = {
    1: 'Not at all true',
    2: 'Rarely true',
    3: 'Sometimes true',
    4: 'Often true',
    5: 'Usually true',
    6: 'Almost always true',
    7: 'Completely true',
  };

  void selectRating(int rating) {
    selectedRating.value = rating;
  }

  String get progressText =>
      '${currentQuestionIndex.value + 1} of $totalQuestions';

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
      Get.snackbar('Error', 'Please enter your full name');
      return;
    }
    if (selectedFocusAreas.isEmpty) {
      Get.snackbar('Error', 'Please select at least one focus area');
      return;
    }
    if (selectedAvatar.value.isEmpty) {
      Get.snackbar('Error', 'Please select an avatar');
      return;
    }
    // Handle submit logic here
    Get.snackbar('Success', 'Profile setup completed');
    // Navigate to main navigation screen
    Get.offAll(() => const MainNavScreen());
  }

  @override
  void onClose() {
    fullNameController.dispose();
    super.onClose();
  }
}
