import 'package:flutter/material.dart';
import '../const/app_colors.dart';

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final double size;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final double borderWidth;
  final double iconSize;

  const CustomRadioButton({
    super.key,
    required this.isSelected,
    this.size = 20,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.borderWidth = 2,
    this.iconSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? (selectedBorderColor ?? AppColors.blue)
              : (unselectedBorderColor ?? AppColors.inputBorderGrey),
          width: borderWidth,
        ),
        color: isSelected
            ? (selectedColor ?? AppColors.blue)
            : (unselectedColor ?? AppColors.white),
      ),
      child: isSelected
          ? Center(
              child: Icon(Icons.circle, size: iconSize, color: AppColors.white),
            )
          : null,
    );
  }
}
