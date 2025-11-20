import 'package:get/get.dart';
import '../controller/review_result_controller.dart';

class ReviewResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReviewResultController());
  }
}
