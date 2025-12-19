import 'dart:math' as math;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:self_actualisation/data/services/pdf_generation_service.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/models/need_data.dart';
import '../../../data/models/question/assessment_result_model.dart';
import '../../../data/models/question/needs_report_model.dart';
import '../../../data/repository/question_repository.dart';


class ReviewResultController extends GetxController {
  // Repository
  final QuestionRepository _questionRepository = QuestionRepository();
  
  // PDF Service
  final PdfGenerationService _pdfService = PdfGenerationService();

  // GlobalKey for capturing assessment grid screenshot
  final GlobalKey repaintBoundaryKey = GlobalKey();

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

  /// Static scale descriptors (bottom labels) with sub-labels - not from API
  static const Map<String, List<String>> staticScaleDescriptors = {
    'Dysfunctional': ['Neurotic', 'Psychotic'],
    'Extremes': ['Too much', 'Too Little'],
    'Not getting by': ['Cravings', 'Dissatisfaction'],
    'Doing OK': ['Getting By', 'Normal Concerns'],
    'Getting by well': ['Feeling Good'],
    'Doing Good': ['Thriving'],
    'Optimizing': ['Super-Thriving'],
    'Maximizing': ['At ones very best'],
  };

  /// Get scale descriptors - using static data instead of API
  List<String> get scaleDescriptors {
    return staticScaleDescriptors.keys.toList();
  }

  /// Get sub-labels for a scale descriptor
  List<String> getScaleSubLabels(String descriptor) {
    return staticScaleDescriptors[descriptor] ?? [];
  }

