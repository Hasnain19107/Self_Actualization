import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/question/assessment_result_model.dart';
import '../models/question/needs_report_model.dart';

class PdfGenerationService {
  /// Generate PDF with assessment grid and report data
  Future<Uint8List> generateAssessmentPdf({
    required AssessmentResultModel assessmentResult,
    required Uint8List gridImageBytes,
    required int Function(double) getColorForScore,
    NeedsReportModel? needsReport,
  }) async {
    final pdf = pw.Document();
    
    // PDF page size (A4 landscape for larger grid)
    final pageSize = PdfPageFormat.a4.landscape;
    const margin = 20.0; // Reduced margin for bigger grid
    final availableWidth = pageSize.width - (margin * 2);
    
    // Load the grid image
    final gridImage = pw.MemoryImage(gridImageBytes);

    // Page 1: Title and Grid (Full page for larger grid)
    pdf.addPage(
      pw.Page(
        pageFormat: pageSize,
        margin: const pw.EdgeInsets.all(margin),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title and Copyright
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Self-Actualization Assessment Scale',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '©The Coaching Centre',
                      style: pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Assessment Grid - Screenshot from widget (LARGER SIZE - uses most of page)
              if (gridImageBytes.isNotEmpty)
                pw.Expanded(
                  child: pw.Container(
                    width: availableWidth,
                    child: pw.Image(
                      gridImage,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                )
              else
                pw.Center(
                  child: pw.Text(
                    'Assessment grid image not available',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.red,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );

    // Page 2+: Needs Report Data (MultiPage to handle overflow)
    if (needsReport != null && needsReport.needScores.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: pageSize,
          margin: const pw.EdgeInsets.all(margin),
          build: (pw.Context context) {
            return [
              // Title
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Self-Actualization Assessment Scale',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '©The Coaching Centre',
                      style: pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),

              // Group needs by category
              ..._buildNeedsReportByCategory(needsReport, getColorForScore),

              // Areas for Improvement (Lowest Needs)
              if (needsReport.lowestNeeds.isNotEmpty) ...[
                pw.SizedBox(height: 24),
                pw.Text(
                  'Areas for Growth',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                ...needsReport.lowestNeeds.map((need) {
                  final orangeColor = PdfColor(1.0, 0.65, 0.0); // Orange color
                  final lightOrange = PdfColor(1.0, 0.85, 0.7); // Light orange
                  
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 12),
                    padding: const pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: lightOrange,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                      border: pw.Border.all(
                        color: orangeColor,
                        width: 1,
                      ),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                need.needLabel,
                                style: pw.TextStyle(
                                  fontSize: 16,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                'Score: ${need.score.toStringAsFixed(1)}/7',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  color: PdfColors.grey700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ];
          },
        ),
      );
    }

    return pdf.save();
  }

  /// Build needs report grouped by category (same as needs_report_screen.dart)
  List<pw.Widget> _buildNeedsReportByCategory(
    NeedsReportModel needsReport,
    int Function(double) getColorForScore,
  ) {
    final List<pw.Widget> widgets = [];

    // Group needs by category
    final Map<String, List<NeedScore>> needsByCategory = {};
    for (final need in needsReport.needScores) {
      if (!needsByCategory.containsKey(need.category)) {
        needsByCategory[need.category] = [];
      }
      needsByCategory[need.category]!.add(need);
    }

    // Build widgets for each category
    for (final entry in needsByCategory.entries) {
      final category = entry.key;
      final needs = entry.value;

      widgets.addAll([
        // Category header
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Text(
            category,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue700,
            ),
          ),
        ),
        // Need sliders
        ...needs.map((need) => _buildNeedSliderPdf(need, getColorForScore)),
        pw.SizedBox(height: 24),
      ]);
    }

    return widgets;
  }

  /// Build a need slider widget for PDF (replicating _buildNeedSlider from needs_report_screen.dart)
  pw.Widget _buildNeedSliderPdf(
    NeedScore need,
    int Function(double) getColorForScore,
  ) {
    final score = need.score;
    final color = getColorForScore(score);
    final pdfColor = PdfColor(
      (color >> 16 & 0xFF) / 255.0,
      (color >> 8 & 0xFF) / 255.0,
      (color & 0xFF) / 255.0,
    );
    final label = _getPerformanceLabel(score);
    final widthFactor = (score / 7.0).clamp(0.0, 1.0);

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Need label and score
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  need.needLabel,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                '${score.toStringAsFixed(1)}/7',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: pdfColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          // Progress bar (visual representation)
          pw.Container(
            height: 12,
            decoration: pw.BoxDecoration(
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              color: PdfColors.white,
              border: pw.Border.all(color: PdfColors.grey300, width: 1),
            ),
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.max,
              children: [
                // Progress fill portion
                if (widthFactor > 0)
                  pw.Expanded(
                    flex: (widthFactor * 100).round().clamp(1, 100),
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: pdfColor,
                        borderRadius: const pw.BorderRadius.only(
                          topLeft: pw.Radius.circular(4),
                          bottomLeft: pw.Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                // Remaining portion
                pw.Expanded(
                  flex: ((1 - widthFactor) * 100).round().clamp(0, 100),
                  child: pw.Container(
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 4),
          // Performance label
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.normal,
              color: pdfColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Get performance label for a score (same logic as needs_report_controller.dart)
  String _getPerformanceLabel(double score) {
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
}

