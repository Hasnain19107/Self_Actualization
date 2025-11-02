import '../../faetures/splash/bindings/splash_binding.dart';
import '../../faetures/splash/view/splash_screen.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.SPLASHSCREEN,
      page: () => SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.zoom,
      transitionDuration: const Duration(microseconds: 300),
    ),
  ];
}
