import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';

class CircularProgressChartWidget extends StatelessWidget {
  const CircularProgressChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                painter: CircularChartPainter(),
                child: const SizedBox.expand(),
              ),
              // Center icon
              const Center(
                child: Icon(Icons.eco, color: AppColors.white, size: 26),
              ),
              // Icons perfectly aligned to arc stroke
              _buildPerimeterIcon(
                angle: -60, // top-right
                icon: Icons.local_florist,
              ),
              _buildPerimeterIcon(
                angle: 60, // bottom-right
                icon: Icons.local_cafe,
              ),
              _buildPerimeterIcon(
                angle: 180, // left side
                icon: Icons.bed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerimeterIcon({required double angle, required IconData icon}) {
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF5E6B6B),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class CircularChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.4;
    const strokeWidth = 24.0;
    const startAngle = -math.pi / 2;

    final segments = [
      _ArcSegment(120, const Color(0xFFD3E85D)), // Lime
      _ArcSegment(150, const Color(0xFF7AC4E6)), // Sky Blue
      _ArcSegment(90, const Color(0xFFE9C6F2)), // Light Pink
    ];

    double currentStart = startAngle;

    for (final seg in segments) {
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ArcSegment {
  final double sweepAngle;
  final Color color;
  const _ArcSegment(this.sweepAngle, this.color);
}
