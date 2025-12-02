import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/repository/achievement_repository.dart';
import '../../../data/models/achievement/achievement_model.dart';

class AchievementController extends GetxController {
  final AchievementRepository _achievementRepository = AchievementRepository();

  // Achievement data from API
  final Rx<AchievementModel?> achievementData = Rx<AchievementModel?>(null);
  final RxBool isLoading = false.obs;

  // Reactive getters for backward compatibility with existing UI
  String get currentBadge => 
      achievementData.value?.currentBadge.name ?? 'Bronze Badge';
  
  int get currentLevel => 
      achievementData.value?.currentBadge.level ?? 0;
  
  int get nextLevel => 
      achievementData.value?.badgeProgress.nextBadgeLevel ?? 0;
  
  int get currentPoints => 
      achievementData.value?.badgeProgress.currentPoints ?? 0;
  
  int get totalPoints => 
      achievementData.value?.badgeProgress.pointsRequired ?? 0;
  
  int get pointsToNext => 
      achievementData.value?.badgeProgress.pointsToNext ?? 0;

  // Individual achievement cards data (based on unlocked achievements and focus streak from API)
  List<Map<String, dynamic>> get achievements {
    if (achievementData.value == null) {
      return <Map<String, dynamic>>[];
    }

    final unlocked = achievementData.value!.unlockedAchievements;
    final focusStreak = achievementData.value!.focusStreak;
    final daysActive = achievementData.value!.activityCounts.daysActive;

    // Create achievement cards based on unlocked achievements, focus streak, and days active
    final List<Map<String, dynamic>> achievementList = [];

    // Get focus streak image based on streak days
    // 2 days → level1, 4 days → level2, 6 days → level3, 7+ days → level4
    String getFocusStreakImage(int streak) {
      if (streak >= 7) {
        return AppImages.focusStreakLevel4;
      } else if (streak >= 6) {
        return AppImages.focusStreakLevel3;
      } else if (streak >= 4) {
        return AppImages.focusStreakLevel2;
      } else if (streak <= 2) {
        return AppImages.focusStreakLevel1;
      } else {
        return AppImages.focusStreakLevel1; // Default to level1 for 1 day
      }
    }

    // Add Focus Streak achievement if focusStreak > 0
    if (focusStreak > 0) {
      final streakImage = getFocusStreakImage(focusStreak);

      achievementList.add({
        'imagePath': streakImage,
        'isCompleted': true,
        'title': 'Focus Streak',
        'subtitle': '$focusStreak ${focusStreak == 1 ? 'Day' : 'Days'}',
      });
    }

    // Add Days Active achievement if daysActive > 0
    if (daysActive > 0) {
      final activeImage = getFocusStreakImage(daysActive);

      achievementList.add({
        'imagePath': activeImage,
        'isCompleted': true,
        'title': 'Days Active',
        'subtitle': '$daysActive ${daysActive == 1 ? 'Day' : 'Days'}',
      });
    }

    // Add unlocked achievements from API
    for (var unlockedAchievement in unlocked) {
      achievementList.add({
        'imagePath': unlockedAchievement.iconUrl ?? AppImages.focusStreakLevel1,
        'isCompleted': true,
        'title': unlockedAchievement.name,
        'subtitle': unlockedAchievement.description,
      });
    }

    return achievementList;
  }

  double get progressPercentage {
    final progress = achievementData.value?.badgeProgress.progressPercentage ?? 0;
    return (progress / 100.0).clamp(0.0, 1.0);
  }

  @override
  void onInit() {
    super.onInit();
    fetchAchievements();
  }

  Future<void> fetchAchievements() async {
    isLoading.value = true;
    try {
      final response = await _achievementRepository.getAchievements();

      if (response.success && response.data != null) {
        achievementData.value = response.data;
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load achievements',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Error loading achievements: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
