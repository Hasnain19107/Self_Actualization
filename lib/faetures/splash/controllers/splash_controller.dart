import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
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

    if (isLoggedIn) {
      // User is logged in, navigate to welcome screen
      Get.offNamed(AppRoutes.welcomeScreen);
    } else {
      // User is not logged in, navigate to login screen
      Get.offNamed(AppRoutes.loginScreen);
    }
  }
}
