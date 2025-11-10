import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/const/app_exports.dart';

class GoalController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Add Goal Form Controllers
  final TextEditingController goalTitleController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxString selectedGoalType = 'Personal'.obs;
  final RxString startDate = ''.obs;
  final RxString endDate = ''.obs;
  final RxInt characterCount = 0.obs;
  final int maxCharacters = 300;

  // Goal types
  final List<String> goalTypes = ['Career', 'Health', 'Personal', 'Spiritual'];

  // Current goals data
  final List<Map<String, dynamic>> currentGoals = [
    {
      'barColor': const Color(0xFFD3E85D), // Light green
      'title': '8h Work Target',
      'subtitle': 'Personal',
    },
    {
      'barColor': const Color(0xFF7AC4E6), // Light blue
      'title': 'Achieve 6.5h Sleep',
      'subtitle': 'Health',
    },
    {
      'barColor': const Color(0xFFE9C6F2), // Light pink/purple
      'title': '100 Calories Burn',
      'subtitle': 'Health',
    },
  ];

  // All goals data
  final RxList<Map<String, dynamic>> allGoals = <Map<String, dynamic>>[
    {
      'emoji': '🏃',
      'title': 'Daily Motivation',
      'category': 'Health',
      'date': '20/10/25',
    },
    {
      'emoji': '🧘',
      'title': 'Daily Motivation',
      'category': 'Spiritual',
      'date': '20/10/25',
    },
    {
      'emoji': '🧘',
      'title': 'Daily Motivation',
      'category': 'Spiritual',
      'date': '20/10/25',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    descriptionController.addListener(_updateCharacterCount);
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
    Get.toNamed(AppRoutes.addGoalScreen);
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

  void saveGoal() {
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

    // Add goal to allGoals list
    allGoals.add({
      'emoji': _getEmojiForType(selectedGoalType.value),
      'title': goalTitleController.text.trim(),
      'category': selectedGoalType.value,
      'date': startDateController.text.trim(),
    });

    // Clear form before navigating back
    goalTitleController.clear();
    startDateController.clear();
    endDateController.clear();
    descriptionController.clear();
    characterCount.value = 0;
    startDate.value = '';
    endDate.value = '';
    selectedGoalType.value = 'Personal';

    ToastClass.showCustomToast('Goal saved successfully', type: ToastType.success);
    Get.offNamed(AppRoutes.mainNavScreen, arguments: 2);
  }

  String _getEmojiForType(String type) {
    switch (type) {
      case 'Career':
        return '💼';
      case 'Health':
        return '🏃';
      case 'Personal':
        return '🎯';
      case 'Spiritual':
        return '🧘';
      default:
        return '🎯';
    }
  }

  List<Map<String, dynamic>> get filteredGoals {
    if (searchQuery.value.isEmpty) {
      return allGoals;
    }
    return allGoals.where((goal) {
      return goal['title'].toString().toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ||
          goal['category'].toString().toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
    }).toList();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
