import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/models/question/assessment_result_model.dart';
import '../../../data/repository/question_repository.dart';

class ReviewResultController extends GetxController {
  // Repository
  final QuestionRepository _questionRepository = QuestionRepository();

  // Assessment result data
  final Rx<AssessmentResultModel?> assessmentResult = Rx<AssessmentResultModel?>(null);
  
  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAssessmentResult();
  }

  /// Fetch assessment result from API
  Future<void> fetchAssessmentResult() async {
    try {
      isLoading.value = true;
      update(); // Notify GetBuilder to rebuild

      final response = await _questionRepository.getAssessmentResult();

      isLoading.value = false;
      update(); // Notify GetBuilder to rebuild

      if (response.success && response.data != null) {
        assessmentResult.value = response.data;
        update(); // Notify GetBuilder to rebuild with new data
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load assessment result',
          type: ToastType.error,
        );
      }
    } catch (e) {
      isLoading.value = false;
      update(); // Notify GetBuilder to rebuild
      ToastClass.showCustomToast(
        'Failed to load assessment result. Please try again.',
        type: ToastType.error,
      );
    }
  }

  /// Get category scores from API or return empty map
  Map<String, int> get categoryScores {
    return assessmentResult.value?.categoryScores ?? {};
  }

  /// Get overall score from API or return 0
  int get overallScore {
    return assessmentResult.value?.overallScore ?? 0;
  }

  /// Get lowest categories from API or return empty list
  List<String> get lowestCategories {
    return assessmentResult.value?.lowestCategories ?? [];
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
  int getColorForScore(int score) {
    final bands = performanceBands;
    
    for (final band in bands) {
      if (band.range.isNotEmpty) {
        final min = band.range[0];
        final max = band.range.length > 1 ? band.range[1] : band.range[0];
        
        if (score >= min && score <= max) {
          // Convert hex color to int (remove # and parse)
          final hexColor = band.color.replaceAll('#', '');
          return int.parse('FF$hexColor', radix: 16);
        }
      }
    }
    
    // Default color if no band matches
    return 0xFF2196F3;
  }

  /// Get scale descriptors from performance bands
  List<String> get scaleDescriptors {
    final bands = performanceBands;
    if (bands.isEmpty) {
      return [];
    }

    // Sort bands by their range minimum
    final sortedBands = List<PerformanceBand>.from(bands)
      ..sort((a, b) {
        final aMin = a.range.isNotEmpty ? a.range[0] : 0;
        final bMin = b.range.isNotEmpty ? b.range[0] : 0;
        return aMin.compareTo(bMin);
      });

    // Create 8 descriptors (one for each score 1-7, plus one for 0)
    // Map performance bands to score positions
    final descriptors = <String>[];
    
    // For each score position (1-7), find the matching band
    for (int score = 1; score <= 7; score++) {
      String? label;
      for (final band in sortedBands) {
        if (band.range.isNotEmpty) {
          final min = band.range[0];
          final max = band.range.length > 1 ? band.range[1] : band.range[0];
          if (score >= min && score <= max) {
            label = band.label;
            break;
          }
        }
      }
      descriptors.add(label ?? '');
    }

    return descriptors;
  }

  /// Get gradient colors from performance bands
  List<Color> getGradientColors() {
    final bands = performanceBands;
    if (bands.isEmpty) {
      return [];
    }

    // Sort bands by their range minimum
    final sortedBands = List<PerformanceBand>.from(bands)
      ..sort((a, b) {
        final aMin = a.range.isNotEmpty ? a.range[0] : 0;
        final bMin = b.range.isNotEmpty ? b.range[0] : 0;
        return aMin.compareTo(bMin);
      });

    // Convert hex colors to Color objects
    return sortedBands.map((band) {
      final hexColor = band.color.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    }).toList();
  }

  /// Get gradient stops from performance bands
  List<double> getGradientStops() {
    final bands = performanceBands;
    if (bands.isEmpty) {
      return [];
    }

    // Sort bands by their range minimum
    final sortedBands = List<PerformanceBand>.from(bands)
      ..sort((a, b) {
        final aMin = a.range.isNotEmpty ? a.range[0] : 0;
        final bMin = b.range.isNotEmpty ? b.range[0] : 0;
        return aMin.compareTo(bMin);
      });

    // Calculate stops based on score ranges (1-7 scale)
    final stops = <double>[];
    for (int i = 0; i < sortedBands.length; i++) {
      final band = sortedBands[i];
      if (band.range.isNotEmpty) {
        final min = band.range[0];
        // Map score (1-7) to stop (0.0-1.0)
        final stop = (min - 1) / 6.0;
        stops.add(stop.clamp(0.0, 1.0));
      }
    }

    // Ensure we have at least 0.0 and 1.0
    if (stops.isEmpty || stops.first != 0.0) {
      stops.insert(0, 0.0);
    }
    if (stops.last != 1.0) {
      stops.add(1.0);
    }

    return stops;
  }

  /// Get needs categories formatted from API data
  List<Map<String, dynamic>> get formattedNeedsCategories {
    // Access the reactive value to trigger Obx reactivity
    final result = assessmentResult.value;
    
    if (result == null) {
      debugPrint('ReviewResultController: assessmentResult is null');
      return []; // Return empty if no API data
    }

    // Format API data into the structure expected by the widget
    final List<Map<String, dynamic>> formatted = [];
    final scores = result.categoryScores;
    final descriptions = result.chartMeta.categoryDescriptions;

    debugPrint('ReviewResultController: categoryScores count: ${scores.length}');
    debugPrint('ReviewResultController: categoryScores: $scores');

    // Use categories from API in the order they appear
    for (final categoryName in scores.keys) {
      final score = scores[categoryName] ?? 0;
      formatted.add({
        'category': categoryName,
        'score': score,
        'description': descriptions[categoryName] ?? '',
        'color': getColorForScore(score), // Use API color based on score
        'items': [], // No items from API
      });
    }

    debugPrint('ReviewResultController: formatted categories count: ${formatted.length}');
    return formatted;
  }

  void downloadPDF() {
    ToastClass.showCustomToast('Download PDF Summary functionality', type: ToastType.simple);
  }

  void shareToCoach() {
    ToastClass.showCustomToast('Share to Coach functionality', type: ToastType.simple);
  }

  void continueAction() {
    ToastClass.showCustomToast('Continue functionality', type: ToastType.simple);
  }
}
