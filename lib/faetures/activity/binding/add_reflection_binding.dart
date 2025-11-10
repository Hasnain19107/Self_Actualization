import 'package:get/get.dart';
import '../controller/add_reflection_controller.dart';

class AddReflectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddReflectionController());
  }
}
