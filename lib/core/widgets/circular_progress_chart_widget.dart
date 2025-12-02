import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../const/app_colors.dart';

class CircularProgressChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? segments;
  
  const CircularProgressChartWidget({
    super.key,
    this.segments,
  });
  
  // Get icon for goal type (goal-related icons)
  static IconData _getIconForGoalType(String goalType) {
    switch (goalType) {
      case 'Career':
        return Icons.assignment; // Career goals/tasks
      case 'Health':
        return Icons.fitness_center; // Health goals
      case 'Spiritual':
        return Icons.self_improvement; // Spiritual goals
      case 'Personal':
      default:
        return Icons.flag; // Personal goals/targets
    }
  }
  
  // Get center icon based on segments
  IconData get _centerIcon {
    if (segments == null || segments!.isEmpty) {
      return Icons.flag; // Default goal icon
    }
    // Use the first goal's type to determine center icon
    final firstSegment = segments!.first;
    final goalType = firstSegment['goalType'] as String?;
    if (goalType != null) {
      return _getIconForGoalType(goalType);
    }
    return Icons.flag; // Default goal icon
  }
  
  // Get perimeter icons based on segments
  List<Map<String, dynamic>> get _perimeterIcons {
    if (segments == null || segments!.isEmpty) {
      return [];
    }
    
    return segments!.asMap().entries.map((entry) {
      final segment = entry.value;
      final goalType = segment['goalType'] as String? ?? 'Personal';
      
      return {
        'angle': segment['angle'] as double,
        'icon': _getIconForGoalType(goalType),
        'color': segment['color'] as Color,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chartSegments = this.segments ?? [];
    final perimeterIcons = _perimeterIcons;
    
    return Opacity(
      opacity: 1,
      child: Transform.rotate(
        angle: 0, // 0 degrees
        child: SizedBox(
          width: 155,
          height: 150,
          child: Stack(
            children: [
              CustomPaint(
                painter: CircularChartPainter(segments: chartSegments),
                child: const SizedBox.expand(),
              ),
              // Center icon
              Center(
                child: Icon(_centerIcon, color: AppColors.white, size: 26),
              ),
              // Icons perfectly aligned to arc stroke
              ...perimeterIcons.map((iconData) {
                return _buildPerimeterIcon(
                  angle: iconData['angle'] as double,
                  icon: iconData['icon'] as IconData,
                  color: iconData['color'] as Color,
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerimeterIcon({
    required double angle,
    required IconData icon,
    Color? color,
  }) {
    final radians = angle * math.pi / 180;
    const size = Size(155, 150);
    final center = Offset(size.width / 2, size.height / 2);

    const strokeWidth = 26.0;
    final arcRadius = size.width / 2.4;
    final iconRadius = arcRadius - strokeWidth / 2 + 2;
    // +2 to fine-tune visually on stroke center

    final offsetX = center.dx + iconRadius * math.cos(radians);
    final offsetY = center.dy + iconRadius * math.sin(radians);

    return Positioned(
      left: offsetX - 18,
      top: offsetY - 18,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0x66000000), // #00000066 - 40% opacity black
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class CircularChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> segments;
  
  CircularChartPainter({required this.segments});
  
  @override
  void paint(Canvas canvas, Size size) {
    if (segments.isEmpty) {
      // Draw default segments if no goals
      final defaultSegments = [
        _ArcSegment(120, const Color(0xFFD3E85D)), // Lime
        _ArcSegment(150, const Color(0xFF7AC4E6)), // Sky Blue
        _ArcSegment(90, const Color(0xFFE9C6F2)), // Light Pink
      ];
      _drawSegments(canvas, size, defaultSegments);
      return;
    }
    
    // Convert segments to _ArcSegment list
    final arcSegments = segments.map((seg) {
      return _ArcSegment(
        seg['sweepAngle'] as double,
        seg['color'] as Color,
      );
    }).toList();
    
    _drawSegments(canvas, size, arcSegments);
  }
  
  void _drawSegments(Canvas canvas, Size size, List<_ArcSegment> arcSegments) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.4;
    const strokeWidth = 24.0;
    const startAngle = -math.pi / 2;

    double currentStart = startAngle;

    for (final seg in arcSegments) {
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentStart,
        seg.sweepAngle * math.pi / 180,
        false,
        paint,
      );

      currentStart += seg.sweepAngle * math.pi / 180;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CircularChartPainter) {
      return oldDelegate.segments != segments;
    }
    return true;
  }
}

class _ArcSegment {
  final double sweepAngle;
  final Color color;
  const _ArcSegment(this.sweepAngle, this.color);
}
