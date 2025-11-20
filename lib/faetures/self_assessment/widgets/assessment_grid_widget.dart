import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controller/review_result_controller.dart';
import '../../../core/const/app_exports.dart';

class AssessmentGridWidget extends StatelessWidget {
  const AssessmentGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewResultController>();

    // Use Obx to make widget reactive to data changes
    return Obx(() {
      // Use formatted categories from API only
      final categories = controller.formattedNeedsCategories;
      
      // Debug: Log categories count
      debugPrint('AssessmentGridWidget: Categories count: ${categories.length}');
      if (categories.isNotEmpty) {
        debugPrint('AssessmentGridWidget: First category: ${categories.first}');
      }
      
      // Return empty widget if no categories
      if (categories.isEmpty) {
        return const SizedBox.shrink();
      }

      // Get dynamic column count from scale descriptors
      final scaleDescriptors = controller.scaleDescriptors;
      final columnCount = scaleDescriptors.isNotEmpty ? scaleDescriptors.length : 7; // Default to 7 if empty
      
      // Use LayoutBuilder to get available space
      return LayoutBuilder(
      builder: (context, constraints) {
        final leftLabelsWidth = 120.0;
        final availableWidth = constraints.maxWidth - leftLabelsWidth - 8;
        final columnWidth = availableWidth / columnCount;
        final gridWidth = columnCount * columnWidth;

        // Calculate grid height to fit available space
        // Reserve space for: gap (10) + bottom labels (estimated 60) + padding
        final bottomLabelsHeight = 60.0;
        final gapHeight = 10.0;
        final availableHeight =
            constraints.maxHeight - bottomLabelsHeight - gapHeight;
        
        // Calculate total items count (category names + description words)
        final totalItems = categories.fold<int>(
          0,
          (sum, category) {
            final description = category['description'] as String? ?? '';
            int descWordCount = 0;
            if (description.isNotEmpty) {
              final parts = description.split(',');
              for (final part in parts) {
                final trimmedPart = part.trim();
                if (trimmedPart.isNotEmpty) {
                  descWordCount += trimmedPart.split(' ').where((w) => w.isNotEmpty).length;
                }
              }
            }
            // 1 for category name + word count for description
            return sum + 1 + descWordCount;
          },
        );
        
        // Calculate row count for grid (same as total items)
        final rowCount = totalItems;
        
        // Calculate item height to fill available space
        final itemHeight = totalItems > 0 ? availableHeight / totalItems : availableHeight;
        final gridHeight = availableHeight;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left labels - OUTSIDE the grid
            SizedBox(
              width: leftLabelsWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _buildLeftLabels(categories, itemHeight, availableHeight),
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
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: controller.getGradientColors(),
                              stops: controller.getGradientStops(),
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
                              needsCategories: categories,
                              totalHeight: availableHeight,
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
                          children: scaleDescriptors
                              .asMap()
                              .entries
                              .map((entry) {
                                final descriptor = entry.value;
                                // Split descriptor by '/' or space for multi-line display
                                final words = descriptor.split(RegExp(r'[/\s]+'))
                                    .where((w) => w.isNotEmpty)
                                    .toList();
                                
                                return SizedBox(
                                  width: columnWidth,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: words
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
                                              maxLines: null,
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
    });
  }


  List<Widget> _buildLeftLabels(
    List<Map<String, dynamic>> categories,
    double itemHeight,
    double totalHeight,
  ) {
    final List<Widget> labels = [];
    
    // Calculate total items to distribute height proportionally
    int totalItems = 0;
    final categoryItemCounts = <int>[];
    
    for (final category in categories) {
      final description = category['description'] as String? ?? '';
      int descWordCount = 0;
      if (description.isNotEmpty) {
        final parts = description.split(',');
        for (final part in parts) {
          final trimmedPart = part.trim();
          if (trimmedPart.isNotEmpty) {
            descWordCount += trimmedPart.split(' ').where((w) => w.isNotEmpty).length;
          }
        }
      }
      final categoryItemCount = 1 + descWordCount; // 1 for category name + description words
      categoryItemCounts.add(categoryItemCount);
      totalItems += categoryItemCount;
    }
    
    // Calculate proportional heights
    for (int catIndex = 0; catIndex < categories.length; catIndex++) {
      final category = categories[catIndex];
      final categoryName = category['category'] as String;
      final description = category['description'] as String? ?? '';
      final categoryItemCount = categoryItemCounts[catIndex];
      
      // Calculate height for this category section (proportional to its item count)
      final categorySectionHeight = (categoryItemCount / totalItems) * totalHeight;
      final categoryNameHeight = categorySectionHeight * 0.2; // 20% for category name
      final descriptionHeight = categorySectionHeight * 0.8; // 80% for description words
      
      // Category heading
      labels.add(
        SizedBox(
          height: categoryNameHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomTextWidget(
              text: categoryName,
              fontSize: 6,
              fontWeight: FontWeight.w700,
              textColor: Color(category['color'] as int? ?? 0xFF2196F3),
              textAlign: TextAlign.left,
              maxLines: null,
            ),
          ),
        ),
      );
      
      // Category description as subheading (one word per line, separated by commas)
      if (description.isNotEmpty) {
        // Split description by commas first, then by spaces
        final parts = description.split(',');
        final words = <String>[];
        
        for (final part in parts) {
          // Trim and split each part by spaces
          final trimmedPart = part.trim();
          if (trimmedPart.isNotEmpty) {
            final partWords = trimmedPart.split(' ').where((w) => w.isNotEmpty);
            words.addAll(partWords);
          }
        }
        
        // Calculate height per word
        final wordHeight = words.isNotEmpty ? descriptionHeight / words.length : 0.0;
        
        // Display each word on a separate line
        for (final word in words) {
          labels.add(
            SizedBox(
              height: wordHeight,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextWidget(
                    text: word.trim(),
                    fontSize: 4,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.black,
                    textAlign: TextAlign.left,
                    maxLines: null,
                  ),
                ),
              ),
            ),
          );
        }
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
  final double totalHeight;

  GridPainter({
    required this.columnCount,
    required this.rowCount,
    required this.gridWidth,
    required this.gridHeight,
    required this.columnWidth,
    required this.needsCategories,
    required this.totalHeight,
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

    // Calculate center column index for odd column counts
    final centerColumnIndex = columnCount % 2 == 1 ? columnCount ~/ 2 : -1;

    // Vertical lines (columns)
    for (int i = 1; i < columnCount; i++) {
      final x = i * columnWidth;

      // Center vertical line should be solid black (bold) if columnCount is odd
      if (columnCount % 2 == 1 && i == centerColumnIndex) {
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

    // Calculate category boundary positions based on proportional heights
    final List<double> categoryBoundaryPositions = [];
    
    // Calculate total items to determine proportional heights
    int totalItems = 0;
    final categoryItemCounts = <int>[];
    
    for (final category in needsCategories) {
      final description = category['description'] as String? ?? '';
      int descWordCount = 0;
      if (description.isNotEmpty) {
        final parts = description.split(',');
        for (final part in parts) {
          final trimmedPart = part.trim();
          if (trimmedPart.isNotEmpty) {
            descWordCount += trimmedPart.split(' ').where((w) => w.isNotEmpty).length;
          }
        }
      }
      final categoryItemCount = 1 + descWordCount; // 1 for category name + description words
      categoryItemCounts.add(categoryItemCount);
      totalItems += categoryItemCount;
    }
    
    // Calculate cumulative Y positions for category boundaries
    double cumulativeHeight = 0.0;
    for (int i = 0; i < needsCategories.length - 1; i++) {
      final categoryItemCount = categoryItemCounts[i];
      final categorySectionHeight = (categoryItemCount / totalItems) * totalHeight;
      cumulativeHeight += categorySectionHeight;
      categoryBoundaryPositions.add(cumulativeHeight);
    }

    // Draw horizontal dashed lines for each row/item
    final itemHeight = totalItems > 0 ? totalHeight / totalItems : totalHeight;
    for (int i = 1; i < totalItems; i++) {
      final y = i * itemHeight;
      
      // Check if this is a category boundary (draw solid line)
      bool isCategoryBoundary = false;
      for (final boundaryY in categoryBoundaryPositions) {
        // Check if y is close to boundary (within 1 pixel tolerance)
        if ((y - boundaryY).abs() < 1.0) {
          isCategoryBoundary = true;
          break;
        }
      }
      
      if (isCategoryBoundary) {
        // Draw bold solid line at category boundaries
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
    // Only draw lines for columns that have descriptors
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
