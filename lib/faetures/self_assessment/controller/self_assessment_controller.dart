import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/models/question/question_model.dart';
import '../../../data/models/question/assessment_submission_model.dart';
import '../../../data/repository/question_repository.dart';
import '../../../data/repository/subscription_repository.dart';

class SelfAssessmentController extends GetxController {
  static const List<String> _questionCategoryOrder = [
    'Survival',
    'Safety',
    'Social',
    'Self',
    'Meta-Needs',
  ];

  // Repositories
  final QuestionRepository _questionRepository = QuestionRepository();
  final SubscriptionRepository _subscriptionRepository = SubscriptionRepository();

  // Questions list
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;
  
  // Selected categories for fetching questions
  final RxList<String> selectedCategories = <String>[].obs;
  
  // Available categories from subscription
  final RxList<String> availableCategories = <String>[].obs;
  
  // Loading state for categories
  final RxBool isLoadingCategories = false.obs;
  
  // Current question index
  final RxInt currentQuestionIndex = 0.obs;
  
  // Selected rating for current question
  final RxInt selectedRating = 5.obs;
  
  // Answers storage (questionId -> selectedOption)
  final RxMap<String, int> answers = <String, int>{}.obs;
  
  // Drag state
  final RxBool isDragging = false.obs;
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // Submission loading state
  final RxBool isSubmitting = false.obs;

