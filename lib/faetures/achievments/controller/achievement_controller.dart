import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class AchievementController extends GetxController {
  // Current achievement progress data
  final RxString currentBadge = 'Bronze Badge'.obs;
  final RxInt currentLevel = 2.obs;
  final RxInt nextLevel = 3.obs;
  final RxInt currentPoints = 5200.obs;
  final RxInt totalPoints = 6000.obs;
  final RxInt pointsToNext = 500.obs;

  // Individual achievement cards data
  final RxList<Map<String, dynamic>> achievements = <Map<String, dynamic>>[
    {
      'imagePath': AppImages.focusStreak1,
      'isCompleted': true,
      'title': 'Focus Streak',
      'subtitle': '7 Days',
    },
    {
      'imagePath': AppImages.focusStreak2,
      'isCompleted': false,
      'title': 'Focus Streak',
      'subtitle': '7 Days',
    },
    {
      'imagePath': AppImages.focusStreak3,
      'isCompleted': true,
      'title': 'Focus Streak',
      'subtitle': '7 Days',
    },
    {
      'imagePath': AppImages.focusStreak4,
      'isCompleted': false,
      'title': 'Focus Streak',
      'subtitle': '7 Days',
    },
  ].obs;

  double get progressPercentage {
    if (totalPoints.value == 0) return 0.0;
    return (currentPoints.value / totalPoints.value).clamp(0.0, 1.0);
  }

  @override
  void onInit() {
    super.onInit();
  }
}
