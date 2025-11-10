import 'package:get/get.dart';
import '../controller/plan_details_controller.dart';

/// Binding for Plan Details Screen
class PlanDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanDetailsController>(
      () => PlanDetailsController(),
    );
  }
}

