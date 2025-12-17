import 'package:get/get.dart';
import '../controller/needs_report_controller.dart';

class NeedsReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NeedsReportController());
  }
}

