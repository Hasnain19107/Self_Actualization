import 'package:flutter/material.dart';
import '../const/app_colors.dart';
import 'custom_text_widget.dart';

class PlanCardWidget extends StatelessWidget {
  final String planName;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanCardWidget({
    super.key,
    required this.planName,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 80),
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(350), // border-350 design token
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.inputBorderGrey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: CustomTextWidget(
                text: "$planName $price",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.blue
                      : AppColors.inputBorderGrey,
                  width: 2,
                ),
                color: isSelected ? AppColors.blue : AppColors.white,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 10,
                        color: AppColors.white,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
