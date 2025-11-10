import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    await goNext();
    super.onInit();
  }

  Future<void> goNext() async {
    await Future.delayed(
      Duration(seconds: 3),
      () => Get.toNamed(AppRoutes.loginScreen),
    );
  }
}
