import 'dart:math' as math;
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/models/need_data.dart';
import '../../../data/models/question/assessment_result_model.dart';
import '../../../data/repository/question_repository.dart';

class HomeController extends GetxController {
  // Repository
  final QuestionRepository _questionRepository = QuestionRepository();

  // User info
  final RxString userName = '@DuozhuaMiao'.obs;
  final RxString greeting = 'Good morning'.obs;

  // Assessment result data
  final Rx<AssessmentResultModel?> assessmentResult =
      Rx<AssessmentResultModel?>(null);
  final RxList<NeedData> needs = <NeedData>[].obs;

  // Loading state
  final RxBool isLoadingNeeds = false.obs;
  
  // Error state
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAssessmentResult();
  }

  /// Fetch assessment result from API
  Future<void> fetchAssessmentResult() async {
    try {
      isLoadingNeeds.value = true;
      needs.clear();

      final response = await _questionRepository.getAssessmentResult();

      isLoadingNeeds.value = false;
      errorMessage.value = ''; // Clear error on success

      if (response.success && response.data != null) {
        assessmentResult.value = response.data;
        _updateSliderNeeds();
      } else {
        // If API fails, set error message
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Failed to load assessment data';
        DebugUtils.logWarning(
          'Failed to load assessment result: ${response.message}',
          tag: 'HomeController.fetchAssessmentResult',
        );
      }
    } catch (e) {
      isLoadingNeeds.value = false;
      needs.clear();
      errorMessage.value = 'An error occurred. Please try again.';
      DebugUtils.logError(
        'Error fetching assessment result',
        tag: 'HomeController.fetchAssessmentResult',
        error: e,
      );
    }
  }

  /// Get category scores from API or return empty map
  Map<String, double> get categoryScores {
    return assessmentResult.value?.categoryScores ?? {};
  }

  /// Get category descriptions from API
  Map<String, String> get categoryDescriptions {
    return assessmentResult.value?.chartMeta.categoryDescriptions ?? {};
  }

  /// Get performance bands from API
  List<PerformanceBand> get performanceBands {
    return assessmentResult.value?.chartMeta.performanceBands ?? [];
  }

  /// Get color for a score based on performance bands
  int getColorForScore(double score) {
    final bands = performanceBands;
    if (bands.isEmpty) {
      return 0xFF000000; // Default black
    }

    // Sort bands by their range minimum
    final sortedBands = List<PerformanceBand>.from(bands)
      ..sort((a, b) {
        final aMin = a.range.isNotEmpty ? a.range[0] : 0;
        final bMin = b.range.isNotEmpty ? b.range[0] : 0;
        return aMin.compareTo(bMin);
      });

    // Find the band that contains this score
    for (final band in sortedBands) {
      if (band.range.isNotEmpty) {
        final min = band.range[0];
        final max = band.range.length > 1 ? band.range[1] : band.range[0];
        if (score >= min && score <= max) {
          final hexColor = band.color.replaceAll('#', '');
          return int.parse('FF$hexColor', radix: 16);
        }
      }
    }

    return 0xFF000000; // Default black
  }

  /// Get needs categories formatted from API data
  List<Map<String, dynamic>> get formattedNeedsCategories {
    final result = assessmentResult.value;
    
    if (result == null) {
      return [];
    }

    final List<Map<String, dynamic>> formatted = [];
    final scores = result.categoryScores;
    final descriptions = result.chartMeta.categoryDescriptions;

    // Use categories from API in the order they appear
    for (final categoryName in scores.keys) {
      final score = scores[categoryName] ?? 0;
      formatted.add({
        'category': categoryName,
        'score': score,
        'description': descriptions[categoryName] ?? '',
        'color': getColorForScore(score),
        'items': [],
      });
    }

    return formatted;
  }

  void _updateSliderNeeds() {
    final categories = formattedNeedsCategories;
    if (categories.isEmpty) {
      needs.clear();
      return;
    }

    // Filter out categories with score 0 and map to NeedData
    final mapped = categories
        .where((category) {
          final score = (category['score'] as num?)?.toDouble() ?? 0.0;
          return score > 0; // Only include categories with score > 0
        })
        .map((category) {
          final title = category['category'] as String? ?? '';
          final score = (category['score'] as num?)?.toDouble() ?? 0.0;
          final sliderValue = _normalizeScoreForSlider(score);

          return NeedData(
            id: title,
            title: title,
            vValue: sliderValue.obs,
            qValue: sliderValue.obs,
            isGreen: false,
          );
        })
        .toList();

    needs.assignAll(mapped);
  }

  double _normalizeScoreForSlider(double score) {
    final maxScore = _maxPerformanceScore;
    final normalizedMax = maxScore <= 0 ? 10.0 : math.max(10.0, maxScore);
    final normalized = (score / normalizedMax) * 10.0;
    return normalized.clamp(0.0, 10.0);
  }

  double get _maxPerformanceScore {
    double maxScore = 0;
    for (final band in performanceBands) {
      for (final value in band.range) {
        if (value > maxScore) {
          maxScore = value.toDouble();
        }
      }
    }
    return maxScore > 0 ? maxScore : 10.0;
  }

  void updateVValue(String needId, double value) {
    final need = needs.firstWhereOrNull((n) => n.id == needId);
    if (need != null) {
      need.vValue.value = value.clamp(0.0, 10.0);
    }
  }

  void updateQValue(String needId, double value) {
    final need = needs.firstWhereOrNull((n) => n.id == needId);
    if (need != null) {
      need.qValue.value = value.clamp(0.0, 10.0);
    }
  }

  // Action cards
  final List<Map<String, dynamic>> actionCards = [
    {'title': 'Report', 'emoji': '📊', 'subtitle': 'View your assessment  \n report'},
    {'title': 'Goal Tracker', 'emoji': '📓', 'subtitle': 'Track yours  \n Goals'},
    {'title': 'Self Actualization', 'emoji': '💬', 'subtitle': 'Continue self  \n assessment'},

  ];

  void onActionCardTap(String title) {
    // Handle action card tap based on actual card titles
    switch (title) {
      case 'Report':
        Get.toNamed(AppRoutes.needsReportScreen);
        break;
      case 'Goal Tracker':
        Get.toNamed(AppRoutes.goalScreen);
        break;
      case 'Self Actualization':
        Get.toNamed(AppRoutes.categoryLevelScreen);
        break;
      default:
        DebugUtils.logWarning('Unknown action card tapped: $title');
    }
  }

  void refreshData() {
    errorMessage.value = '';
    fetchAssessmentResult();
  }
}
