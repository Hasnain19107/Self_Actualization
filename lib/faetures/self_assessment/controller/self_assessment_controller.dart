import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/models/question/question_model.dart';
import '../../../data/models/question/assessment_submission_model.dart';
import '../../../data/repository/question_repository.dart';
import '../../../data/repository/subscription_repository.dart';

class SelfAssessmentController extends GetxController {
  static const List<String> _questionCategoryOrder = [
    'Meta-Needs',
    'Self',
    'Social',
    'Safety',
    'Survival',
  ];

  // Repositories
  final QuestionRepository _questionRepository = QuestionRepository();
  final SubscriptionRepository _subscriptionRepository = SubscriptionRepository();

  // Regular questions list
  final RxList<QuestionModel> regularQuestions = <QuestionModel>[].obs;
  
  // V and Q questions mapped by parent question ID
  final RxMap<String, QuestionModel> vQuestions = <String, QuestionModel>{}.obs;
  final RxMap<String, QuestionModel> qQuestions = <String, QuestionModel>{}.obs;
  
  // Selected categories for fetching questions
  final RxList<String> selectedCategories = <String>[].obs;
  
  // Available categories from subscription
  final RxList<String> availableCategories = <String>[].obs;
  
  // Loading state for categories
  final RxBool isLoadingCategories = false.obs;
  
  // Current regular question index
  final RxInt currentRegularQuestionIndex = 0.obs;
  
