import 'package:get/get.dart';
import 'package:pixsa_petrol_pump/core/app_routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() async{
    await goNext();
    super.onInit();
  }

  Future<void> goNext() async {
    await Future.delayed(
      Duration(seconds: 3),
      () => Get.toNamed(AppRoutes.LOGINSCREEN),
    );
  }
}