  // Rating scale descriptions
  final Map<int, String> ratingDescriptions = {
    1: 'Not at all true',
    2: 'Rarely true',
    3: 'Sometimes true',
    4: 'Often true',
    5: 'Usually true',
    6: 'Almost always true',
    7: 'Completely true',
  };

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
  }
  
  /// Initialize and fetch questions when navigating to self assessment screen
  void initializeForAssessment() {
    _initializeFromArguments();
    fetchQuestions();
  }

  /// Initialize selected categories from arguments
  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      final categories = args['selectedCategories'] as List<dynamic>?;
      if (categories != null) {
        selectedCategories.value = categories.cast<String>();
      }
    }
  }

  /// Fetch questions from API using selected categories
  Future<void> fetchQuestions() async {
    isLoading.value = true;
    try {
      // If categories are provided, use them; otherwise fall back to old behavior
      if (selectedCategories.isNotEmpty) {
        final response = await _questionRepository.getQuestions(
          categories: selectedCategories.toList(),
          limit: 100,
          page: 1,
        );

        if (response.success && response.data != null) {
          questions.value = response.data!;
        } else {
          final message = response.message.isNotEmpty
              ? response.message
              : 'Failed to load questions';
          throw Exception(message);
        }
      } else {
        // Fallback: fetch all categories (old behavior)
        final List<QuestionModel> fetchedQuestions = [];

        for (final category in _questionCategoryOrder) {
          final response =
              await _questionRepository.getQuestions(category: category);

          if (response.success && response.data != null) {
            fetchedQuestions.addAll(response.data!);
          } else {
            final message = response.message.isNotEmpty
                ? response.message
                : 'Failed to load $category questions';
            throw Exception(message);
          }
        }

        questions.value = fetchedQuestions;
      }

      currentQuestionIndex.value = 0;
      loadAnswerForCurrentQuestion();
    } catch (e) {
      ToastClass.showCustomToast(
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Failed to load questions. Please try again.',
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get current question
  QuestionModel? get currentQuestion {
    if (currentQuestionIndex.value >= 0 &&
        currentQuestionIndex.value < questions.length) {
      return questions[currentQuestionIndex.value];
    }
    return null;
  }

  /// Get current question text
  String get currentQuestionText {
    return currentQuestion?.questionText ?? '';
  }

  /// Current question category
  String get currentQuestionCategory {
    return currentQuestion?.category ?? '';
  }

  /// Get total questions count
  int get totalQuestions => questions.length;

  /// Get progress text
  String get progressText {
    if (totalQuestions == 0) return '0 of 0';
    return '${currentQuestionIndex.value + 1} of $totalQuestions';
  }

  /// Select rating for current question
  void selectRating(int rating) {
    selectedRating.value = rating;
    saveAnswer();
  }

  /// Save answer for current question
  void saveAnswer() {
    final question = currentQuestion;
    if (question == null) return;

    // Save answer (will overwrite if exists)
    answers[question.id] = selectedRating.value;
  }

  /// Load answer for current question
  void loadAnswerForCurrentQuestion() {
    final question = currentQuestion;
    if (question == null) {
      selectedRating.value = 5; // Default
      return;
    }

    // Get existing answer for this question
    final existingAnswer = answers[question.id];

    if (existingAnswer != null) {
      selectedRating.value = existingAnswer;
    } else {
      selectedRating.value = 5; // Default
    }
  }

  /// Move to next question
  Future<void> nextQuestion() async {
    // Save current question's answer before moving
    saveAnswer();
    
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      loadAnswerForCurrentQuestion();
    } else {
      // All questions answered, submit assessment
      await submitAssessment();
    }
  }

  /// Submit assessment to API
  Future<void> submitAssessment() async {
    try {
      isSubmitting.value = true;

      // Ensure current question's answer is saved before submitting
      saveAnswer();

      // Ensure all questions have answers (use default 5 if not answered)
      for (var question in questions) {
        if (!answers.containsKey(question.id)) {
          // Save default answer for unanswered questions
          answers[question.id] = 5;
        }
      }

      // Validate that we have answers
      if (answers.isEmpty) {
        isSubmitting.value = false;
        ToastClass.showCustomToast(
          'Please answer at least one question before submitting.',
          type: ToastType.error,
        );
        return;
      }

      // Prepare submission data from answers map
      final submission = AssessmentSubmissionModel.fromAnswerMap(answers);

      // Debug: Log the submission data
      DebugUtils.logInfo(
        'Submitting assessment with ${answers.length} answers out of ${questions.length} questions',
        tag: 'SelfAssessmentController.submitAssessment',
      );

      // Submit to API
      final response = await _questionRepository.submitAssessment(submission);

      isSubmitting.value = false;

      if (response.success) {
        // Show success message
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Assessment submitted successfully!',
          type: ToastType.success,
        );

        // Navigate to review screen
        Get.toNamed(AppRoutes.reviewResultScreen);
      } else {
        // Show error message
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to submit assessment. Please try again.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      isSubmitting.value = false;
      ToastClass.showCustomToast(
        'Failed to submit assessment. Please try again.',
        type: ToastType.error,
      );
    }
  }

  /// Move to previous question
  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      loadAnswerForCurrentQuestion();
    }
  }

  /// Check if current question is answered
  bool get isCurrentQuestionAnswered {
    final question = currentQuestion;
    if (question == null) return false;
    return answers.containsKey(question.id);
  }

  // ========== Category Selection Logic ==========
  
  // Toggle category selection (for blue cards)
  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  // Check if category is selected
  bool isCategorySelected(String category) {
    return selectedCategories.contains(category);
  }

  // Initialize category level screen from arguments
  void initializeCategoryLevelScreen() {
    final planData = Get.arguments as Map<String, dynamic>?;
    if (planData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Store subscription type for fetching categories
        final subscriptionType = planData['subscriptionType'] as String?;
        if (subscriptionType != null && subscriptionType.isNotEmpty) {
          fetchAvailableCategories(subscriptionType);
        }
      });
    } else {
      // If no plan data, try to get current subscription
      fetchAvailableCategoriesFromCurrentSubscription();
    }
  }

  // Fetch available categories from API using subscription type
  Future<void> fetchAvailableCategories(String subscriptionType) async {
    if (isLoadingCategories.value) return;

    if (subscriptionType.isEmpty) {
      ToastClass.showCustomToast(
        'Invalid subscription type',
        type: ToastType.error,
      );
      return;
    }

    try {
      isLoadingCategories.value = true;
      final response = await _subscriptionRepository.getAvailableCategories(subscriptionType);

      if (response.success && response.data != null) {
        availableCategories.value = response.data!.availableCategories;
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load categories. Please try again.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to load categories: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // Fetch available categories from current subscription
  Future<void> fetchAvailableCategoriesFromCurrentSubscription() async {
    if (isLoadingCategories.value) return;

    try {
      isLoadingCategories.value = true;
      final response = await _subscriptionRepository.getCurrentSubscription();

      if (response.success && response.data != null) {
        final subscriptionType = response.data!.subscription?.subscriptionType;
        if (subscriptionType != null && subscriptionType.isNotEmpty) {
          availableCategories.value = response.data!.availableCategories;
        } else {
          ToastClass.showCustomToast(
            'No active subscription found',
            type: ToastType.error,
          );
        }
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load categories. Please try again.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to load categories: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // Handle get started from category level screen
  void handleGetStarted() {
    // Validate that at least one category is selected
    if (selectedCategories.isEmpty) {
      ToastClass.showCustomToast(
        'Please select at least one category',
        type: ToastType.error,
      );
      return;
    }
    
    // Navigate to self assessment screen with selected categories
    Get.toNamed(
      AppRoutes.selfAssessmentScreen,
      arguments: {
        'selectedCategories': selectedCategories.toList(),
      },
    );
  }
}

