import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/const/app_exports.dart';

import '../../../core/controllers/user_controller.dart';

import '../../../data/models/user/profile_update_request_model.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/services/shared_preference_services.dart';
import '../widgets/logout_dialog_widget.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  final ImagePicker _imagePicker = ImagePicker();

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
  
  // Custom avatar photo
  final Rx<File?> customAvatarFile = Rx<File?>(null);
  final RxString customAvatarUrl = ''.obs;
  final RxBool isUploadingAvatar = false.obs;

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
          // Check if it's a custom URL (starts with http) or a preset avatar
          if (user.avatar!.startsWith('http')) {
            customAvatarUrl.value = user.avatar!;
            selectedAvatar.value = ''; // Clear preset selection
          } else {
            final avatarKey = _mapAvatarPathToKey(user.avatar!);
            if (avatarKey.isNotEmpty) {
              selectedAvatar.value = avatarKey;
            }
            customAvatarUrl.value = ''; // Clear custom URL
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
    // Clear custom avatar when preset is selected
    customAvatarFile.value = null;
    customAvatarUrl.value = '';
  }

  // Check if avatar is selected
  bool isAvatarSelected(String avatar) {
    return selectedAvatar.value == avatar;
  }

  // Check if user has custom avatar
  bool get hasCustomAvatar => customAvatarFile.value != null || customAvatarUrl.value.isNotEmpty;

  // Pick image from gallery
  Future<void> pickAvatarFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Check file size (max 5MB)
        final file = File(pickedFile.path);
        final fileSize = await file.length();
        if (fileSize > 5 * 1024 * 1024) {
          ToastClass.showCustomToast(
            'Image size must be less than 5MB',
            type: ToastType.error,
          );
          return;
        }

        customAvatarFile.value = file;
        selectedAvatar.value = ''; // Clear preset avatar selection
      }
    } catch (e) {
      DebugUtils.logError(
        'Error picking image from gallery',
        tag: 'ProfileController.pickAvatarFromGallery',
        error: e,
      );
      ToastClass.showCustomToast(
        'Failed to pick image',
        type: ToastType.error,
      );
    }
  }

  // Pick image from camera
  Future<void> pickAvatarFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Check file size (max 5MB)
        final file = File(pickedFile.path);
        final fileSize = await file.length();
        if (fileSize > 5 * 1024 * 1024) {
          ToastClass.showCustomToast(
            'Image size must be less than 5MB',
            type: ToastType.error,
          );
          return;
        }

        customAvatarFile.value = file;
        selectedAvatar.value = ''; // Clear preset avatar selection
      }
    } catch (e) {
      DebugUtils.logError(
        'Error picking image from camera',
        tag: 'ProfileController.pickAvatarFromCamera',
        error: e,
      );
      ToastClass.showCustomToast(
        'Failed to capture image',
        type: ToastType.error,
      );
    }
  }

  // Show image source picker dialog
  void showImageSourcePicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextWidget(
              text: 'Choose Photo',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textColor: AppColors.black,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.blue),
              title: CustomTextWidget(
                text: 'Choose from Gallery',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: AppColors.black,
              ),
              onTap: () {
                Get.back();
                pickAvatarFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.blue),
              title: CustomTextWidget(
                text: 'Take a Photo',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: AppColors.black,
              ),
              onTap: () {
                Get.back();
                pickAvatarFromCamera();
              },
            ),
            if (hasCustomAvatar) ...[
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: CustomTextWidget(
                  text: 'Remove Custom Photo',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: Colors.red,
                ),
                onTap: () {
                  Get.back();
                  removeCustomAvatar();
                },
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Remove custom avatar
  void removeCustomAvatar() {
    customAvatarFile.value = null;
    customAvatarUrl.value = '';
  }

  // Upload avatar to server
  Future<bool> _uploadAvatarIfNeeded() async {
    if (customAvatarFile.value == null) {
      return true; // No file to upload
    }

    try {
      isUploadingAvatar.value = true;
      
      final response = await _userRepository.uploadAvatar(customAvatarFile.value!);
      
      isUploadingAvatar.value = false;

      if (response.success && response.data != null) {
        // Extract avatar URL from response
        final avatarUrl = response.data!['avatarUrl'] as String?;
        if (avatarUrl != null) {
          customAvatarUrl.value = avatarUrl;
        }
        return true;
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty ? response.message : 'Failed to upload photo',
          type: ToastType.error,
        );
        return false;
      }
    } catch (e) {
      isUploadingAvatar.value = false;
      DebugUtils.logError(
        'Error uploading avatar',
        tag: 'ProfileController._uploadAvatarIfNeeded',
        error: e,
      );
      ToastClass.showCustomToast(
        'Failed to upload photo',
        type: ToastType.error,
      );
      return false;
    }
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

    // Validate avatar: either preset or custom
    if (selectedAvatar.value.isEmpty && !hasCustomAvatar) {
      ToastClass.showCustomToast(
        'Please select an avatar or upload a photo',
        type: ToastType.error,
      );
      return;
    }

    try {
      isProfileSubmitting.value = true;

      // Upload custom avatar first if selected
      if (customAvatarFile.value != null) {
        final uploadSuccess = await _uploadAvatarIfNeeded();
        if (!uploadSuccess) {
          isProfileSubmitting.value = false;
          return;
        }
      }

      // Determine avatar value to send
      String avatarValue;
      if (customAvatarUrl.value.isNotEmpty) {
        avatarValue = customAvatarUrl.value;
      } else if (selectedAvatar.value.isNotEmpty) {
        avatarValue = getAvatarImagePath(selectedAvatar.value);
      } else {
        avatarValue = '';
      }

      final request = ProfileUpdateRequestModel(
        name: fullName,
        age: age.value,
        focusAreas: selectedFocusAreas.toList(),
        avatar: avatarValue,
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

