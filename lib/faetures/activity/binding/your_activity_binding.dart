import 'package:get/get.dart';
import '../controller/your_activity_controller.dart';
import '../controller/daily_reflection_controller.dart';
import '../../achievments/controller/achievement_controller.dart';

class YourActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YourActivityController());
    // Initialize DailyReflectionController to access reflections data
    if (!Get.isRegistered<DailyReflectionController>()) {
      Get.lazyPut(() => DailyReflectionController());
    }
    // Initialize AchievementController to access focus streak data
    if (!Get.isRegistered<AchievementController>()) {
      Get.lazyPut(() => AchievementController());
    }
  }
}
