import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Plan selection
  RxString selectedPlan = 'Coach'.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Plan validation error
  final RxString planValidationError = ''.obs;

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
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Plan selection validation
  String? validatePlan() {
    if (selectedPlan.value.isEmpty) {
      return 'Please select a plan';
    }
    return null;
  }

  // Sign in method
  Future<void> signIn() async {
    // Validate email
    final emailError = validateEmail(emailController.text);
    if (emailError != null) {
      ToastClass.showCustomToast(emailError, type: ToastType.error);
      return;
    }

    // Validate password
    final passwordError = validatePassword(passwordController.text);
    if (passwordError != null) {
      ToastClass.showCustomToast(passwordError, type: ToastType.error);
      return;
    }

    try {
      isLoading.value = true;

      // TODO: Implement actual API call for authentication
      // For now, simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Clear controllers
      emailController.clear();
      passwordController.clear();

      isLoading.value = false;

      // Navigate to welcome screen on success
      Get.toNamed(AppRoutes.welcomeScreen);
    } catch (e) {
      isLoading.value = false;
      ToastClass.showCustomToast('Sign in failed. Please try again.', type: ToastType.error);
    }
  }

  // Sign up method
  Future<void> signUp() async {
    // Validate email
    final emailError = validateEmail(emailController.text);
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
    final passwordError = validatePassword(passwordController.text);
    if (passwordError != null) {
      ToastClass.showCustomToast(passwordError, type: ToastType.error);
      return;
    }

    // Validate plan selection
    final planError = validatePlan();
    if (planError != null) {
      ToastClass.showCustomToast(planError, type: ToastType.error);
      return;
    }

    try {
      isLoading.value = true;

      // TODO: Implement actual API call for registration
      // For now, simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Clear controllers
      emailController.clear();
      fullNameController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      isLoading.value = false;

      ToastClass.showCustomToast('Account created successfully!', type: ToastType.success);

      // Navigate to welcome screen on success
      Get.toNamed(AppRoutes.welcomeScreen);
    } catch (e) {
      isLoading.value = false;
      ToastClass.showCustomToast('Sign up failed. Please try again.', type: ToastType.error);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
