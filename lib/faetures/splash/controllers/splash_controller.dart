import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/services/shared_preference_services.dart';

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

    if (isLoggedIn) {
      // Check if profile setup is completed
      final isProfileSetupCompleted = await PreferenceHelper.getBool(
        PrefConstants.isProfileSetupCompleted,
      ) ?? false;

      if (isProfileSetupCompleted) {
        // Profile setup is completed, navigate to main navigation screen
        Get.offNamed(AppRoutes.mainNavScreen);
      } else {
        // Profile setup not completed, navigate to welcome screen (or profile setup screen)
        Get.offNamed(AppRoutes.welcomeScreen);
      }
    } else {
      // User is not logged in, navigate to login screen
      Get.offNamed(AppRoutes.loginScreen);
    }
  }
}
