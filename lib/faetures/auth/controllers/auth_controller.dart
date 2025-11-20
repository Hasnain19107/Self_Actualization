import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/models/user/register_request_model.dart';
import '../../../data/models/user/login_request_model.dart';

class AuthController extends GetxController {
  // Sign in controllers
  TextEditingController signinEmailController = TextEditingController();
  TextEditingController signinPasswordController = TextEditingController();
  
  // Sign up controllers
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();

  // Forgot password controller
  TextEditingController forgotPasswordEmailController = TextEditingController();

  // Loading state
  final RxBool isLoading = false.obs;

  // User Repository
  final UserRepository _userRepository = UserRepository();

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Full name validation
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  // Confirm password validation
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != signupPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Sign in method
  Future<void> signIn() async {
    // Validate email
    final emailError = validateEmail(signinEmailController.text);
    if (emailError != null) {
      ToastClass.showCustomToast(emailError, type: ToastType.error);
      return;
    }

    // Validate password
    final passwordError = validatePassword(signinPasswordController.text);
    if (passwordError != null) {
      ToastClass.showCustomToast(passwordError, type: ToastType.error);
      return;
    }

    try {
      isLoading.value = true;

      // Create login request
      final loginRequest = LoginRequestModel(
        email: signinEmailController.text.trim(),
        password: signinPasswordController.text,
      );

      // Call repository to login
      final response = await _userRepository.login(loginRequest);

      isLoading.value = false;

      if (response.success && response.data != null) {
        // Clear controllers
        signinEmailController.clear();
        signinPasswordController.clear();

        // Show success message
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Login successful',
          type: ToastType.success,
        );

        // Navigate to welcome screen on success
        Get.toNamed(AppRoutes.welcomeScreen);
      } else {
        // Show error message
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Sign in failed. Please try again.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      isLoading.value = false;
      ToastClass.showCustomToast(
        'Sign in failed. Please try again.',
        type: ToastType.error,
      );
    }
  }

  // Sign up method
  Future<void> signUp() async {
    // Validate email
    final emailError = validateEmail(signupEmailController.text);
    if (emailError != null) {
      ToastClass.showCustomToast(emailError, type: ToastType.error);
      return;
    }

    // Validate full name
    final fullNameError = validateFullName(fullNameController.text);
    if (fullNameError != null) {
      ToastClass.showCustomToast(fullNameError, type: ToastType.error);
      return;
    }

    // Validate password
    final passwordError = validatePassword(signupPasswordController.text);
    if (passwordError != null) {
      ToastClass.showCustomToast(passwordError, type: ToastType.error);
      return;
    }

    try {
      isLoading.value = true;

      // Create register request
      final registerRequest = RegisterRequestModel(
        name: fullNameController.text.trim(),
        email: signupEmailController.text.trim(),
        password: signupPasswordController.text,
      );

      // Call repository to register
      final response = await _userRepository.register(registerRequest);

      isLoading.value = false;

      if (response.success && response.data != null) {
        // Clear controllers
        signupEmailController.clear();
        fullNameController.clear();
        signupPasswordController.clear();

        // Show success message
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Account created successfully!',
          type: ToastType.success,
        );

        // Navigate to welcome screen on success
        Get.toNamed(AppRoutes.welcomeScreen);
      } else {
        // Show error message
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Sign up failed. Please try again.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      isLoading.value = false;
      ToastClass.showCustomToast(
        'Sign up failed. Please try again.',
        type: ToastType.error,
      );
    }
  }

  // Forgot password method
  Future<void> forgotPassword() async {
    // Validate email
    final emailError = validateEmail(forgotPasswordEmailController.text);
    if (emailError != null) {
      ToastClass.showCustomToast(emailError, type: ToastType.error);
      return;
    }

    try {
      isLoading.value = true;

      // Call repository to send forgot password request
      final response = await _userRepository.forgotPassword(
        forgotPasswordEmailController.text.trim(),
      );

      isLoading.value = false;

      if (response.success) {
        // Clear controller
        forgotPasswordEmailController.clear();

        // Show success message
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Password reset link sent to your email!',
          type: ToastType.success,
        );

        // Navigate back to login screen
        Get.back();
      } else {
        // Show error message
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to send reset link. Please try again.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      isLoading.value = false;
      ToastClass.showCustomToast(
        'Failed to send reset link. Please try again.',
        type: ToastType.error,
      );
    }
  }

  @override
  void onClose() {
    signinEmailController.dispose();
    signinPasswordController.dispose();
    signupEmailController.dispose();
    fullNameController.dispose();
    signupPasswordController.dispose();
    forgotPasswordEmailController.dispose();
    super.onClose();
  }
}
