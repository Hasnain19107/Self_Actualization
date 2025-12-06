import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/models/goal/goal_model.dart';
import '../../../data/repository/goal_repository.dart';
import 'daily_reflection_controller.dart';

class YourActivityController extends GetxController {
  final GoalRepository _goalRepository = GoalRepository();
  
  // Current week start (always current week, no navigation)
  DateTime get currentWeekStart => _getWeekStart(DateTime.now());
  
  // Selected date (reactive)
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  
  // Goals from API
  final RxList<GoalModel> allGoals = <GoalModel>[].obs;
  final RxList<GoalModel> goals = <GoalModel>[].obs;
  final RxBool isLoadingGoals = false.obs;
  
  // Error state
  final RxString errorMessage = ''.obs;
  
  // Get current week dates (7 days starting from Monday)
  List<Map<String, dynamic>> get dates {
    final weekStart = currentWeekStart;
    final List<Map<String, dynamic>> weekDates = [];
    
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final isToday = _isSameDay(date, DateTime.now());
      final dayName = _getDayName(date.weekday);
      final dayNumber = date.day;
      final monthAbbr = _getMonthAbbr(date.month);
      
      weekDates.add({
        'date': date,
        'displayText': isToday ? 'Today, $dayNumber $monthAbbr' : '$dayNumber',
        'dayName': dayName,
        'isToday': isToday,
      });
    }
    
