import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/models/goal/goal_model.dart';
import '../../../data/models/goal/goal_request_model.dart';
import '../../../data/repository/goal_repository.dart';

class GoalController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Add Goal Form Controllers
  final TextEditingController goalTitleController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxString selectedGoalType = 'Self'.obs;
  final RxString startDate = ''.obs;
  final RxString endDate = ''.obs;
  final RxInt characterCount = 0.obs;
  final int maxCharacters = 300;
  final RxBool isSaving = false.obs;

  final GoalRepository _goalRepository = GoalRepository();

  // Self-actualization categories (Survival at bottom)
  final List<String> goalTypes = ['Meta-Needs', 'Self', 'Social', 'Safety', 'Survival'];

  final RxList<GoalModel> goals = <GoalModel>[].obs;
  final RxBool isLoadingGoals = false.obs;
  final RxString selectedStatus = 'active'.obs;
  
  // Expanded goal tracking
  final RxSet<String> expandedGoalIds = <String>{}.obs;
  final RxMap<String, GoalModel> goalDetails = <String, GoalModel>{}.obs;
  final RxMap<String, bool> isLoadingGoalDetails = <String, bool>{}.obs;
  final RxMap<String, bool> isCompletingGoal = <String, bool>{}.obs;
  final RxMap<String, bool> isDeletingGoal = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    descriptionController.addListener(_updateCharacterCount);
    fetchGoals();
  }

  Future<void> fetchGoals({bool showLoader = true}) async {
    try {
      if (showLoader) isLoadingGoals.value = true;
      final response = await _goalRepository.getGoals(
        status: selectedStatus.value,
      );
      if (response.success && response.data != null) {
        goals.assignAll(response.data!);
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to fetch goals',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to fetch goals. Please try again.',
        type: ToastType.error,
      );
    } finally {
      if (showLoader) isLoadingGoals.value = false;
    }
  }

  void changeGoalStatus(String status) {
    if (selectedStatus.value == status) return;
    selectedStatus.value = status;
    fetchGoals();
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
  }

  void _updateCharacterCount() {
    characterCount.value = descriptionController.text.length;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onMicTap() {
    // Handle microphone tap for voice search
    ToastClass.showCustomToast('Voice search functionality', type: ToastType.simple);
  }

  void onAddNewGoal() {
    // Navigate to add goal screen
    Get.offNamed(AppRoutes.addGoalScreen);
  }

  void selectGoalType(String type) {
    selectedGoalType.value = type;
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yy').format(picked);
      startDateController.text = formattedDate;
      startDate.value = formattedDate;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yy').format(picked);
      endDateController.text = formattedDate;
      endDate.value = formattedDate;
    }
  }

  Future<void> saveGoal() async {
    if (goalTitleController.text.trim().isEmpty) {
      ToastClass.showCustomToast('Please enter goal title', type: ToastType.error);
      return;
    }
    if (startDateController.text.trim().isEmpty) {
      ToastClass.showCustomToast('Please select start date', type: ToastType.error);
      return;
    }
    if (endDateController.text.trim().isEmpty) {
      ToastClass.showCustomToast('Please select end date', type: ToastType.error);
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      ToastClass.showCustomToast('Please enter description', type: ToastType.error);
      return;
    }

    final startIso = _parseDateToIso(startDateController.text.trim());
    final endIso = _parseDateToIso(endDateController.text.trim());

    if (startIso == null || endIso == null) {
      ToastClass.showCustomToast('Invalid date format. Please pick valid dates.', type: ToastType.error);
      return;
    }

    final start = DateTime.parse(startIso);
    final end = DateTime.parse(endIso);
    if (end.isBefore(start)) {
      ToastClass.showCustomToast('End date must be after start date', type: ToastType.error);
      return;
    }

    final request = GoalRequestModel(
      title: goalTitleController.text.trim(),
      description: descriptionController.text.trim(),
      startDate: startIso,
      endDate: endIso,
      type: selectedGoalType.value,
    );

    try {
      isSaving.value = true;
      final response = await _goalRepository.createGoal(request);
      isSaving.value = false;

      if (response.success) {
        _clearForm();

        ToastClass.showCustomToast(
          response.message.isNotEmpty ? response.message : 'Goal saved successfully',
          type: ToastType.success,
        );

        await fetchGoals(showLoader: false);
        Get.offNamed(AppRoutes.goalScreen);
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty ? response.message : 'Failed to save goal',
          type: ToastType.error,
        );
      }
    } catch (e) {
      isSaving.value = false;
      ToastClass.showCustomToast(
        'Something went wrong. Please try again.',
        type: ToastType.error,
      );
    }
  }

  String _getEmojiForType(String type) {
    switch (type) {
      case 'Meta-Needs':
        return '🌟';
      case 'Self':
        return '✏️';
      case 'Social':
        return '💬';
      case 'Safety':
        return '💪';
      case 'Survival':
        return '😊';
      default:
        return '🎯';
    }
  }

  List<GoalModel> get currentGoals =>
      goals.where((goal) => !goal.isCompleted).take(3).toList();

  List<GoalModel> get filteredGoals {
    if (searchQuery.value.isEmpty) {
      return goals;
    }
    final query = searchQuery.value.toLowerCase();
    return goals.where((goal) {
      return goal.title.toLowerCase().contains(query) ||
          goal.type.toLowerCase().contains(query);
    }).toList();
  }

  String _formatDate(DateTime date) => DateFormat('dd/MM/yy').format(date);

  String _formatDateRange(GoalModel goal) =>
      '${DateFormat('dd MMM').format(goal.startDate)} - ${DateFormat('dd MMM').format(goal.endDate)}';

  Color _getBarColorForType(String type) {
    switch (type) {
      case 'Meta-Needs':
        return const Color(0xFFE9C6F2); // Purple
      case 'Self':
        return const Color(0xFFD3E85D); // Yellow-green
      case 'Social':
        return const Color(0xFF7AC4E6); // Blue
      case 'Safety':
        return const Color(0xFFFFCBA4); // Orange
      case 'Survival':
        return const Color(0xFFF9CFFD); // Pink
      default:
        return const Color(0xFFFFCBA4);
    }
  }

  Color barColorForGoal(GoalModel goal) => _getBarColorForType(goal.type);
  String emojiForGoal(GoalModel goal) => _getEmojiForType(goal.type);
  String formattedStartDate(GoalModel goal) => _formatDate(goal.startDate);
  String formattedDateRange(GoalModel goal) => _formatDateRange(goal);

  // Toggle goal expansion
  Future<void> toggleGoalExpansion(String goalId) async {
    if (expandedGoalIds.contains(goalId)) {
      // Collapse
      expandedGoalIds.remove(goalId);
    } else {
      // Expand - fetch goal details
      expandedGoalIds.add(goalId);
      await fetchGoalDetails(goalId);
    }
  }

  // Fetch goal details by ID
  Future<void> fetchGoalDetails(String goalId) async {
    // Check if already loaded
    if (goalDetails.containsKey(goalId)) {
      return;
    }

    try {
      isLoadingGoalDetails[goalId] = true;
      final response = await _goalRepository.getGoalById(goalId);

      if (response.success && response.data != null) {
        goalDetails[goalId] = response.data!;
        // Update the goal in the list if it exists
        final index = goals.indexWhere((g) => g.id == goalId);
        if (index != -1) {
          goals[index] = response.data!;
        }
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load goal details',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to load goal details. Please try again.',
        type: ToastType.error,
      );
    } finally {
      isLoadingGoalDetails[goalId] = false;
    }
  }

  // Get goal details (from cache or return goal from list)
  GoalModel? getGoalDetails(String goalId) {
    if (goalDetails.containsKey(goalId)) {
      return goalDetails[goalId];
    }
    // Fallback to goal from list
    try {
      return goals.firstWhere((g) => g.id == goalId);
    } catch (_) {
      return null;
    }
  }

  // Complete a goal
  Future<void> completeGoal(String goalId) async {
    try {
      isCompletingGoal[goalId] = true;
      final response = await _goalRepository.completeGoal(goalId);

      if (response.success) {
        // Update goal in list
        final index = goals.indexWhere((g) => g.id == goalId);
        if (index != -1 && response.data != null) {
          goals[index] = response.data!;
        }
        // Update in details cache
        if (response.data != null) {
          goalDetails[goalId] = response.data!;
        }
        // Collapse the card
        expandedGoalIds.remove(goalId);

        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Goal completed successfully',
          type: ToastType.success,
        );

        // Refresh goals list
        await fetchGoals(showLoader: false);
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to complete goal',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to complete goal. Please try again.',
        type: ToastType.error,
      );
    } finally {
      isCompletingGoal[goalId] = false;
    }
  }

  // Delete a goal
  Future<void> deleteGoal(String goalId) async {
    try {
      isDeletingGoal[goalId] = true;
      final response = await _goalRepository.deleteGoal(goalId);

      if (response.success) {
        // Remove from list
        goals.removeWhere((g) => g.id == goalId);
        // Remove from details cache
        goalDetails.remove(goalId);
        // Remove from expanded set
        expandedGoalIds.remove(goalId);

        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Goal deleted successfully',
          type: ToastType.success,
        );

        // Refresh goals list
        await fetchGoals(showLoader: false);
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to delete goal',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to delete goal. Please try again.',
        type: ToastType.error,
      );
    } finally {
      isDeletingGoal[goalId] = false;
    }
  }
  
  // Get chart segments from current goals (max 3 segments)
  List<Map<String, dynamic>> get chartSegments {
    final currentGoalsList = currentGoals;
    if (currentGoalsList.isEmpty) {
      return [];
    }
    
    // Take up to 3 goals for the chart
    final goalsForChart = currentGoalsList.take(3).toList();
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

  String? _parseDateToIso(String value) {
    if (value.isEmpty) return null;
    try {
      final parsed = DateFormat('dd/MM/yy').parseStrict(value);
      return parsed.toIso8601String();
    } catch (_) {
      return null;
    }
  }

  void _clearForm() {
    goalTitleController.clear();
    startDateController.clear();
    endDateController.clear();
    descriptionController.clear();
    characterCount.value = 0;
    startDate.value = '';
    endDate.value = '';
    selectedGoalType.value = 'Self';
  }

  @override
  void onClose() {
    searchController.dispose();
   
    super.onClose();
  }
}