  // Current question type: 'regular', 'quality', 'volume'
  final RxString currentQuestionType = 'regular'.obs;
  
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
  /// Implements Regular → V → Q flow
  Future<void> fetchQuestions() async {
    isLoading.value = true;
    try {
      // Step 1: Fetch Regular questions (Section 1, sectionType=regular)
      final List<QuestionModel> regularQuestionsList = [];
      
      if (selectedCategories.isNotEmpty) {
        final response = await _questionRepository.getQuestions(
          categories: selectedCategories.toList(),
          section: 1,
          sectionType: 'regular',
          limit: 100,
          page: 1,
        );

        if (response.success && response.data != null) {
          regularQuestionsList.addAll(response.data!);
        } else {
          final message = response.message.isNotEmpty
              ? response.message
              : 'Failed to load questions';
          throw Exception(message);
        }
      } else {
        // Fallback: fetch all categories (old behavior)
        for (final category in _questionCategoryOrder) {
          final response = await _questionRepository.getQuestions(
            category: category,
            section: 1,
            sectionType: 'regular',
          );

          if (response.success && response.data != null) {
            regularQuestionsList.addAll(response.data!);
          } else {
            final message = response.message.isNotEmpty
                ? response.message
                : 'Failed to load $category questions';
            throw Exception(message);
          }
        }
      }

      // Step 2: For each Regular question, fetch V and Q questions
      // Store them separately for navigation
      regularQuestions.value = regularQuestionsList;
      
      for (final regularQuestion in regularQuestionsList) {
        // Fetch V question (Volume/Quantity)
        final vResponse = await _questionRepository.getQuestions(
          sectionType: 'V',
          parentQuestionId: regularQuestion.id,
        );

        if (vResponse.success && vResponse.data != null && vResponse.data!.isNotEmpty) {
          vQuestions[regularQuestion.id] = vResponse.data!.first;
        }

        // Fetch Q question (Quality)
        final qResponse = await _questionRepository.getQuestions(
          sectionType: 'Q',
          parentQuestionId: regularQuestion.id,
        );

        if (qResponse.success && qResponse.data != null && qResponse.data!.isNotEmpty) {
          qQuestions[regularQuestion.id] = qResponse.data!.first;
        }
      }

      currentRegularQuestionIndex.value = 0;
      currentQuestionType.value = 'regular';
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

  /// Get current regular question
  QuestionModel? get currentRegularQuestion {
    if (currentRegularQuestionIndex.value >= 0 &&
        currentRegularQuestionIndex.value < regularQuestions.length) {
      return regularQuestions[currentRegularQuestionIndex.value];
    }
    return null;
  }

  /// Get current question based on type
  QuestionModel? get currentQuestion {
    final regular = currentRegularQuestion;
    if (regular == null) return null;

    if (currentQuestionType.value == 'regular') {
      return regular;
    } else if (currentQuestionType.value == 'quality') {
      return qQuestions[regular.id];
    } else if (currentQuestionType.value == 'volume') {
      return vQuestions[regular.id];
    }
    return null;
  }

  /// Get current question text
  String get currentQuestionText {
    return currentQuestion?.questionText ?? '';
  }

  /// Current question category
  String get currentQuestionCategory {
    return currentRegularQuestion?.category ?? '';
  }

  /// Get total regular questions count
  int get totalRegularQuestions => regularQuestions.length;

  /// Get progress text
  String get progressText {
    if (totalRegularQuestions == 0) return '0 of 0';
    final regularNum = currentRegularQuestionIndex.value + 1;
    final typeLabel = currentQuestionType.value == 'regular' 
        ? 'General' 
        : currentQuestionType.value == 'quality' 
            ? 'Quality' 
            : 'Volume';
    return '$regularNum of $totalRegularQuestions - $typeLabel';
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

  /// Move to next question/step
  Future<void> nextQuestion() async {
    // Save current question's answer before moving
    saveAnswer();
    
    final regular = currentRegularQuestion;
    if (regular == null) {
      await submitAssessment();
      return;
    }

    // Flow: Regular → Quality → Volume → Next Regular
    if (currentQuestionType.value == 'regular') {
      // Move to Quality question
      if (qQuestions.containsKey(regular.id)) {
        currentQuestionType.value = 'quality';
        loadAnswerForCurrentQuestion();
      } else if (vQuestions.containsKey(regular.id)) {
        // Skip Quality if not available, go to Volume
        currentQuestionType.value = 'volume';
        loadAnswerForCurrentQuestion();
      } else {
        // No Q or V questions, move to next Regular
        moveToNextRegularQuestion();
      }
    } else if (currentQuestionType.value == 'quality') {
      // Move to Volume question
      if (vQuestions.containsKey(regular.id)) {
        currentQuestionType.value = 'volume';
        loadAnswerForCurrentQuestion();
      } else {
        // No Volume question, move to next Regular
        moveToNextRegularQuestion();
      }
    } else if (currentQuestionType.value == 'volume') {
      // Move to next Regular question
      moveToNextRegularQuestion();
    }
  }

  /// Move to next regular question
  void moveToNextRegularQuestion() {
    if (currentRegularQuestionIndex.value < regularQuestions.length - 1) {
      currentRegularQuestionIndex.value++;
      currentQuestionType.value = 'regular';
      loadAnswerForCurrentQuestion();
    } else {
      // All questions answered, submit assessment
      submitAssessment();
    }
  }

  /// Submit assessment to API
  Future<void> submitAssessment() async {
    try {
      isSubmitting.value = true;

      // Ensure current question's answer is saved before submitting
      saveAnswer();

      // Ensure all questions have answers (use default 5 if not answered)
      for (var regularQuestion in regularQuestions) {
        // Regular question
        if (!answers.containsKey(regularQuestion.id)) {
          answers[regularQuestion.id] = 5;
        }
        // Q question
        if (qQuestions.containsKey(regularQuestion.id)) {
          final qQuestion = qQuestions[regularQuestion.id]!;
          if (!answers.containsKey(qQuestion.id)) {
            answers[qQuestion.id] = 5;
          }
        }
        // V question
        if (vQuestions.containsKey(regularQuestion.id)) {
          final vQuestion = vQuestions[regularQuestion.id]!;
          if (!answers.containsKey(vQuestion.id)) {
            answers[vQuestion.id] = 5;
          }
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
      final totalQuestions = regularQuestions.length + 
          qQuestions.length + 
          vQuestions.length;
      DebugUtils.logInfo(
        'Submitting assessment with ${answers.length} answers out of $totalQuestions questions',
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

  /// Move to previous question/step
  void previousQuestion() {
    if (currentQuestionType.value == 'volume') {
      // Go back to Quality
      if (qQuestions.containsKey(currentRegularQuestion?.id)) {
        currentQuestionType.value = 'quality';
        loadAnswerForCurrentQuestion();
      } else {
        // No Quality, go back to Regular
        currentQuestionType.value = 'regular';
        loadAnswerForCurrentQuestion();
      }
    } else if (currentQuestionType.value == 'quality') {
      // Go back to Regular
      currentQuestionType.value = 'regular';
      loadAnswerForCurrentQuestion();
    } else if (currentQuestionType.value == 'regular') {
      // Go to previous Regular question's Volume (or Quality if no Volume)
      if (currentRegularQuestionIndex.value > 0) {
        currentRegularQuestionIndex.value--;
        final prevRegular = currentRegularQuestion;
        if (prevRegular != null) {
          if (vQuestions.containsKey(prevRegular.id)) {
            currentQuestionType.value = 'volume';
          } else if (qQuestions.containsKey(prevRegular.id)) {
            currentQuestionType.value = 'quality';
          } else {
            currentQuestionType.value = 'regular';
          }
          loadAnswerForCurrentQuestion();
        }
      }
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

