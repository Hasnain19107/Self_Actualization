import 'package:get/get.dart';
import 'package:self_actualisation/faetures/subscription/controllers/subscription_controller.dart';


class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionController>(() => SubscriptionController());
  }
}
