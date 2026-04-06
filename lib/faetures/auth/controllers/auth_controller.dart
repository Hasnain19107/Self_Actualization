import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/controllers/user_controller.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/models/user/register_request_model.dart';
import '../../../data/models/user/login_request_model.dart';
import '../../../data/services/fcm_service.dart';

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
        final user = response.data!;
        
        // Clear controllers
        signinEmailController.clear();
        signinPasswordController.clear();

        // Initialize or refresh UserController to fetch user data
        if (!Get.isRegistered<UserController>()) {
          // Initialize UserController if not registered
          Get.put(UserController(), permanent: true);
        } else {
          // Refresh user data if already registered
          final userController = Get.find<UserController>();
          await userController.refreshUserData();
        }

        // Save FCM token to backend after successful login
        try {
          final fcmService = FcmService();
          if (fcmService.currentToken != null) {
            await fcmService.saveTokenToBackend(fcmService.currentToken!);
          } else {
            // Initialize FCM if not already done
            await fcmService.initialize();
          }
        } catch (e) {
          // FCM token save failed, but login should still succeed
          debugPrint('Failed to save FCM token after login: $e');
        }

        // Show success message
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Login successful',
          type: ToastType.success,
        );

        // Check if user has subscription and completed assessment
        final hasSubscription = user.currentSubscriptionType != null && 
                               user.currentSubscriptionType!.isNotEmpty;
        final hasCompletedAssessment = user.hasCompletedAssessment == true;

        // Navigate based on user status
        if (hasSubscription && hasCompletedAssessment) {
          // Navigate directly to main navigation screen
          Get.offAllNamed(AppRoutes.mainNavScreen);
        } else {
          // Navigate to welcome screen for onboarding
          Get.offAllNamed(AppRoutes.welcomeScreen);
        }
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
        Get.offAllNamed(AppRoutes.welcomeScreen);
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

  // Google Sign-In method using Firebase Auth
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // Get GoogleSignIn instance (singleton in version 7.x)
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      // Initialize if not already initialized
      try {
        await googleSignIn.initialize();
      } catch (e) {
        // Already initialized, continue
        DebugUtils.logInfo('GoogleSignIn already initialized', tag: 'AuthController.signInWithGoogle');
      }

      // Sign out first to ensure fresh sign-in
      try {
        await googleSignIn.signOut();
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        // Ignore sign out errors
        DebugUtils.logWarning('Google/Firebase sign out error: $e', tag: 'AuthController.signInWithGoogle');
      }

      // Trigger the authentication flow (authenticate replaces signIn in 7.x)
      final googleUser = await googleSignIn.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Get access token from authorization client (for version 7.x)
      String? accessToken;
      try {
        final authorization = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);
        accessToken = authorization.accessToken;
      } catch (e) {
        DebugUtils.logWarning('Failed to get access token: $e', tag: 'AuthController.signInWithGoogle');
      }

      // Create a new credential for Firebase (idToken is required, accessToken is optional)
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: accessToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        isLoading.value = false;
        ToastClass.showCustomToast(
          'Google sign-in failed. Please try again.',
          type: ToastType.error,
        );
        return;
      }

      // Sync Firebase user with our API (JWT issued by backend)
      final response = await _userRepository.loginWithFirebase(firebaseUser);

      isLoading.value = false;

      if (response.success && response.data != null) {
        final user = response.data!;

        // Clear any existing form controllers
        signinEmailController.clear();
        signinPasswordController.clear();

        // Initialize or refresh UserController
        if (!Get.isRegistered<UserController>()) {
          Get.put(UserController(), permanent: true);
        } else {
          final userController = Get.find<UserController>();
          await userController.refreshUserData();
        }

        // Save FCM token
        try {
          final fcmService = FcmService();
          if (fcmService.currentToken != null) {
            await fcmService.saveTokenToBackend(fcmService.currentToken!);
          } else {
            await fcmService.initialize();
          }
        } catch (e) {
          debugPrint('Failed to save FCM token after Google login: $e');
        }

        // Show success message
        ToastClass.showCustomToast(
          'Signed in with Google successfully',
          type: ToastType.success,
        );

        // Navigate based on user status
        final hasSubscription = user.currentSubscriptionType != null && 
                               user.currentSubscriptionType!.isNotEmpty;
        final hasCompletedAssessment = user.hasCompletedAssessment == true;

        if (hasSubscription && hasCompletedAssessment) {
          Get.offAllNamed(AppRoutes.mainNavScreen);
        } else {
          Get.offAllNamed(AppRoutes.welcomeScreen);
        }
      } else {
        // Sign out from Google and Firebase if backend login failed
        try {
          await googleSignIn.signOut();
          await FirebaseAuth.instance.signOut();
        } catch (e) {
          DebugUtils.logWarning('Google/Firebase sign out error: $e', tag: 'AuthController.signInWithGoogle');
        }

        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Google sign-in failed. Please try again.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      isLoading.value = false;
      DebugUtils.logError(
        'Google sign-in error',
        tag: 'AuthController.signInWithGoogle',
        error: e,
      );

      ToastClass.showCustomToast(
        'Google sign-in failed. Please try again.',
        type: ToastType.error,
      );
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Sign in with Apple (Firebase Auth), then sync with backend OAuth.
  Future<void> signInWithApple() async {
    try {
      isLoading.value = true;

      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final idToken = appleCredential.identityToken;
      if (idToken == null || idToken.isEmpty) {
        isLoading.value = false;
        ToastClass.showCustomToast(
          'Sign in with Apple failed. Please try again.',
          type: ToastType.error,
        );
        return;
      }

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: idToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        isLoading.value = false;
        ToastClass.showCustomToast(
          'Sign in with Apple failed. Please try again.',
          type: ToastType.error,
        );
        return;
      }

      String? appleDisplayName;
      final gn = appleCredential.givenName;
      final fn = appleCredential.familyName;
      if ((gn != null && gn.isNotEmpty) || (fn != null && fn.isNotEmpty)) {
        appleDisplayName = '${gn ?? ''} ${fn ?? ''}'.trim();
      }

      final response = await _userRepository.loginWithFirebase(
        firebaseUser,
        nameOverride: appleDisplayName,
      );

      isLoading.value = false;

      if (response.success && response.data != null) {
        final user = response.data!;

        signinEmailController.clear();
        signinPasswordController.clear();

        if (!Get.isRegistered<UserController>()) {
          Get.put(UserController(), permanent: true);
        } else {
          final userController = Get.find<UserController>();
          await userController.refreshUserData();
        }

        try {
          final fcmService = FcmService();
          if (fcmService.currentToken != null) {
            await fcmService.saveTokenToBackend(fcmService.currentToken!);
          } else {
            await fcmService.initialize();
          }
        } catch (e) {
          debugPrint('Failed to save FCM token after Apple login: $e');
        }

        ToastClass.showCustomToast(
          'Signed in with Apple successfully',
          type: ToastType.success,
        );

        final hasSubscription = user.currentSubscriptionType != null &&
            user.currentSubscriptionType!.isNotEmpty;
        final hasCompletedAssessment = user.hasCompletedAssessment == true;

        if (hasSubscription && hasCompletedAssessment) {
          Get.offAllNamed(AppRoutes.mainNavScreen);
        } else {
          Get.offAllNamed(AppRoutes.welcomeScreen);
        }
      } else {
        try {
          await FirebaseAuth.instance.signOut();
        } catch (e) {
          DebugUtils.logWarning(
            'Firebase sign out error: $e',
            tag: 'AuthController.signInWithApple',
          );
        }

        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Sign in with Apple failed. Please try again.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      isLoading.value = false;
      DebugUtils.logError(
        'Apple sign-in error',
        tag: 'AuthController.signInWithApple',
        error: e,
      );

      ToastClass.showCustomToast(
        'Sign in with Apple failed. Please try again.',
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
