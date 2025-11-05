import 'package:get/get.dart';
import '../controller/your_activity_controller.dart';

class YourActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YourActivityController());
  }
}
