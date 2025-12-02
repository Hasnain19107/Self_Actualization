import 'package:flutter/material.dart';
import '../const/app_colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double? strokeWidth;
  final double? value;
  final Color? color;
  
  const CustomProgressIndicator({
    super.key,
    this.strokeWidth,
    this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
      strokeWidth: strokeWidth ?? 4.0,
      valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.blue),
    );
  }
}

