import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../../../core/utils/app_sizes.dart';

/// Header widget for Plan Details screen
/// Displays back button, plan name, and price
class PlanDetailsHeaderWidget extends StatelessWidget {
  final String planName;
  final String planPrice;
  final VoidCallback? onBackPressed;

  const PlanDetailsHeaderWidget({
    super.key,
    required this.planName,
    required this.planPrice,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appSizes = AppSizes();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: appSizes.getWidthPercentage(4),
        vertical: appSizes.getHeightPercentage(2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button
          GestureDetector(
            onTap: onBackPressed ?? () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.inputBorderGrey,
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.black,
                size: 18,
              ),
            ),
          ),
          // Plan Name (centered)
          CustomTextWidget(
            text: planName,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            textColor: AppColors.black,
            textAlign: TextAlign.center,
          ),
          // Plan Price
          CustomTextWidget(
            text: planPrice,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            textColor: AppColors.black,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

