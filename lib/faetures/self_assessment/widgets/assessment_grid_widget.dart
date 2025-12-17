import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controller/review_result_controller.dart';
import '../../../core/const/app_exports.dart';

class AssessmentGridWidget extends StatelessWidget {
  final GlobalKey? repaintBoundaryKey;
  
  const AssessmentGridWidget({super.key, this.repaintBoundaryKey});

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
      return RepaintBoundary(
        key: repaintBoundaryKey,
        child: LayoutBuilder(
        builder: (context, constraints) {
        final leftLabelsWidth = 140.0; // Increased to accommodate longer sub-need texts
        final availableWidth = constraints.maxWidth - leftLabelsWidth - 8;
        final columnWidth = availableWidth / columnCount;
        final gridWidth = columnCount * columnWidth;

        // Calculate grid height to fit available space
        // Reserve space for: gap (10) + bottom labels (estimated 80 for sub-labels) + padding
        final bottomLabelsHeight = 80.0; // Increased to accommodate sub-labels
        final gapHeight = 20.0;
        final availableHeight =
            constraints.maxHeight - bottomLabelsHeight - gapHeight;
        
        // Calculate total items count (category names + sub-needs)
        // Each sub-need is one line item (comma-separated)
        final totalItems = categories.fold<int>(
          0,
          (sum, category) {
            final description = category['description'] as String? ?? '';
            int subNeedCount = 0;
            if (description.isNotEmpty) {
              // Split by comma - each comma-separated item is one sub-need (one line)
              final parts = description.split(',');
              subNeedCount = parts.where((part) => part.trim().isNotEmpty).length;
            }
            // 1 for category name + sub-need count
            return sum + 1 + subNeedCount;
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
                      // Grid with gradient - trapezoid shape (wider at bottom)
                      SizedBox(
                        width: gridWidth,
                        height: gridHeight,
                        child: ClipPath(
                          clipper: TrapezoidClipper(),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: controller.getGradientColors(),
                                stops: controller.getGradientStops(),
                              ),
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
                                final subLabels = controller.getScaleSubLabels(descriptor);
                                
                                return SizedBox(
                                  width: columnWidth,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Main label
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 1.5,
                                        ),
                                        child: CustomTextWidget(
                                          text: descriptor,
                                          fontSize: 4,
                                          fontWeight: FontWeight.w500,
                                          textColor: AppColors.black,
                                          textAlign: TextAlign.center,
                                          maxLines: null,
                                        ),
                                      ),
                                      // Sub-labels
                                      ...subLabels.map(
                                        (subLabel) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 1.5,
                                          ),
                                          child: CustomTextWidget(
                                            text: subLabel,
                                            fontSize: 4,
                                            fontWeight: FontWeight.w500,
                                            textColor: AppColors.black,
                                            textAlign: TextAlign.center,
                                            maxLines: null,
                                          ),
                                        ),
                                      ),
                                    ],
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
      ),
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
    // Each sub-need (comma-separated) is one item
    int totalItems = 0;
    final categoryItemCounts = <int>[];
    
    for (final category in categories) {
      final description = category['description'] as String? ?? '';
      int subNeedCount = 0;
      if (description.isNotEmpty) {
        // Split by comma - each comma-separated item is one sub-need
        final parts = description.split(',');
        subNeedCount = parts.where((part) => part.trim().isNotEmpty).length;
      }
      final categoryItemCount = 1 + subNeedCount; // 1 for category name + sub-need count
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
      final descriptionHeight = categorySectionHeight * 0.8; // 80% for sub-needs
      
      // Category heading
      labels.add(
        SizedBox(
          height: categoryNameHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomTextWidget(
                text: categoryName,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                textColor: AppColors.blue, // Dark blue color
                textAlign: TextAlign.left,
                maxLines: 2,
              ),
            ),
        ),
      );
      
      // Category description as subheading (one sub-need per line, separated by commas)
      if (description.isNotEmpty) {
        // Split description by commas - each comma-separated item is one sub-need
        final parts = description.split(',');
        final subNeeds = parts
            .map((part) => part.trim())
            .where((part) => part.isNotEmpty)
            .toList();
        
        // Calculate height per sub-need
        final subNeedHeight = subNeeds.isNotEmpty ? descriptionHeight / subNeeds.length : 0.0;
        
        // Display each sub-need on a separate line
        for (final subNeed in subNeeds) {
          labels.add(
            SizedBox(
              height: subNeedHeight,
              child: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextWidget(
                    text: subNeed,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.black,
                    textAlign: TextAlign.left,
                    maxLines: 1,
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

  // Taper ratio: top width as percentage of bottom width (0.85 = 85% of bottom width)
  static const double taperRatio = 0.85;

  GridPainter({
    required this.columnCount,
    required this.rowCount,
    required this.gridWidth,
    required this.gridHeight,
    required this.columnWidth,
    required this.needsCategories,
    required this.totalHeight,
  });

  // Calculate width at a given Y position (0 = top, gridHeight = bottom)
  double _getWidthAtY(double y) {
    final topWidth = gridWidth * taperRatio;
    final widthDifference = gridWidth - topWidth;
    // Linear interpolation: at y=0 (top), width = topWidth; at y=gridHeight (bottom), width = gridWidth
    return topWidth + (widthDifference * (y / gridHeight));
  }

  // Calculate left offset at a given Y position to center the trapezoid
  double _getLeftOffsetAtY(double y) {
    final currentWidth = _getWidthAtY(y);
    return (gridWidth - currentWidth) / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dashPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final solidPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Calculate category boundary positions and all horizontal line positions
    final List<double> categoryBoundaryPositions = [];
    final List<double> allHorizontalLinePositions = [];
    
    // Calculate total items to determine proportional heights
    int totalItems = 0;
    final categoryItemCounts = <int>[];
    
    for (final category in needsCategories) {
      final description = category['description'] as String? ?? '';
      int subNeedCount = 0;
      if (description.isNotEmpty) {
        // Split by comma - each comma-separated item is one sub-need
        final parts = description.split(',');
        subNeedCount = parts.where((part) => part.trim().isNotEmpty).length;
      }
      final categoryItemCount = 1 + subNeedCount; // 1 for category name + sub-need count
      categoryItemCounts.add(categoryItemCount);
      totalItems += categoryItemCount;
    }
    
    // Calculate all horizontal line positions and category boundaries
    final itemHeight = totalItems > 0 ? totalHeight / totalItems : totalHeight;
    
    // Calculate cumulative item count to find category boundaries
    int cumulativeItemCount = 0;
    for (int i = 0; i < needsCategories.length - 1; i++) {
      cumulativeItemCount += categoryItemCounts[i];
      // Boundary is at the exact item position (after this category's items)
      final boundaryY = cumulativeItemCount * itemHeight;
      categoryBoundaryPositions.add(boundaryY);
    }
    
    // Calculate all horizontal line positions
    for (int i = 1; i < totalItems; i++) {
      final y = i * itemHeight;
      allHorizontalLinePositions.add(y);
    }

    // Draw center vertical line first (at exact center of grid)
    final boldCenterPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5 // Bold line - thicker than regular lines
      ..style = PaintingStyle.stroke;
    
    // Calculate center X at top and bottom accounting for trapezoid shape
    final topLeftOffsetForCenter = _getLeftOffsetAtY(0);
    final topWidthForCenter = _getWidthAtY(0);
    final topCenterX = topLeftOffsetForCenter + (topWidthForCenter / 2.0);
    
    final bottomLeftOffsetForCenter = _getLeftOffsetAtY(gridHeight);
    final bottomWidthForCenter = _getWidthAtY(gridHeight);
    final bottomCenterX = bottomLeftOffsetForCenter + (bottomWidthForCenter / 2.0);
    
    // Draw center line from top to bottom
    canvas.drawLine(
      Offset(topCenterX, 0),
      Offset(bottomCenterX, gridHeight),
      boldCenterPaint,
    );

    // Vertical lines (columns) - skip center line as it's already drawn
    for (int i = 1; i < columnCount; i++) {
      // Skip drawing if this is the center line (already drawn above)
      final lineX = _getLeftOffsetAtY(0) + (i * (_getWidthAtY(0) / columnCount));
      final isCenterLine = (lineX - topCenterX).abs() < 1.0; // Check if close to center
      
      if (isCenterLine) {
        continue; // Skip, already drawn
      }
      
      // Other vertical lines: draw as rectangles with less distance between dots
      final rectangleWidth = 0.5;
      final rectSize = 3.0; // Size of the rectangle
      const dashSpacing = 6.0; // Distance between rectangles (reduced from itemHeight)
      
      // Draw rectangles along the entire vertical line with reduced spacing
      double currentY = 0;
      while (currentY < gridHeight) {
        // Calculate X position at this Y level
        final leftOffset = _getLeftOffsetAtY(currentY);
        final currentWidth = _getWidthAtY(currentY);
        final x = leftOffset + (i * (currentWidth / columnCount));
        
        // Draw a small rectangle (dash)
        final rect = Rect.fromCenter(
          center: Offset(x, currentY),
          width: rectangleWidth,
          height: rectSize,
        );
        canvas.drawRect(rect, dashPaint);
        
        // Move to next position
        currentY += dashSpacing;
      }
    }

    // Draw horizontal dashed lines for each row/item
    for (int i = 1; i < totalItems; i++) {
      final y = i * itemHeight;
      
      // Calculate width and left offset at this Y position
      final currentWidth = _getWidthAtY(y);
      final leftOffset = _getLeftOffsetAtY(y);
      
      // Check if this is a category boundary (draw solid line)
      bool isCategoryBoundary = false;
      for (final boundaryY in categoryBoundaryPositions) {
        // Check if y is close to boundary (within 2 pixel tolerance for better alignment)
        if ((y - boundaryY).abs() < 2.0) {
          isCategoryBoundary = true;
          break;
        }
      }
      
      if (isCategoryBoundary) {
        // Draw bold solid line at category boundaries
        canvas.drawLine(
          Offset(leftOffset, y),
          Offset(leftOffset + currentWidth, y),
          solidPaint,
        );
      } else {
        // Draw dashed lines for all other internal lines
        _drawDashedLine(
          canvas,
          Offset(leftOffset, y),
          Offset(leftOffset + currentWidth, y),
          dashPaint,
          isVertical: false,
        );
      }
    }

    // Outer border - trapezoid shape (drawn exactly on the clipper edge)
    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final topLeftOffset = _getLeftOffsetAtY(0);
    final topWidth = _getWidthAtY(0);
    final bottomLeftOffset = _getLeftOffsetAtY(gridHeight);
    final bottomWidth = _getWidthAtY(gridHeight);

    // Draw border exactly matching the clipper path coordinates
    final path = Path()
      ..moveTo(topLeftOffset, 0) // Top left - matches clipper
      ..lineTo(topLeftOffset + topWidth, 0) // Top right - matches clipper
      ..lineTo(bottomLeftOffset + bottomWidth, gridHeight) // Bottom right - matches clipper
      ..lineTo(bottomLeftOffset, gridHeight) // Bottom left - matches clipper
      ..close();

    canvas.drawPath(path, borderPaint);
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
      // For angled lines (trapezoid vertical lines)
      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final distance = math.sqrt(dx * dx + dy * dy);
      final steps = (distance / (dashWidth + dashSpace)).ceil();
      
      for (int i = 0; i < steps; i++) {
        final t1 = (i * (dashWidth + dashSpace)) / distance;
        final t2 = ((i * (dashWidth + dashSpace)) + dashWidth) / distance;
        
        if (t1 > 1.0) break;
        final t2Clamped = t2 > 1.0 ? 1.0 : t2;
        
        final p1 = Offset(
          start.dx + dx * t1,
          start.dy + dy * t1,
        );
        final p2 = Offset(
          start.dx + dx * t2Clamped,
          start.dy + dy * t2Clamped,
        );
        
        canvas.drawLine(p1, p2, paint);
      }
    } else {
      // Horizontal lines
      double startX = start.dx;
      final double startY = start.dy;
      final double endX = end.dx;

      while (startX < endX) {
        final dashEndX = (startX + dashWidth < endX) ? startX + dashWidth : endX;
        canvas.drawLine(
          Offset(startX, startY),
          Offset(dashEndX, startY),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrapezoidClipper extends CustomClipper<Path> {
  // Taper ratio: top width as percentage of bottom width (0.75 = 75% of bottom width)
  static const double taperRatio = 0.85;

  @override
  Path getClip(Size size) {
    final topWidth = size.width * taperRatio;
    final leftOffset = (size.width - topWidth) / 2;

    final path = Path()
      ..moveTo(leftOffset, 0) // Top left
      ..lineTo(leftOffset + topWidth, 0) // Top right
      ..lineTo(size.width, size.height) // Bottom right
      ..lineTo(0, size.height) // Bottom left
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
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
      ..strokeWidth = 2.5
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
