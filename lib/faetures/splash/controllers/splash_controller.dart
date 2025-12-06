import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/controllers/user_controller.dart';
import '../../../data/repository/user_repository.dart';

class SplashController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  @override
  void onInit() async {
    await goNext();
    super.onInit();
  }

  Future<void> goNext() async {
    // Wait for splash screen display
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is logged in
    final isLoggedIn = await _userRepository.isLoggedIn();

    if (!isLoggedIn) {
      // User is not logged in, navigate to login screen
      Get.offNamed(AppRoutes.loginScreen);
      return;
    }

    // User is logged in, check if they have completed assessment
    // Initialize UserController to fetch user data
    if (!Get.isRegistered<UserController>()) {
      Get.put(UserController(), permanent: true);
    }
    
    final userController = Get.find<UserController>();
    // Wait for user data to be fetched (force fetch even if already fetched)
    await userController.refreshUserData();
    
    // Wait for loading to complete
    while (userController.isLoadingUser.value) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    
    // Check if user has completed assessment
    final user = userController.currentUser.value;
    final hasCompletedAssessment = user?.hasCompletedAssessment == true;
    
    DebugUtils.logInfo(
      'Splash navigation check - hasCompletedAssessment: $hasCompletedAssessment, user: ${user?.name ?? "null"}, hasCompletedAssessment value: ${user?.hasCompletedAssessment}',
      tag: 'SplashController.goNext',
    );

    if (hasCompletedAssessment) {
      // User has completed assessment, navigate to main navigation screen
      Get.offNamed(AppRoutes.mainNavScreen);
    } else {
      // User hasn't completed assessment, navigate to welcome screen for onboarding
      Get.offNamed(AppRoutes.welcomeScreen);
    }
  }
}
