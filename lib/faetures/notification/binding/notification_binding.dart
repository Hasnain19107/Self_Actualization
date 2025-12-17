import 'package:get/get.dart';
import '../../../data/repository/notification_repository.dart';
import '../controller/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // Register repository if not already registered
    if (!Get.isRegistered<NotificationRepository>()) {
      Get.lazyPut(() => NotificationRepository());
    }

    // Register controller if not already registered
    if (!Get.isRegistered<NotificationController>()) {
      Get.lazyPut(() => NotificationController(
            repository: Get.find<NotificationRepository>(),
          ));
    }
  }
}
