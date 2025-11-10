import 'package:get/get.dart';
import '../controller/daily_reflection_controller.dart';

class DailyReflectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DailyReflectionController());
  }
}
