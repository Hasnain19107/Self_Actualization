import 'package:get/get.dart';
import 'package:pixsa_petrol_pump/faetures/subscription/controllers/onboarding_controller.dart';


class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionController>(() => SubscriptionController());
  }
}
