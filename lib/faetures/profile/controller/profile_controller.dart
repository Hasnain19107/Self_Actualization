import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

import '../../../core/controllers/user_controller.dart';

import '../../../data/models/user/profile_update_request_model.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/services/shared_preference_services.dart';
import '../widgets/logout_dialog_widget.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  // Profile form controllers
  final TextEditingController fullNameController = TextEditingController();
  final RxInt age = 45.obs;
  final RxSet<String> selectedFocusAreas = <String>{}.obs;
  final RxString selectedAvatar = ''.obs;
  final RxBool isProfileSubmitting = false.obs;
  final RxBool isLoadingUserData = false.obs;
  final RxBool hasExistingProfile = false.obs;
  final RxBool isLoggingOut = false.obs;
  final RxBool fromWelcome = false.obs;
  final RxString errorMessage = ''.obs;

  // Available focus areas
  final List<String> focusAreas = [
    'Career',
    'Health',
    'Creativity',
    'Spirituality',
    'Motivation',
  ];

  // Avatar options
  final List<String> avatarOptions = [
    'avatar1',
    'avatar2',
    'avatar3',
    'avatar4',
    'avatar5',
  ];

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    super.onClose();
  }

  // Load user data and pre-populate form
  Future<void> loadUserData() async {
    isLoadingUserData.value = true;
    errorMessage.value = ''; // Clear error on retry
    try {
      final response = await _userRepository.getUserData();

      isLoadingUserData.value = false;

      if (response.success && response.data != null) {
        final user = response.data!;
        
        // Pre-populate form fields
        if (user.name.isNotEmpty) {
          fullNameController.text = user.name;
        }
        
        if (user.age != null && user.age! > 0) {
          age.value = user.age!;
        }
        
        if (user.focusAreas != null && user.focusAreas!.isNotEmpty) {
          selectedFocusAreas.clear();
          selectedFocusAreas.addAll(user.focusAreas!);
        }
        
        // Map avatar path back to avatar key
        if (user.avatar != null && user.avatar!.isNotEmpty) {
          final avatarKey = _mapAvatarPathToKey(user.avatar!);
          if (avatarKey.isNotEmpty) {
            selectedAvatar.value = avatarKey;
          }
        }
        
        // Mark that we have existing profile data
        hasExistingProfile.value = true;
      } else {
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Failed to load user data';
      }
    } catch (e) {
      isLoadingUserData.value = false;
      errorMessage.value = 'An error occurred. Please try again.';
      DebugUtils.logError(
        'Error loading user data for profile setup',
        tag: 'ProfileController.loadUserData',
        error: e,
      );
    }
  }

  void refreshData() {
    errorMessage.value = '';
    loadUserData();
  }

  // Map avatar path (e.g., "assets/images/avatar4.jpg") back to key (e.g., "avatar4")
  String _mapAvatarPathToKey(String avatarPath) {
    if (avatarPath.contains('avatar1')) return 'avatar1';
    if (avatarPath.contains('avatar2')) return 'avatar2';
    if (avatarPath.contains('avatar3')) return 'avatar3';
    if (avatarPath.contains('avatar4')) return 'avatar4';
    if (avatarPath.contains('avatar5')) return 'avatar5';
    return '';
  }

  // Toggle focus area selection
  void toggleFocusArea(String focusArea) {
    if (selectedFocusAreas.contains(focusArea)) {
      selectedFocusAreas.remove(focusArea);
    } else {
      selectedFocusAreas.add(focusArea);
    }
  }

  // Check if focus area is selected
  bool isFocusAreaSelected(String focusArea) {
    return selectedFocusAreas.contains(focusArea);
  }

  // Remove focus area
  void removeFocusArea(String focusArea) {
    selectedFocusAreas.remove(focusArea);
  }

  // Get avatar image path
  String getAvatarImagePath(String avatar) {
    switch (avatar) {
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

  // Select avatar
  void selectAvatar(String avatar) {
    selectedAvatar.value = avatar;
  }

  // Check if avatar is selected
  bool isAvatarSelected(String avatar) {
    return selectedAvatar.value == avatar;
  }

  // Set flag for navigation from welcome screen
  void setFromWelcomeFlag(bool value) {
    fromWelcome.value = value;
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

  // Submit profile setup
  Future<void> submitProfileSetup() async {
    final fullName = fullNameController.text.trim();

    // Validation
    if (fullName.isEmpty) {
      ToastClass.showCustomToast(
        'Please enter your full name',
        type: ToastType.error,
      );
      return;
    }

    if (selectedFocusAreas.isEmpty) {
      ToastClass.showCustomToast(
        'Please select at least one focus area',
        type: ToastType.error,
      );
      return;
    }

    if (selectedAvatar.value.isEmpty) {
      ToastClass.showCustomToast(
        'Please select an avatar',
        type: ToastType.error,
      );
      return;
    }

    try {
      final request = ProfileUpdateRequestModel(
        name: fullName,
        age: age.value,
        focusAreas: selectedFocusAreas.toList(),
        avatar: getAvatarImagePath(selectedAvatar.value),
      );

      isProfileSubmitting.value = true;

      final response = await _userRepository.updateProfile(request);

      if (!response.success) {
        final message = response.message.isNotEmpty
            ? response.message
            : 'Failed to update profile. Please try again.';
        ToastClass.showCustomToast(message, type: ToastType.error);
        return;
      }

      // Save profile setup completion status after successful API update
      await PreferenceHelper.setBool(
        PrefConstants.isProfileSetupCompleted,
        true,
      );

      ToastClass.showCustomToast(
        hasExistingProfile.value
            ? 'Profile updated successfully'
            : 'Profile setup completed',
        type: ToastType.success,
      );
      
      // Refresh user data in UserController
      if (Get.isRegistered<UserController>()) {
        final userController = Get.find<UserController>();
        await userController.refreshUserData();
      }
      
      // Navigate based on where user came from
      if (fromWelcome.value) {
        // If coming from welcome screen, navigate to select plan screen
        Get.offNamed(AppRoutes.selectPlanScreen);
      } else {
        // Otherwise, go back to previous screen
        Get.back();
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to save profile setup. Please try again.',
        type: ToastType.error,
      );
    } finally {
      isProfileSubmitting.value = false;
    }
  }

  // Handle logout
  Future<void> handleLogout() async {
    try {
      isLoggingOut.value = true;

      // Show confirmation dialog
      final shouldLogout = await LogoutDialogWidget.show();

      if (shouldLogout != true) {
        isLoggingOut.value = false;
        return;
      }

      // Clear user data from UserController if registered
      if (Get.isRegistered<UserController>()) {
        final userController = Get.find<UserController>();
        userController.currentUser.value = null;
      }

      // Logout from repository
      await _userRepository.logout();

      // Clear all GetX controllers and routes
      Get.offAllNamed(AppRoutes.loginScreen);

      ToastClass.showCustomToast(
        'Logged out successfully',
        type: ToastType.success,
      );
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to logout. Please try again.',
        type: ToastType.error,
      );
    } finally {
      isLoggingOut.value = false;
    }
  }
}

