import 'package:get/get.dart';
import '../controller/goal_controller.dart';

class GoalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GoalController());
  }
}