    return weekDates;
  }
  
  
  // Get moods from DailyReflectionController
  List<Map<String, dynamic>> get moodsWithReflections {
    if (!Get.isRegistered<DailyReflectionController>()) {
      return [];
    }
    final reflectionController = Get.find<DailyReflectionController>();
    return reflectionController.moodsWithReflections;
  }
  
  // Get loading state from DailyReflectionController
  bool get isLoadingReflections {
    if (!Get.isRegistered<DailyReflectionController>()) {
      return false;
    }
    final reflectionController = Get.find<DailyReflectionController>();
    return reflectionController.isLoadingReflections.value;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize selected date to today
    selectedDate.value = DateTime.now();
    fetchGoals();
  }
  
  // Get week start (Monday)
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday; // 1 = Monday, 7 = Sunday
    return date.subtract(Duration(days: weekday - 1));
  }
  
  // Check if two dates are the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
  
  // Private helper for internal use
  bool _isSameDay(DateTime date1, DateTime date2) => isSameDay(date1, date2);
  
  // Get day name abbreviation
  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
  
  // Select a specific date (only updates selection, doesn't change week)
  void selectDate(DateTime date) {
    selectedDate.value = date;
    _filterGoalsForSelectedDate();
  }

  Future<void> fetchGoals() async {
    try {
      isLoadingGoals.value = true;
      errorMessage.value = ''; // Clear error on retry
      final response = await _goalRepository.getGoals(status: 'active');
      
      isLoadingGoals.value = false;
      
      if (response.success && response.data != null) {
        allGoals.assignAll(response.data!);
        _filterGoalsForSelectedDate();
      } else {
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Failed to load goals';
        DebugUtils.logWarning(
          'Failed to fetch goals: ${response.message}',
          tag: 'YourActivityController.fetchGoals',
        );
      }
    } catch (e) {
      isLoadingGoals.value = false;
      errorMessage.value = 'An error occurred. Please try again.';
      DebugUtils.logError(
        'Error fetching goals',
        tag: 'YourActivityController.fetchGoals',
        error: e,
      );
    }
  }
  
  // Filter goals for the selected date
  void _filterGoalsForSelectedDate() {
    final selected = selectedDate.value;
    final selectedDateOnly = DateTime(selected.year, selected.month, selected.day);
    
    goals.value = allGoals.where((goal) {
      // Check if goal is active on the selected date
      // Goal is active if: selected date is between start date and end date (inclusive)
      final goalStart = DateTime(goal.startDate.year, goal.startDate.month, goal.startDate.day);
      final goalEnd = DateTime(goal.endDate.year, goal.endDate.month, goal.endDate.day);
      
      // Check if selected date is within goal date range (inclusive)
      return selectedDateOnly.isAfter(goalStart.subtract(const Duration(days: 1))) &&
          selectedDateOnly.isBefore(goalEnd.add(const Duration(days: 1)));
    }).toList();
  }

  // Get current goals (up to 3 goals for selected date, matching chart)
  List<GoalModel> get currentGoals => goals.take(3).toList();

  // Get bar color for goal type
  Color barColorForGoal(GoalModel goal) {
    switch (goal.type) {
      case 'Career':
        return const Color(0xFFD3E85D);
      case 'Health':
        return const Color(0xFF7AC4E6);
      case 'Spiritual':
        return const Color(0xFFE9C6F2);
      case 'Personal':
      default:
        return const Color(0xFFFFCBA4);
    }
  }
  
  // Get chart segments from goals (max 3 segments)
  List<Map<String, dynamic>> get chartSegments {
    if (goals.isEmpty) {
      return [];
    }
    
    // Take up to 3 goals for the chart
    final goalsForChart = goals.take(3).toList();
    final totalGoals = goalsForChart.length;
    
    // Calculate sweep angle per segment (360 degrees total)
    final sweepAnglePerSegment = 360.0 / totalGoals;
    
    return goalsForChart.asMap().entries.map((entry) {
      final index = entry.key;
      final goal = entry.value;
      
      return {
        'sweepAngle': sweepAnglePerSegment,
        'color': barColorForGoal(goal),
        'goalType': goal.type, // Pass goal type so widget can determine icon
        'angle': -90 + (index * sweepAnglePerSegment) + (sweepAnglePerSegment / 2), // Center of segment
      };
    }).toList();
  }

  // Format date range for goal
  String formattedDateRange(GoalModel goal) {
    final start = goal.startDate;
    final end = goal.endDate;
    return '${start.day} ${_getMonthAbbr(start.month)} - ${end.day} ${_getMonthAbbr(end.month)}';
  }

  String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  // Get focus streak from AchievementController (reactive)
  // This getter observes AchievementController's achievementData
  int get focusStreak {
    if (!Get.isRegistered<AchievementController>()) {
      return 0;
    }
    try {
      final achievementController = Get.find<AchievementController>();
      // Access the reactive value to make this getter reactive when used in Obx
      final achievementData = achievementController.achievementData.value;
      return achievementData?.focusStreak ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Get focus streak image based on streak days
  String getFocusStreakImage(int streak) {
    if (streak >= 7) {
      return AppImages.focusStreakLevel4;
    } else if (streak >= 6) {
      return AppImages.focusStreakLevel3;
    } else if (streak >= 4) {
      return AppImages.focusStreakLevel2;
    } else if (streak >= 2) {
      return AppImages.focusStreakLevel1;
    } else {
      return AppImages.focusStreakLevel1; // Default to level1
    }
  }

  // Activity cards data with focus streak from API
  List<Map<String, dynamic>> get activityCardsData {
    final streak = focusStreak;
    final streakText = streak > 0 ? '$streak ${streak == 1 ? 'Day' : 'Days'}' : '0 Days';
    
    return [
      {
        'icon1': Icons.flash_on,
        'icon1Color': Colors.orange,
        'icon2': Icons.star_border,
        'icon2Color': Colors.grey,
        'title': 'Focus Streak',
        'subtitle': streakText,
      },
      {
        'icon1': Icons.sentiment_satisfied_alt,
        'icon1Color': Colors.yellow,
        'icon2': Icons.add,
        'icon2Color': Colors.white,
        'icon2BgColor': Colors.blue,
        'title': 'Daily Reflection & Journaling',
        'subtitle': '', // No subtitle for this card
      },
    ];
  }

  /// Refresh all data (goals, achievements, reflections)
  Future<void> refreshData() async {
    await fetchGoals();
    
    // Refresh achievements if controller exists
    if (Get.isRegistered<AchievementController>()) {
      final achievementController = Get.find<AchievementController>();
      achievementController.refreshData();
    }
    
    // Refresh reflections if controller exists
    if (Get.isRegistered<DailyReflectionController>()) {
      final reflectionController = Get.find<DailyReflectionController>();
      reflectionController.fetchReflections();
    }
  }
}
