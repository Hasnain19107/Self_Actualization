import 'package:flutter/material.dart';
import '../../../core/const/app_exports.dart';

class SubscriptionCardWidget extends StatelessWidget {
  final String planName;
  final String price;
  final VoidCallback? onTap;
  final bool isCurrentPlan;

  const SubscriptionCardWidget({
    super.key,
    required this.planName,
    required this.price,
    this.onTap,
    this.isCurrentPlan = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 335,
        height: 56,
        padding: const EdgeInsets.only(
          top: 12,
          right: 16,
          bottom: 12,
          left: 16,
        ),
        decoration: BoxDecoration(
          color: isCurrentPlan
              ? AppColors.lightBlue.withOpacity(0.5)
              : AppColors.lightBlue,
          borderRadius: BorderRadius.circular(30), // border-350 design token
          border: isCurrentPlan
              ? Border.all(
                  color: AppColors.blue,
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomTextWidget(
                  text: '$planName $price',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.black,
                  textAlign: TextAlign.left,
                ),
                if (isCurrentPlan) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const CustomTextWidget(
                      text: 'Current',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}