  /// Static sub-needs for each category - not from API
  static const Map<String, List<String>> staticCategorySubNeeds = {
    'Meta-Needs': [
      
      'Cognitive need',
      'Contribution needs',
      'Conative needs',
      'Love needs',
      'Truth needs',
      'Aesthetic needs',
      'Expressive needs',
    ],
    'Self': [
      'Important of voice',
      'Honor and Dignity',
      'Sense of respect',
      'Sense of human dignity',
    ],
    'Social': [
     'Group Acceptance',
      'Bonding with partner',
      'Meaningful Connections',
      'Love/Affection',
      'Social connection: friends',
    ],
    'Safety': [
    'Sense of Control',
    "personal power",
    'Sense of Order / Structure',
    'Stability in life',
    'Career/job safety',
    'Physical/Personal safety',

    ],
    'Survival': [
      'Money',
      'Sex',
      'Exercise',
      'Vitality',
      'Weight Management',
      'Food',
      'Sleep',
    ],
  };

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
  /// Ordered top to bottom: Meta-Needs, Self, Social, Safety, Survival (pyramid order)
  List<Map<String, dynamic>> get formattedNeedsCategories {
    final result = assessmentResult.value;
    if (result == null) return [];

    // Define pyramid order (top to bottom - Meta-Needs at top, Survival at bottom)
    const pyramidOrder = [
      'Meta-Needs',
      'Self',
      'Social',
      'Safety',
      'Survival',
    ];

    final List<Map<String, dynamic>> formatted = [];
    final scores = result.categoryScores;

    // Always include all categories from pyramid order, even if they don't have scores
    // This ensures all categories (including Survival) are always displayed
    for (final categoryName in pyramidOrder) {
      final score = scores[categoryName] ?? 0;
      // Use static sub-needs instead of API description
      final staticSubNeeds = staticCategorySubNeeds[categoryName] ?? [];
      final description = staticSubNeeds.join(', '); // Join sub-needs with commas
      
      formatted.add({
        'category': categoryName,
        'score': score,
        'description': description,
        'color': getColorForScore(score),
        'items': [],
      });
    }
    
    // Then add any remaining categories from API that are not in the pyramid order
    for (final categoryName in scores.keys) {
      if (!pyramidOrder.contains(categoryName)) {
        final score = scores[categoryName] ?? 0;
        final staticSubNeeds = staticCategorySubNeeds[categoryName] ?? [];
        final description = staticSubNeeds.join(', ');
        
        formatted.add({
          'category': categoryName,
          'score': score,
          'description': description,
          'color': getColorForScore(score),
          'items': [],
        });
      }
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

  /// Generate PDF at frontend with assessment grid and report data
  Future<Uint8List> _generatePdf() async {
    final result = assessmentResult.value;
    
    if (result == null) {
      throw Exception('No assessment data available');
    }

    // Fetch needs report data
    NeedsReportModel? needsReport;
    try {
      final needsResponse = await _questionRepository.getNeedsReport();
      if (needsResponse.success && needsResponse.data != null) {
        needsReport = needsResponse.data;
      }
    } catch (e) {
      DebugUtils.logWarning(
        'Failed to fetch needs report for PDF: $e',
        tag: 'ReviewResultController._generatePdf',
      );
      // Continue without needs report if fetch fails
    }

    // Capture screenshot of the assessment grid widget
    Uint8List? gridImageBytes;
    int retryCount = 0;
    const maxRetries = 5;
    
    while (retryCount < maxRetries) {
      try {
        // Wait for widget to render and ensure it's visible
        await Future.delayed(Duration(milliseconds: 500 + (retryCount * 200)));
        
        // Get the RenderRepaintBoundary from the GlobalKey
        final BuildContext? context = repaintBoundaryKey.currentContext;
        if (context == null) {
          retryCount++;
          if (retryCount >= maxRetries) {
            throw Exception('RepaintBoundary context not found after $maxRetries attempts. Make sure the widget is rendered.');
          }
          continue;
        }
        
        final RenderRepaintBoundary? renderObject = 
            context.findRenderObject() as RenderRepaintBoundary?;
        
        if (renderObject == null) {
          retryCount++;
          if (retryCount >= maxRetries) {
            throw Exception('RenderRepaintBoundary not found after $maxRetries attempts.');
          }
          continue;
        }
        
        // Check if the render object is attached and has a size
        if (!renderObject.attached) {
          retryCount++;
          if (retryCount >= maxRetries) {
            throw Exception('RenderRepaintBoundary is not attached to the render tree.');
          }
          continue;
        }
        
        final size = renderObject.size;
        if (size.isEmpty) {
          retryCount++;
          if (retryCount >= maxRetries) {
            throw Exception('RenderRepaintBoundary has empty size. Widget may not be visible.');
          }
          continue;
        }
        
        DebugUtils.logInfo(
          'Capturing grid screenshot. Size: ${size.width}x${size.height} (Attempt ${retryCount + 1})',
          tag: 'ReviewResultController._generatePdf',
        );
        
        // Capture the image with higher pixel ratio for better quality
        final image = await renderObject.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        
        if (byteData == null) {
          throw Exception('Failed to convert image to bytes');
        }
        
        gridImageBytes = byteData.buffer.asUint8List();
        
        if (gridImageBytes.isEmpty) {
          throw Exception('Captured image is empty');
        }
        
        DebugUtils.logInfo(
          'Grid screenshot captured successfully. Size: ${gridImageBytes.length} bytes',
          tag: 'ReviewResultController._generatePdf',
        );
        
        // Success - break out of retry loop
        break;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          DebugUtils.logError(
            'Error capturing grid screenshot after $maxRetries attempts: $e',
            tag: 'ReviewResultController._generatePdf',
            error: e,
          );
          throw Exception('Failed to capture assessment grid after $maxRetries attempts: $e');
        }
        DebugUtils.logWarning(
          'Attempt $retryCount failed, retrying... Error: $e',
          tag: 'ReviewResultController._generatePdf',
        );
      }
    }
    
    if (gridImageBytes == null || gridImageBytes.isEmpty) {
      throw Exception('Failed to capture grid screenshot');
    }

    return await _pdfService.generateAssessmentPdf(
      assessmentResult: result,
      gridImageBytes: gridImageBytes,
      getColorForScore: getColorForScore,
      needsReport: needsReport,
    );
  }

  Future<void> downloadPDF() async {
    if (isDownloadingPdf.value) return;

    try {
      isDownloadingPdf.value = true;
      
      // Trigger a rebuild to ensure widget is rendered
      update();
      
      // Wait a bit more to ensure the widget is fully rendered
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Generate PDF at frontend
      final pdfBytes = await _generatePdf();
      final filePath = await _savePdfToFile(pdfBytes);
      _downloadedPdfPath = filePath; 
      
      // Open PDF with relevant app
      try {
        final result = await OpenFilex.open(filePath);
        if (result.type == ResultType.done) {
          ToastClass.showCustomToast(
            'PDF downloaded and opened successfully',
            type: ToastType.success,
          );
        } else {
          ToastClass.showCustomToast(
            'PDF downloaded successfully',
            type: ToastType.success,
          );
        }
      } catch (openError) {
        // If opening fails, still show success for download
        ToastClass.showCustomToast(
          'PDF downloaded successfully',
          type: ToastType.success,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to generate PDF: ${e.toString()}',
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

      // 1. Get the file (either existing or generate new)
      if (_downloadedPdfPath != null && File(_downloadedPdfPath!).existsSync()) {
        filePathToShare = _downloadedPdfPath;
      } else {
        // Generate PDF at frontend
        final pdfBytes = await _generatePdf();
        filePathToShare = await _savePdfToFile(pdfBytes);
        _downloadedPdfPath = filePathToShare;
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