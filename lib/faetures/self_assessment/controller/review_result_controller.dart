import 'dart:math' as math;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/models/need_data.dart';
import '../../../data/models/question/assessment_result_model.dart';
import '../../../data/repository/question_repository.dart';

class ReviewResultController extends GetxController {
  // Repository
  final QuestionRepository _questionRepository = QuestionRepository();

  // Assessment result data
  final Rx<AssessmentResultModel?> assessmentResult =
      Rx<AssessmentResultModel?>(null);
  final RxList<NeedData> sliderNeeds = <NeedData>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool isDownloadingPdf = false.obs;
  final RxBool isSharingPdf = false.obs;
  
  // Store the downloaded PDF file path
  String? _downloadedPdfPath;

  @override
  void onInit() {
    super.onInit();
    fetchAssessmentResult();
  }

  /// Fetch assessment result from API
  Future<void> fetchAssessmentResult() async {
    try {
      isLoading.value = true;
      sliderNeeds.clear();
      update(); // Notify GetBuilder to rebuild

      final response = await _questionRepository.getAssessmentResult();

      isLoading.value = false;
      update(); // Notify GetBuilder to rebuild

      if (response.success && response.data != null) {
        assessmentResult.value = response.data;
        _updateSliderNeeds();
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
      sliderNeeds.clear();
      update(); // Notify GetBuilder to rebuild
      ToastClass.showCustomToast(
        'Failed to load assessment result. Please try again.',
        type: ToastType.error,
      );
    }
  }

  /// Get category scores from API or return empty map
  Map<String, double> get categoryScores {
    return assessmentResult.value?.categoryScores ?? {};
  }

  /// Get overall score from API or return 0
  double get overallScore {
    return assessmentResult.value?.overallScore ?? 0.0;
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
  int getColorForScore(double score) {
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

  void _updateSliderNeeds() {
    final categories = formattedNeedsCategories;
    if (categories.isEmpty) {
      sliderNeeds.clear();
      return;
    }

    final mapped = categories.map((category) {
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
    }).toList();

    sliderNeeds.assignAll(mapped);
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

  Future<void> downloadPDF() async {
    if (isDownloadingPdf.value) return;

    try {
      isDownloadingPdf.value = true;
      final response = await _questionRepository.downloadAssessmentPdf();

      if (response.success && response.data != null) {
        final filePath = await _savePdfToFile(response.data!);
        _downloadedPdfPath = filePath; // Store the path for sharing
        
        try {
          await OpenFilex.open(filePath);
          ToastClass.showCustomToast(
            'PDF downloaded and opened successfully',
            type: ToastType.success,
          );
        } catch (openError) {
          // File saved but couldn't open - still show success with location
          ToastClass.showCustomToast(
            'PDF saved to: $filePath',
            type: ToastType.success,
          );
        }
      } else {
        final message = response.message.isNotEmpty
            ? response.message
            : 'Unable to download PDF. Please try again.';
        ToastClass.showCustomToast(message, type: ToastType.error);
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to download PDF: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isDownloadingPdf.value = false;
    }
  }

  Future<String> _savePdfToFile(Uint8List bytes) async {
    // Use temporary directory for sharing - accessible by share_plus on both Android and iOS
    final directory = await getTemporaryDirectory();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '${directory.path}/assessment_result_$timestamp.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<void> shareToCoach() async {
    if (isSharingPdf.value) return;

    try {
      isSharingPdf.value = true;

      String? filePathToShare;

      // If PDF is already downloaded, use it directly
      if (_downloadedPdfPath != null && File(_downloadedPdfPath!).existsSync()) {
        filePathToShare = _downloadedPdfPath;
      } else {
        // Otherwise, download the PDF first
        final response = await _questionRepository.downloadAssessmentPdf();

        if (response.success && response.data != null) {
          filePathToShare = await _savePdfToFile(response.data!);
          _downloadedPdfPath = filePathToShare;
        } else {
          final message = response.message.isNotEmpty
              ? response.message
              : 'Unable to download PDF for sharing. Please try again.';
          ToastClass.showCustomToast(message, type: ToastType.error);
          return;
        }
      }

      // Share the PDF file
      if (filePathToShare != null) {
        await _sharePdfFile(filePathToShare);
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to share PDF: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isSharingPdf.value = false;
    }
  }

  Future<void> _sharePdfFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        ToastClass.showCustomToast(
          'PDF file not found. Please download it first.',
          type: ToastType.error,
        );
        return;
      }

      DebugUtils.logInfo(
        'Sharing PDF file: $filePath, exists: ${file.existsSync()}, size: ${await file.length()}',
        tag: 'ReviewResultController._sharePdfFile',
      );

      final xFile = XFile(
        filePath,
        mimeType: 'application/pdf',
        name: 'assessment_result.pdf',
      );

      DebugUtils.logInfo(
        'Calling Share.shareXFiles with file: ${xFile.path}',
        tag: 'ReviewResultController._sharePdfFile',
      );

      // Use shareXFiles - share_plus handles FileProvider automatically
      final result = await Share.shareXFiles(
        [xFile],
        text: 'Assessment Results PDF',
        subject: 'Self-Actualization Assessment Results',
      );

      DebugUtils.logInfo(
        'Share completed with status: ${result.status}',
        tag: 'ReviewResultController._sharePdfFile',
      );

      // Share dialog opened - no need for success toast
      // The native share sheet is the feedback
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error sharing PDF: $e',
        tag: 'ReviewResultController._sharePdfFile',
        error: e,
        stackTrace: stackTrace,
      );
      ToastClass.showCustomToast(
        'Failed to share PDF. Please try again.',
        type: ToastType.error,
      );
      rethrow;
    }
  }

  void continueAction() {
    ToastClass.showCustomToast('Continue functionality', type: ToastType.simple);
  }
}
