import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controllers/review_result_controller.dart';
import '../../../core/const/app_exports.dart';

class AssessmentGridWidget extends StatelessWidget {
  const AssessmentGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewResultController>();

    // Calculate row count based on categories
    final rowCount = controller.needsCategories.fold<int>(
      0,
      (sum, category) => sum + (category['items'] as List).length + 1,
    );

    // Use LayoutBuilder to get available space
    return LayoutBuilder(
      builder: (context, constraints) {
        final leftLabelsWidth = 120.0;
        final columnCount = 8;
        final availableWidth = constraints.maxWidth - leftLabelsWidth - 8;
        final columnWidth = availableWidth / columnCount;
        final gridWidth = columnCount * columnWidth;

        // Calculate grid height to fit available space
        // Reserve space for: gap (10) + bottom labels (estimated 60) + padding
        final bottomLabelsHeight = 60.0;
        final gapHeight = 10.0;
        final availableHeight =
            constraints.maxHeight - bottomLabelsHeight - gapHeight;
        final rowHeight = availableHeight / rowCount;
        final gridHeight = rowCount * rowHeight;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left labels - OUTSIDE the grid
            SizedBox(
              width: leftLabelsWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _buildLeftLabels(controller, rowHeight),
              ),
            ),
            const SizedBox(width: 8),
            // Grid container
            Expanded(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Grid with gradient
                      SizedBox(
                        width: gridWidth,
                        height: gridHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFD32F2F), // Dark red
                                Color(0xFFE57373), // Light red
                                Color(0xFFF5F5F5), // Light grey/white
                                Color(0xFFC8E6C9), // Light green
                                Color(0xFF66BB6A), // Medium green
                                Color(0xFF388E3C), // Dark green
                              ],
                              stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: CustomPaint(
                            painter: GridPainter(
                              columnCount: columnCount,
                              rowCount: rowCount,
                              gridWidth: gridWidth,
                              gridHeight: gridHeight,
                              columnWidth: columnWidth,
                              needsCategories: controller.needsCategories,
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      // Bottom labels - formatted according to image
                      SizedBox(
                        width: gridWidth,
                        height: bottomLabelsHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controller.scaleDescriptors
                              .asMap()
                              .entries
                              .map((entry) {
                                final index = entry.key;
                                final descriptor = entry.value;
                                return SizedBox(
                                  width: columnWidth,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children:
                                        _formatDescriptor(descriptor, index)
                                            .map(
                                              (word) => Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 1.5,
                                                ),
                                                child: CustomTextWidget(
                                                  text: word,
                                                  fontSize: 3,
                                                  fontWeight: FontWeight.w400,
                                                  textColor: AppColors.black,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  // Lines connecting grid columns to descriptors
                  Positioned(
                    top: gridHeight,
                    left: 0,
                    right: 0,
                    height: 10, // Gap height
                    child: CustomPaint(
                      painter: DescriptorLinePainter(
                        columnCount: columnCount,
                        columnWidth: columnWidth,
                        gridWidth: gridWidth,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<String> _formatDescriptor(String descriptor, int index) {
    // Handle special cases for each descriptor to match image format
    switch (index) {
      case 0: // 'Dysfunctional Neurotic Psychotic'
        return ['Dysfunctional', 'Neurotic', 'Psychotic'];
      case 1: // 'Extremes Too much Too Little'
        return ['Extremes', 'Too much', 'Too Little'];
      case 2: // 'Not getting by: Cravings Dissatisfaction'
        return ['Not getting', 'by:', 'Cravings', 'Dissatisfaction'];
      case 3: // 'Doing OK Getting By Normal Concerns'
        return ['Doing OK', 'Getting By', 'Normal', 'Concerns'];
      case 4: // 'Getting by well Feeling Good'
        return ['Getting by', 'well', 'Feeling Good'];
      case 5: // 'Doing Good Thriving'
        return ['Doing Good', 'Thriving'];
      case 6: // 'Optimizing Super-Thriving'
        return ['Optimizing', 'Super-Thriving'];
      case 7: // 'Maximizing At ones are very best'
        return ['Maximizing', 'At ones are', 'very best'];
      default:
        // Default: split by space but keep hyphenated words together
        return descriptor.split(' ').where((w) => w.isNotEmpty).toList();
    }
  }

  List<Widget> _buildLeftLabels(
    ReviewResultController controller,
    double rowHeight,
  ) {
    final List<Widget> labels = [];
    for (final category in controller.needsCategories) {
      // Category heading
      labels.add(
        SizedBox(
          height: rowHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomTextWidget(
              text: category['category'],
              fontSize: 6,
              fontWeight: FontWeight.w700,
              textColor: const Color(0xFF2196F3), // Light blue
              textAlign: TextAlign.left,
            ),
          ),
        ),
      );
      // Category items
      for (final item in category['items']) {
        labels.add(
          SizedBox(
            height: rowHeight,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomTextWidget(
                  text: item,
                  fontSize: 4,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.black,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        );
      }
    }
    return labels;
  }
}

class GridPainter extends CustomPainter {
  final int columnCount;
  final int rowCount;
  final double gridWidth;
  final double gridHeight;
  final double columnWidth;
  final List<Map<String, dynamic>> needsCategories;

  GridPainter({
    required this.columnCount,
    required this.rowCount,
    required this.gridWidth,
    required this.gridHeight,
    required this.columnWidth,
    required this.needsCategories,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dashPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final solidPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Calculate center column index (4th column out of 8, so index 4)
    final centerColumnIndex = columnCount ~/ 2;

    // Vertical lines (columns)
    for (int i = 1; i < columnCount; i++) {
      final x = i * columnWidth;

      // Center vertical line should be solid black (bold)
      if (i == centerColumnIndex) {
        canvas.drawLine(Offset(x, 0), Offset(x, gridHeight), solidPaint);
      } else {
        // All other vertical lines are dashed
        _drawDashedLine(
          canvas,
          Offset(x, 0),
          Offset(x, gridHeight),
          dashPaint,
          isVertical: true,
        );
      }
    }

    // Horizontal lines - bold solid lines at the end of each category section
    final rowHeight = gridHeight / rowCount;
    int currentRow = 0;

    // Calculate positions where bold lines should be drawn (at end of each category)
    final List<int> categoryBoundaryRows = [];

    for (
      int categoryIndex = 0;
      categoryIndex < needsCategories.length - 1;
      categoryIndex++
    ) {
      final category = needsCategories[categoryIndex];
      currentRow++; // Category header row
      currentRow += (category['items'] as List).length; // All items in category
      categoryBoundaryRows.add(currentRow); // This is where the bold line goes
    }

    // Draw all horizontal lines
    for (int i = 1; i < rowCount; i++) {
      final y = i * rowHeight;

      // Draw bold solid line at category boundaries
      if (categoryBoundaryRows.contains(i)) {
        canvas.drawLine(Offset(0, y), Offset(gridWidth, y), solidPaint);
      } else {
        // Draw dashed lines for all other internal lines
        _drawDashedLine(
          canvas,
          Offset(0, y),
          Offset(gridWidth, y),
          dashPaint,
          isVertical: false,
        );
      }
    }

    // Outer border - solid
    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(0, 0, gridWidth, gridHeight), borderPaint);
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint, {
    required bool isVertical,
  }) {
    const dashWidth = 4.0;
    const dashSpace = 3.0;

    if (isVertical) {
      double startY = start.dy;
      final double startX = start.dx;
      final double endY = end.dy;

      while (startY < endY) {
        canvas.drawLine(
          Offset(startX, startY),
          Offset(startX, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    } else {
      double startX = start.dx;
      final double startY = start.dy;
      final double endX = end.dx;

      while (startX < endX) {
        canvas.drawLine(
          Offset(startX, startY),
          Offset(startX + dashWidth, startY),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DescriptorLinePainter extends CustomPainter {
  final int columnCount;
  final double columnWidth;
  final double gridWidth;

  DescriptorLinePainter({
    required this.columnCount,
    required this.columnWidth,
    required this.gridWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw vertical lines from center of each grid column to center of each descriptor
    for (int i = 0; i < columnCount; i++) {
      // Calculate the center x position of each column
      final columnCenterX = (i * columnWidth) + (columnWidth / 2);

      // Draw line from top (grid bottom) to bottom (descriptor top)
      canvas.drawLine(
        Offset(columnCenterX, 0),
        Offset(columnCenterX, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
