import 'package:get/get.dart';
import '../controller/bottom_nav_controller.dart';
import '../../../core/bindings/user_binding.dart';
import '../../../core/controllers/user_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavController());
    // Initialize UserController if not already initialized
    if (!Get.isRegistered<UserController>()) {
      UserBinding().dependencies();
    }
  }
}
