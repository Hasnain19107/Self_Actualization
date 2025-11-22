import 'package:pixsa_petrol_pump/faetures/auth/bindings/auth_binding.dart';
import 'package:pixsa_petrol_pump/faetures/auth/view/sign_in_screen.dart';
import 'package:pixsa_petrol_pump/faetures/auth/view/sign_up_screen.dart';
import 'package:pixsa_petrol_pump/faetures/auth/view/forgot_password_screen.dart';
import 'package:pixsa_petrol_pump/faetures/auth/view/welcome_screen.dart';
import '../../faetures/On_boarding/bindings/onBoarding_binding.dart';
import '../../faetures/On_boarding/view/selectCategory_level.dart';
import '../../faetures/On_boarding/view/select_plan.dart';
import '../../faetures/self_assessment/view/self_assessment.dart';
import '../../faetures/self_assessment/binding/self_assessment_binding.dart';
import '../../faetures/self_assessment/view/review_result_screen.dart';
import '../../faetures/On_boarding/view/profileSetup_screen.dart';
import '../../faetures/splash/bindings/splash_binding.dart';
import '../../faetures/splash/view/splash_screen.dart';
import '../../faetures/bottom_navigation_bar/view/main_nav_screen.dart';
import '../../faetures/home/view/home_screen.dart';
import '../../faetures/activity/view/your_activity_screen.dart';
import '../../faetures/activity/view/daily_reflection_screen.dart';
import '../../faetures/activity/binding/daily_reflection_binding.dart';
import '../../faetures/activity/view/add_reflection_screen.dart';
import '../../faetures/goal/view/goal_screen.dart';
import '../../faetures/goal/binding/goal_binding.dart';
import '../../faetures/achievments/view/achivement_screen.dart';
import '../../faetures/achievments/binding/achievement_binding.dart';
import '../../faetures/goal/view/add_goal.dart';
import '../../faetures/learn_grow/view/learn_grow_screen.dart';
import '../../faetures/learn_grow/binding/binding.dart' as learn_grow_binding;
import '../../faetures/notification/view/notification_screen.dart';
import '../../faetures/notification/binding/notification_binding.dart';
import '../../faetures/bottom_navigation_bar/bindings/bottom_nav_binding.dart';
import '../../faetures/home/binding/home_binding.dart';
import '../../faetures/activity/binding/your_activity_binding.dart';
import '../../faetures/subscription/view/plan_details_screen.dart';
import '../../faetures/subscription/binding/plan_details_binding.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.zoom,
      transitionDuration: const Duration(microseconds: 300),
    ),

    GetPage(
      name: AppRoutes.loginScreen,
      page: () => SignInScreen(),
      binding: AuthBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),

    GetPage(
      name: AppRoutes.signUpScreen,
      page: () => SignUpScreen(),
      binding: AuthBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),
    GetPage(
      name: AppRoutes.forgotPasswordScreen,
      page: () => ForgotPasswordScreen(),
      binding: AuthBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),
    GetPage(
      name: AppRoutes.welcomeScreen,
      page: () => WelcomeScreen(),

      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),

    GetPage(
      name: AppRoutes.selectPlanScreen,
      page: () => const SelectPlanScreen(),
      binding: OnboardingBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),

    GetPage(
      name: AppRoutes.categoryLevelScreen,
      page: () => SelectCategoryLevelScreen(),
      binding: OnboardingBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),

    GetPage(
      name: AppRoutes.selfAssessmentScreen,
      page: () => SelfAssessmentScreen(),
      binding: SelfAssessmentBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),

    GetPage(
      name: AppRoutes.reviewResultScreen,
      page: () => ReviewResultScreen(),
      binding: OnboardingBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),

    GetPage(
      name: AppRoutes.profileSetupScreen,
      page: () => ProfileSetupScreen(),
      binding: OnboardingBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(microseconds: 300),
    ),

    GetPage(
      name: AppRoutes.mainNavScreen,
      page: () => const MainNavScreen(),
      binding: BottomNavBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.homeScreen,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.yourActivityScreen,
      page: () => YourActivityScreen(),
      binding: YourActivityBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.dailyReflectionScreen,
      page: () => DailyReflectionScreen(),
      binding: DailyReflectionBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.addReflectionScreen,
      page: () => AddReflectionScreen(),
      binding: DailyReflectionBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.goalScreen,
      page: () => const GoalScreen(),
      binding: GoalBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.achievementScreen,
      page: () => const AchievementScreen(),
      binding: AchievementBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.addGoalScreen,
      page: () => const AddGoalScreen(),
      binding: GoalBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.learnGrowScreen,
      page: () => LearnGrowScreen(),
      binding: learn_grow_binding.LearnGrowBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.notificationScreen,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.planDetailsScreen,
      page: () => const PlanDetailsScreen(),
      binding: PlanDetailsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
