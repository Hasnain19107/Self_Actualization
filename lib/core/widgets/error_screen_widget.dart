import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../const/app_exports.dart';

class ErrorScreenWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final String? title;

  const ErrorScreenWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.red,
                size: 40,
              ),
            ),
            const Gap(24),
            // Title
            CustomTextWidget(
              text: title ?? 'Something went wrong',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textColor: AppColors.black,
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            // Error Message
            CustomTextWidget(
              text: errorMessage,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: AppColors.mediumGray,
              textAlign: TextAlign.center,
            ),
            const Gap(32),
            // Retry Button
            CustomElevatedButton(
              text: 'Retry',
              backgroundColor: AppColors.blue,
              textColor: AppColors.white,
              onPress: onRetry,
              width: 200,
              borderRadius: 1000,
              height: 58,
            ),
          ],
        ),
      ),
    );
  }
}

