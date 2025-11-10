import 'package:get/get.dart';
import '../controller/learn_grow_controller.dart';

class LearnGrowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LearnGrowController());
  }
}
