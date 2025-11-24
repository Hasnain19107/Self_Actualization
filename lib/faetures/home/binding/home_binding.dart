import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../../../core/bindings/user_binding.dart';
import '../../../core/controllers/user_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    // Initialize UserController if not already initialized
    if (!Get.isRegistered<UserController>()) {
      UserBinding().dependencies();
    }
  }
}
