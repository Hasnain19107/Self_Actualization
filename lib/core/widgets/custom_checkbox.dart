import 'package:flutter/material.dart';
import '../Const/app_colors.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      side:  BorderSide(
        color: AppColors.grey,
        width: 0.5,
      ),
    );
  }
}
