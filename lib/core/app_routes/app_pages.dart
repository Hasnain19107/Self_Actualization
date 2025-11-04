import 'package:pixsa_petrol_pump/faetures/OnBoarding/view/selectCategory_level.dart';
import 'package:pixsa_petrol_pump/faetures/auth/bindings/auth_binding.dart';
import 'package:pixsa_petrol_pump/faetures/auth/view/sign_in_screen.dart';
import 'package:pixsa_petrol_pump/faetures/auth/view/sign_up_screen.dart';
import 'package:pixsa_petrol_pump/faetures/auth/view/welcome_screen.dart';
import 'package:pixsa_petrol_pump/faetures/OnBoarding/bindings/onBoarding_binding.dart';

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

    GetPage(
      name: AppRoutes.LOGINSCREEN,
      page: () => SignInScreen(),
      binding: AuthBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),

    GetPage(
      name: AppRoutes.SIGNUPSCREEN,
      page: () => SignUpScreen(),
      binding: AuthBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),
    GetPage(
      name: AppRoutes.WELCOMESCREEN,
      page: () => WelcomeScreen(),

      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),

    GetPage(
      name: AppRoutes.Category_level_SCREEN,
      page: () => SelectCategoryLevelScreen(),
      binding: OnboardingBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),
  ];
}
