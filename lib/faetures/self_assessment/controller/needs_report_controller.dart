import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../data/models/question/needs_report_model.dart';
import '../../../data/repository/question_repository.dart';

class NeedsReportController extends GetxController {
  // Repository
  final QuestionRepository _questionRepository = QuestionRepository();

  // Needs report data
  final Rx<NeedsReportModel?> needsReport = Rx<NeedsReportModel?>(null);
  final RxList<NeedScore> needScores = <NeedScore>[].obs;
  final RxList<NeedScore> lowestNeeds = <NeedScore>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNeedsReport();
  }

  /// Fetch needs report from API
  Future<void> fetchNeedsReport() async {
    try {
      isLoading.value = true;
      needScores.clear();
      lowestNeeds.clear();

      final response = await _questionRepository.getNeedsReport();

      isLoading.value = false;

      if (response.success && response.data != null) {
        needsReport.value = response.data;
        needScores.value = response.data!.needScores;
        lowestNeeds.value = response.data!.lowestNeeds;
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load needs report',
          type: ToastType.error,
        );
      }
    } catch (e) {
      isLoading.value = false;
      needScores.clear();
      lowestNeeds.clear();
      ToastClass.showCustomToast(
        'Failed to load needs report. Please try again.',
        type: ToastType.error,
      );
    }
  }

  /// Get performance band color for a score
  Color getColorForScore(double score) {
    if (score >= 6.0) {
      return AppColors.green; // Thriving/Maximizing
    } else if (score >= 4.0) {
      return AppColors.orange; // Getting By
    } else {
      return AppColors.red; // Dysfunctional/Extreme
    }
  }

  /// Get performance band label for a score
  String getPerformanceLabel(double score) {
    if (score >= 6.5) {
      return 'Maximizing';
    } else if (score >= 5.0) {
      return 'Thriving';
    } else if (score >= 3.0) {
      return 'Getting By';
    } else {
      return 'Dysfunctional';
    }
  }

  /// Handle recommendation action based on type
  void handleRecommendationAction(Recommendation recommendation) {
    switch (recommendation.type) {
      case 'learn':
        // Navigate to Learn & Grow with questionId
        if (recommendation.questionId != null && recommendation.questionId!.isNotEmpty) {
          Get.toNamed(
            AppRoutes.learnGrowScreen,
            arguments: {'questionId': recommendation.questionId},
          );
        } else {
          ToastClass.showCustomToast(
            'No learning content available for this need',
            type: ToastType.error,
          );
        }
        break;

      case 'goal':
        // Navigate to Add Goal screen with pre-filled data
        Get.toNamed(
          AppRoutes.addGoalScreen,
          arguments: {
            'needKey': recommendation.needKey,
            'needLabel': recommendation.needLabel,
            'questionId': recommendation.questionId,
            'category': _getCategoryFromNeedKey(recommendation.needKey),
          },
        );
        break;

      case 'coach':
        // Open email to coach
        _sendEmailToCoach(recommendation);
        break;

      default:
        ToastClass.showCustomToast(
          'Unknown action type: ${recommendation.type}',
          type: ToastType.error,
        );
    }
  }

  /// Get category from needKey by finding it in needScores
  String _getCategoryFromNeedKey(String needKey) {
    final need = needScores.firstWhereOrNull((n) => n.needKey == needKey);
    return need?.category ?? 'Survival';
  }

  /// Send email to coach about a specific need
  Future<void> _sendEmailToCoach(Recommendation recommendation) async {
    try {
      final Email email = Email(
        body: 'I would like to ask about ${recommendation.needLabel}. ${recommendation.message}',
        subject: 'Question about ${recommendation.needLabel}',
        recipients: ['info@thecoachingcentre.com.au'],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
      
      ToastClass.showCustomToast(
        'Email opened successfully. Please send your question.',
        type: ToastType.success,
      );
    } catch (e) {
      ToastClass.showCustomToast(
        'Could not open email app. Please ensure an email account is set up.',
        type: ToastType.error,
      );
    }
  }
}

