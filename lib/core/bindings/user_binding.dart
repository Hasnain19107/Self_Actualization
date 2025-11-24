import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    // Use permanent: true so it persists across navigation
    Get.put(UserController(), permanent: true);
  }
}

