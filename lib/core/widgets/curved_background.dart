import 'package:flutter/material.dart';
import '../Const/app_colors.dart';

class CurvedBackground extends StatelessWidget {
  final Widget child;
  final double height;

  const CurvedBackground({super.key, required this.child, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, height),
          painter: CurvedPainter(),
        ),
        child,
      ],
    );
  }
}

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.blue
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start from top-left
    path.moveTo(0, 0);

    // Draw top edge
    path.lineTo(size.width, 0);

    // Draw right edge down
    path.lineTo(size.width, size.height * 0.40);

    // Create a very smooth, rounded wave using cubic bezier
    // More rounded control points for a gentler curve
    path.cubicTo(
      size.width * 0.98,
      size.height * 0.45,
      size.width * 0.90,
      size.height * 0.60,
      size.width * 0.75,
      size.height * 0.72,
    );

    path.cubicTo(
      size.width * 0.60,
      size.height * 0.82,
      size.width * 0.50,
      size.height * 0.88,
      size.width * 0.40,
      size.height * 0.82,
    );

    path.cubicTo(
      size.width * 0.25,
      size.height * 0.72,
      size.width * 0.10,
      size.height * 0.60,
      size.width * 0.02,
      size.height * 0.45,
    );

    path.cubicTo(
      size.width * 0.01,
      size.height * 0.43,
      0,
      size.height * 0.41,
      0,
      size.height * 0.40,
    );

    // Close the path back to start
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
