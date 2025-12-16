import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/const/pref_consts.dart';
import '../../../core/controllers/user_controller.dart';
import '../../../data/models/goal/goal_model.dart';
import '../../../data/models/goal/goal_request_model.dart';
import '../../../data/models/goal/goal_need_model.dart';
import '../../../data/repository/goal_repository.dart';
import '../../../data/services/shared_preference_services.dart';

class GoalController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Add Goal Form Controllers
  final TextEditingController goalTitleController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxString selectedGoalType = 'Survival'.obs; // Default to Survival
  final RxString selectedNeedLabel = ''.obs; // Selected need label for goal title
  final Rx<GoalNeedModel?> selectedNeed = Rx<GoalNeedModel?>(null); // Selected need model
  final RxString startDate = ''.obs;
  final RxString endDate = ''.obs;
  final RxInt characterCount = 0.obs;
  final int maxCharacters = 300;
  final RxBool isSaving = false.obs;
  final RxBool isLoadingNeeds = false.obs;

  final GoalRepository _goalRepository = GoalRepository();

  // Self-actualization categories (Survival at bottom)
  final List<String> goalTypes = ['Meta-Needs', 'Self', 'Social', 'Safety', 'Survival'];
  
  // Needs list for selected category
  final RxList<GoalNeedModel> needsList = <GoalNeedModel>[].obs;

  final RxList<GoalModel> goals = <GoalModel>[].obs;
  final RxBool isLoadingGoals = false.obs;
  final RxString selectedStatus = 'active'.obs;
  
  // Expanded goal tracking
  final RxSet<String> expandedGoalIds = <String>{}.obs;
  final RxMap<String, GoalModel> goalDetails = <String, GoalModel>{}.obs;
  final RxMap<String, bool> isLoadingGoalDetails = <String, bool>{}.obs;
  final RxMap<String, bool> isCompletingGoal = <String, bool>{}.obs;
  final RxMap<String, bool> isDeletingGoal = <String, bool>{}.obs;
  
  // Coaching offer dismissed state
  final RxBool isCoachingOfferDismissed = false.obs;
  
  // Share to coach loading state
  final RxBool isSharingGoals = false.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    descriptionController.addListener(_updateCharacterCount);
    fetchGoals();
    
    // Check for arguments from recommendations (pre-fill form)
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final category = arguments['category'] as String?;
      final needLabel = arguments['needLabel'] as String?;
      
      if (category != null && category.isNotEmpty) {
        selectedGoalType.value = category;
        fetchNeedsByCategory(category);
        
        // If needLabel is provided, select it after needs are loaded
        if (needLabel != null && needLabel.isNotEmpty) {
          // Wait a bit for needs to load, then select the need
          Future.delayed(const Duration(milliseconds: 500), () {
            final need = needsList.firstWhereOrNull((n) => n.needLabel == needLabel);
            if (need != null) {
              selectNeed(need);
            } else {
              // If exact match not found, set the label directly
              selectedNeedLabel.value = needLabel;
              goalTitleController.text = needLabel;
            }
          });
        }
      } else {
        // Fetch needs for default category (Survival)
        fetchNeedsByCategory(selectedGoalType.value);
      }
    } else {
      // Fetch needs for default category (Survival)
      fetchNeedsByCategory(selectedGoalType.value);
    }
    
    // Refresh user data to check coaching offer eligibility
    _refreshUserDataForCoachingOffer();
    // Load coaching offer dismissed state
    _loadCoachingOfferDismissedState();
  }
  
  /// Load coaching offer dismissed state from SharedPreferences
  Future<void> _loadCoachingOfferDismissedState() async {
    try {
      final dismissed = await PreferenceHelper.getBool(PrefConstants.coachingOfferDismissed);
      if (dismissed != null) {
        isCoachingOfferDismissed.value = dismissed;
      }
    } catch (e) {
      DebugUtils.logError(
        'Error loading coaching offer dismissed state',
        tag: 'GoalController._loadCoachingOfferDismissedState',
        error: e,
      );
    }
  }

  Future<void> _refreshUserDataForCoachingOffer() async {
    if (Get.isRegistered<UserController>()) {
      final userController = Get.find<UserController>();
      await userController.refreshUserData();
    }
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
    if (selectedGoalType.value == type) return;
    selectedGoalType.value = type;
    selectedNeedLabel.value = ''; // Clear selected need when category changes
    selectedNeed.value = null; // Clear selected need model
    goalTitleController.clear(); // Clear goal title
    fetchNeedsByCategory(type);
  }

  /// Fetch needs by category from API
  Future<void> fetchNeedsByCategory(String category) async {
    try {
      isLoadingNeeds.value = true;
      final response = await _goalRepository.getNeedsByCategory(category);
      
      if (response.success && response.data != null) {
        needsList.assignAll(response.data!.data);
        // Sort by needOrder
        needsList.sort((a, b) => a.needOrder.compareTo(b.needOrder));
        // Auto-select first need if available
        if (needsList.isNotEmpty) {
          selectNeed(needsList.first);
        }
      } else {
        needsList.clear();
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to fetch needs',
          type: ToastType.error,
        );
      }
    } catch (e) {
      needsList.clear();
      ToastClass.showCustomToast(
        'Failed to fetch needs. Please try again.',
        type: ToastType.error,
      );
    } finally {
      isLoadingNeeds.value = false;
    }
  }

  /// Select a need (for goal title)
  void selectNeed(GoalNeedModel need) {
    selectedNeed.value = need;
    selectedNeedLabel.value = need.needLabel;
    goalTitleController.text = need.needLabel;
  }

  /// Select a need label (for goal title) - kept for backward compatibility
  void selectNeedLabel(String needLabel) {
    // Find the need model by label
    final need = needsList.firstWhereOrNull((n) => n.needLabel == needLabel);
    if (need != null) {
      selectNeed(need);
    } else {
      selectedNeedLabel.value = needLabel;
      goalTitleController.text = needLabel;
    }
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
    if (selectedNeedLabel.value.isEmpty) {
      ToastClass.showCustomToast('Please select a need for goal title', type: ToastType.error);
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
      title: selectedNeedLabel.value.isNotEmpty 
          ? selectedNeedLabel.value 
          : goalTitleController.text.trim(),
      description: descriptionController.text.trim(),
      startDate: startIso,
      endDate: endIso,
      type: selectedGoalType.value,
      needKey: selectedNeed.value?.needKey,
      needLabel: selectedNeed.value?.needLabel,
      needOrder: selectedNeed.value?.needOrder,
      questionId: selectedNeed.value?.questionId,
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
        
        // Check if this was the 3rd goal completion
        await _checkCoachingOfferEligibility();
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
    selectedGoalType.value = 'Survival';
    selectedNeedLabel.value = '';
    selectedNeed.value = null;
    fetchNeedsByCategory(selectedGoalType.value);
  }

  /// Check if user is eligible for coaching offer (completed 3 goals)
  bool get isCoachingOfferEligible {
    // Don't show if dismissed
    if (isCoachingOfferDismissed.value) {
      return false;
    }
    
    if (Get.isRegistered<UserController>()) {
      final userController = Get.find<UserController>();
      final user = userController.currentUser.value;
      
      // Check from user model first
      if (user?.coachingOfferEligible == true) {
        return true;
      }
      
      // Fallback: count completed goals
      final completedCount = user?.completedGoalsCount ?? 0;
      if (completedCount >= 3) {
        return true;
      }
      
      // Also check from goals list
      final completedGoals = goals.where((g) => g.isCompleted).length;
      return completedGoals >= 3;
    }
    
    // Fallback: count from goals list
    final completedGoals = goals.where((g) => g.isCompleted).length;
    return completedGoals >= 3;
  }
  
  /// Dismiss the coaching offer banner permanently
  Future<void> dismissCoachingOffer() async {
    try {
      isCoachingOfferDismissed.value = true;
      await PreferenceHelper.setBool(PrefConstants.coachingOfferDismissed, true);
    } catch (e) {
      DebugUtils.logError(
        'Error saving coaching offer dismissed state',
        tag: 'GoalController.dismissCoachingOffer',
        error: e,
      );
    }
  }

  /// Check coaching offer eligibility after goal completion
  Future<void> _checkCoachingOfferEligibility() async {
    // Refresh user data to get latest coachingOfferEligible status
    await _refreshUserDataForCoachingOffer();
  }

  /// Send coaching request email
  Future<void> requestCoachingSession() async {
    try {
      // Dismiss the banner when user taps on it
      await dismissCoachingOffer();
      
      final Email email = Email(
        body: 'Please provide my free coaching session valued at \$500 at 1pm. I will attend coaching session through zoom that you will be provide',
        subject: 'Free coaching value \$500',
        recipients: ['info@thecoachingcentre.com.au'],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
      
      ToastClass.showCustomToast(
        'Email opened successfully. Please send your request.',
        type: ToastType.success,
      );
    } catch (e) {
      DebugUtils.logError(
        'Error sending coaching request email: $e',
        tag: 'GoalController.requestCoachingSession',
        error: e,
      );
      
      ToastClass.showCustomToast(
        'Could not open email app. Please ensure an email account is set up.',
        type: ToastType.error,
      );
    }
  }

  /// Navigate to Learn and Grow screen with questionId
  void navigateToLearnAndGrow(String? questionId) {
    if (questionId == null || questionId.isEmpty) {
      ToastClass.showCustomToast(
        'No learning content available for this goal',
        type: ToastType.error,
      );
      return;
    }
    
    Get.toNamed(
      AppRoutes.learnGrowScreen,
      arguments: {'questionId': questionId},
    );
  }

  /// Show message when user tries to complete goal before end date
  void showGoalCompletionMessage(GoalModel goal) {
    final today = DateTime.now();
    final endDate = DateTime(
      goal.endDate.year,
      goal.endDate.month,
      goal.endDate.day,
    );
    final todayDate = DateTime(
      today.year,
      today.month,
      today.day,
    );
    
    if (endDate.isAfter(todayDate)) {
      final daysRemaining = endDate.difference(todayDate).inDays;
      final endDateFormatted = DateFormat('dd/MM/yyyy').format(goal.endDate);
      
      ToastClass.showCustomToast(
        'This goal can only be completed on or after $endDateFormatted. $daysRemaining day${daysRemaining == 1 ? '' : 's'} remaining.',
        type: ToastType.warning,
      );
    }
  }

  /// Share goals to coach via email
  Future<void> shareGoalsToCoach() async {
    if (isSharingGoals.value) return;

    try {
      isSharingGoals.value = true;

      if (goals.isEmpty) {
        ToastClass.showCustomToast(
          'No goals to share',
          type: ToastType.warning,
        );
        return;
      }

      // Format goals data for email body
      final emailBody = _formatGoalsForEmail();

      final Email email = Email(
        body: emailBody,
        subject: 'My Goals - Self-Actualization App',
        recipients: ['info@thecoachingcentre.com.au'],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);

      ToastClass.showCustomToast(
        'Email opened successfully. Please send your goals.',
        type: ToastType.success,
      );
    } catch (e) {
      DebugUtils.logError(
        'Error sharing goals to coach: $e',
        tag: 'GoalController.shareGoalsToCoach',
        error: e,
      );

      ToastClass.showCustomToast(
        'Could not open email app. Please ensure an email account is set up.',
        type: ToastType.error,
      );
    } finally {
      isSharingGoals.value = false;
    }
  }

  /// Format goals data for email body
  String _formatGoalsForEmail() {
    final buffer = StringBuffer();
    buffer.writeln('Hi Coach,');
    buffer.writeln('');
    buffer.writeln('Please find my goals below:');
    buffer.writeln('');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('');

    // Group goals by status
    final activeGoals = goals.where((g) => !g.isCompleted).toList();
    final completedGoals = goals.where((g) => g.isCompleted).toList();

    if (activeGoals.isNotEmpty) {
      buffer.writeln('ACTIVE GOALS:');
      buffer.writeln('');
      for (int i = 0; i < activeGoals.length; i++) {
        final goal = activeGoals[i];
        buffer.writeln('${i + 1}. ${goal.title}');
        buffer.writeln('   Type: ${goal.type}');
        buffer.writeln('   Description: ${goal.description}');
        buffer.writeln('   Start Date: ${_formatDate(goal.startDate)}');
        buffer.writeln('   End Date: ${_formatDate(goal.endDate)}');
        buffer.writeln('   Status: Active');
        buffer.writeln('');
      }
      buffer.writeln('');
    }

    if (completedGoals.isNotEmpty) {
      buffer.writeln('COMPLETED GOALS:');
      buffer.writeln('');
      for (int i = 0; i < completedGoals.length; i++) {
        final goal = completedGoals[i];
        buffer.writeln('${i + 1}. ${goal.title}');
        buffer.writeln('   Type: ${goal.type}');
        buffer.writeln('   Description: ${goal.description}');
        buffer.writeln('   Start Date: ${_formatDate(goal.startDate)}');
        buffer.writeln('   End Date: ${_formatDate(goal.endDate)}');
        buffer.writeln('   Status: Completed');
        buffer.writeln('');
      }
      buffer.writeln('');
    }

    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('');
    buffer.writeln('Total Goals: ${goals.length}');
    buffer.writeln('Active: ${activeGoals.length}');
    buffer.writeln('Completed: ${completedGoals.length}');
    buffer.writeln('');
    buffer.writeln('Regards,');

    return buffer.toString();
  }

  @override
  void onClose() {
    searchController.clear();
   
    super.onClose();
  }
}
