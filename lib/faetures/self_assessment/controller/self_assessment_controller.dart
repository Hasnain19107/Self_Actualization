import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/models/question/question_model.dart';
import '../../../data/models/question/assessment_submission_model.dart';
import '../../../data/repository/question_repository.dart';

class SelfAssessmentController extends GetxController {
  // Repository
  final QuestionRepository _questionRepository = QuestionRepository();

  // Questions list
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;
  
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
    fetchQuestions();
  }

  /// Fetch questions from API
  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      
      final response = await _questionRepository.getQuestions();
      
      isLoading.value = false;
      
      if (response.success && response.data != null) {
        questions.value = response.data!;
        // Reset to first question
        currentQuestionIndex.value = 0;
        // Load existing answer if any
        loadAnswerForCurrentQuestion();
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load questions',
          type: ToastType.error,
        );
      }
    } catch (e) {
      isLoading.value = false;
      ToastClass.showCustomToast(
        'Failed to load questions. Please try again.',
        type: ToastType.error,
      );
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
}

