import 'package:flutter/material.dart';
import '../../../core/const/app_exports.dart';

class SubscriptionCardWidget extends StatelessWidget {
  final String planName;
  final String price;
  final VoidCallback? onTap;

  const SubscriptionCardWidget({
    super.key,
    required this.planName,
    required this.price,
    this.onTap,
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
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(30), // border-350 design token
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              text: '$planName $price',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textColor: AppColors.black,
              textAlign: TextAlign.left,
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