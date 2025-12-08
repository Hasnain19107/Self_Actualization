import 'dart:math' as math;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart'; // Removed as we are using specific email sender
import 'package:flutter_email_sender/flutter_email_sender.dart'; // Add this package
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
      update(); 

      final response = await _questionRepository.getAssessmentResult();

      isLoading.value = false;
      update(); 

      if (response.success && response.data != null) {
        assessmentResult.value = response.data;
        _updateSliderNeeds();
        update(); 
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
      update(); 
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
          final hexColor = band.color.replaceAll('#', '');
          return int.parse('FF$hexColor', radix: 16);
        }
      }
    }
    return 0xFF2196F3;
  }

  /// Get scale descriptors from performance bands
  List<String> get scaleDescriptors {
    final bands = performanceBands;
    if (bands.isEmpty) return [];

    final sortedBands = List<PerformanceBand>.from(bands)
      ..sort((a, b) {
        final aMin = a.range.isNotEmpty ? a.range[0] : 0;
        final bMin = b.range.isNotEmpty ? b.range[0] : 0;
        return aMin.compareTo(bMin);
      });

    final descriptors = <String>[];
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
    if (bands.isEmpty) return [];

    final sortedBands = List<PerformanceBand>.from(bands)
      ..sort((a, b) {
        final aMin = a.range.isNotEmpty ? a.range[0] : 0;
        final bMin = b.range.isNotEmpty ? b.range[0] : 0;
        return aMin.compareTo(bMin);
      });

    return sortedBands.map((band) {
      final hexColor = band.color.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    }).toList();
  }

  /// Get gradient stops from performance bands
  List<double> getGradientStops() {
    final bands = performanceBands;
    if (bands.isEmpty) return [];

    final sortedBands = List<PerformanceBand>.from(bands)
      ..sort((a, b) {
        final aMin = a.range.isNotEmpty ? a.range[0] : 0;
        final bMin = b.range.isNotEmpty ? b.range[0] : 0;
        return aMin.compareTo(bMin);
      });

    final stops = <double>[];
    for (int i = 0; i < sortedBands.length; i++) {
      final band = sortedBands[i];
      if (band.range.isNotEmpty) {
        final min = band.range[0];
        final stop = (min - 1) / 6.0;
        stops.add(stop.clamp(0.0, 1.0));
      }
    }

    if (stops.isEmpty || stops.first != 0.0) stops.insert(0, 0.0);
    if (stops.last != 1.0) stops.add(1.0);

    return stops;
  }

  /// Get needs categories formatted from API data
  List<Map<String, dynamic>> get formattedNeedsCategories {
    final result = assessmentResult.value;
    if (result == null) return [];

    final List<Map<String, dynamic>> formatted = [];
    final scores = result.categoryScores;
    final descriptions = result.chartMeta.categoryDescriptions;

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
        _downloadedPdfPath = filePath; 
        
        try {
          await OpenFilex.open(filePath);
          ToastClass.showCustomToast(
            'PDF downloaded and opened successfully',
            type: ToastType.success,
          );
        } catch (openError) {
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

      // 1. Get the file (either existing or download new)
      if (_downloadedPdfPath != null && File(_downloadedPdfPath!).existsSync()) {
        filePathToShare = _downloadedPdfPath;
      } else {
        final response = await _questionRepository.downloadAssessmentPdf();
        if (response.success && response.data != null) {
          filePathToShare = await _savePdfToFile(response.data!);
          _downloadedPdfPath = filePathToShare;
        } else {
          final message = response.message.isNotEmpty
              ? response.message
              : 'Unable to download PDF for sharing.';
          ToastClass.showCustomToast(message, type: ToastType.error);
          return;
        }
      }

      // 2. Share via Email directly
      if (filePathToShare != null) {
        await _sharePdfViaEmail(filePathToShare);
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

  // Kept for backward compatibility if called elsewhere, but logic flows to shareToCoach
  Future<void> _sharePdfToCoach(String filePath) async {
     await _sharePdfViaEmail(filePath);
  }

  /// Uses flutter_email_sender to open the Email App directly with attachment
  Future<void> _sharePdfViaEmail(String filePath) async {
    try {
      final file = File(filePath);

      if (!file.existsSync()) {
        ToastClass.showCustomToast('PDF file not found.', type: ToastType.error);
        return;
      }

      DebugUtils.logInfo(
        'Preparing email with attachment: $filePath',
        tag: 'ReviewResultController',
      );

      final Email email = Email(
        body: 'Hi Coach,\n\nPlease find my assessment results attached.\n\nRegards,',
        subject: 'Self-Actualization Assessment Results',
        recipients: ['info@thecoachingcentre.com.au'], // Replace with actual coach email
        attachmentPaths: [filePath],
        isHTML: false,
      );

      // This opens the default Email App (Gmail on Android, Mail on iOS) 
      // with the file attached. It skips the generic "Share Sheet".
      await FlutterEmailSender.send(email);
      
      DebugUtils.logInfo(
        'Email intent triggered successfully.',
        tag: 'ReviewResultController',
      );

    } catch (e, stack) {
      DebugUtils.logError(
        'Error sending email: $e',
        tag: 'ReviewResultController',
        error: e,
        stackTrace: stack,
      );
      
      // Fallback: If no email app is found or configured
      ToastClass.showCustomToast(
        'Could not open email app. Please ensure an email account is set up.',
        type: ToastType.error,
      );
    }
  }

  void continueAction() {
    ToastClass.showCustomToast('Continue functionality', type: ToastType.simple);
  }
}